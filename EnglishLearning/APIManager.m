//
//  APIManager.m
//  EnglishLearning
//
//  Created by TML BD on 4/3/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import "APIManager.h"
#import "AFHTTPRequestOperation.h"
#import "AFNetworkReachabilityManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "Case.h"
#import "TMLAppDelegate.h"
#import "Quizz.h"


#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define episodeListAPI [NSURL URLWithString:@"http://leoapi.themessengerbd.com/episodlist"]
#define upToDateInfoAPI [NSURL URLWithString:@"http://leoapi.themessengerbd.com/uptodate"]
#define caseListAPI @"http://leoapi.themessengerbd.com/caselist/"
#define sendMailApi @"http://leoapi.themessengerbd.com"

@implementation APIManager{
    Episode *downloadingEpisode;
}

#pragma mark - Main Methods

-(void)fetchEpisodeListFromApi{
    
    __block NSArray *_episodeList = [[NSMutableArray alloc] init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestOperation *op =  [manager HTTPRequestOperationWithRequest:[NSURLRequest requestWithURL:episodeListAPI] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            _episodeList = [self extractEpisodesFromApiResponse:responseObject];
            /*//NSLog(@"%@",responseObject);
            //for checking
            for (Episode *ep in _episodeList) {
                NSLog(@"%@",ep.episodeTitle);
            }*/
            
            [self.delegate resultsForFetchingEpisodeList:_episodeList];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (error.code == -1009) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Failed" message:@"Check your internet connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
            }

        }];
        [op start];
    
}

-(void)tryToUpdateEpisode:(Episode *)episode{
    downloadingEpisode = episode;
    
    //loading cases
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",caseListAPI,episode.episodeId]];//NSLog(@"calling %@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self processEpisodeUpdate:responseObject forEpisode:episode];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate triedToUpdateEpisode:episode];
            //*****change this
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Downloading Episode"
//                                                            message:[error localizedDescription]
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"Ok"
//                                                  otherButtonTitles:nil];
//        [alertView show];
    }];
    
    
    [operation start];
    
    

}

-(void)downloadEpisode:(Episode *)episode{
    downloadingEpisode = episode;
    
    //loading cases
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",caseListAPI,episode.episodeId]];//NSLog(@"calling %@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    [self processEpisodeDownload:responseObject forEpisode:episode];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Downloading Episode"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    
    [operation start];
    
    
}

-(void)sendMail:(NSDictionary *)dic{

//    NSURL *url = [NSURL URLWithString:[mailApi stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    //NSURL *url = [NSURL URLWithString:@"http://leoapi.themessengerbd.com/queries/sohagfaruque@yahoo.com/hello%20admin/hello%20it%20is%20a%20test%20query123456"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    operation.responseSerializer = [AFJSONResponseSerializer serializer];
//    
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        //[self processEpisodeDownload:responseObject forEpisode:episode];
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Successfully Sent"
//                                                            message:@"Your mail hase been sent"
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"Ok"
//                                                  otherButtonTitles:nil];
//        [alertView show];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Sending Mail"
//                                                            message:[error localizedDescription]
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"Ok"
//                                                  otherButtonTitles:nil];
//        [alertView show];
//    }];
//    
//    
//    [operation start];


    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:sendMailApi]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[dic objectForKey:@"userEmail"],@"userEmail",[dic objectForKey:@"queryType"],@"queryType",[dic objectForKey:@"msgBody"],@"msgBody", nil];
    
    NSLog(@"%@",params);
    //NSData *imageData = UIImagePNGRepresentation(userfile);
    [manager POST:@"queries" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Successful" message:@"Your query is successfully submitted" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Failed" message:@"Your query is failed" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
    }];
    
    
}


-(void)fetchUptoDateInformation{
    __block NSMutableArray *_infos = [[NSMutableArray alloc] init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *op =  [manager HTTPRequestOperationWithRequest:[NSURLRequest requestWithURL:upToDateInfoAPI] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *results = [responseObject objectForKey:@"results"]; NSLog(@"results%@",[responseObject objectForKey:@"results"]);
        for (NSDictionary *dic in results) {
            [_infos addObject:dic];
        }
        
        [self.delegate uptoDateInFormation:_infos];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error.code == -1009) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Failed" message:@"Check your internet connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
        
    }];
    [op start];
}


#pragma mark - Helper Methods

- (NSArray *)extractEpisodesFromApiResponse:(id)responseObject{
    NSMutableArray *episodeList = [[NSMutableArray alloc] init];
    
    NSArray *objects = [responseObject objectForKey:@"results"];
    Episode *episode;
    for (NSDictionary *dic in objects) {
        episode = [[Episode alloc] init];
        episode.episodeId = [dic objectForKey:@"id"];
        episode.episodeTitle = [dic objectForKey:@"title"];
        episode.catagoryTitle = [dic objectForKey:@"cat_title"];
        episode.imageLink = [dic objectForKey:@"image"];
        
        [episodeList addObject:episode];
        episode = nil;
    }
    
    return episodeList;
}

- (void)downloadAudioForCase:(Case *)cse ofEpisode:(Episode *)episode{
//    __block Case *_case = cse;
//    
//    NSURL *url = [NSURL URLWithString:cse.track_link];NSLog(@"link - %@",url);
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    
//    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Audio"];
//    __block NSString *_fullPath = [dataPath stringByAppendingPathComponent:[url lastPathComponent]];
//    NSLog(@"path - %@",_fullPath);
//    
//    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:_fullPath append:NO]];
//    
//    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, NSInteger totalBytesRead, NSInteger totalBytesExpectedToRead) {
//       // NSLog(@"bytesRead: %u, totalBytesRead: %ld, totalBytesExpectedToRead: %ld", bytesRead, (long)totalBytesRead, (long)totalBytesExpectedToRead);
//    }];
//    
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
////        NSLog(@"RES: %@", [[[operation response] allHeaderFields] description]);
////        
////        NSError *error;
////        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:&error];
////        
////        if (error) {
////            NSLog(@"ERR: %@", [error description]);
////        } else {
////            NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
////            long long fileSize = [fileSizeNumber longLongValue];
////            NSLog(@"file size - %lld",fileSize);
////            //[[_downloadFile titleLabel] setText:[NSString stringWithFormat:@"%lld", fileSize]];
////        }
//        NSLog(@"download completed");
//        _case.track_link = _fullPath;
//        ////just insert database
//        TMLAppDelegate *appDel = (TMLAppDelegate *)[UIApplication sharedApplication].delegate;
//        [appDel.databaseManager insertCase:cse forEpisode:episode];
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"ERR downloadin case: %@", [error description]);
//    }];
//    
//    [operation start];

    //download the file in a seperate thread.
    NSString  *filePath = nil;
    
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSLog(@"Audio Downloading Started");
    NSURL  *url = [NSURL URLWithString:cse.track_link];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if ( urlData )
    {
        NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString  *documentsDirectory = [paths objectAtIndex:0];
        //NSLog(@"doc dir -%@",documentsDirectory);
        
        NSString *extnsn = [cse.track_link substringFromIndex:([cse.track_link length]-4)];
        
        filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/Audio/e%@c%@%@",episode.episodeId,cse.caseId,extnsn]];//
        
        
        //saving is done on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [urlData writeToFile:filePath atomically:YES];
        });
    }

    cse.track_link = filePath;
    TMLAppDelegate *appDel = (TMLAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDel.databaseManager insertCase:cse forEpisode:episode];


}

- (void)processEpisodeDownload:(id)responseObject forEpisode:(Episode *)episode{
    NSArray* objects = [responseObject objectForKey:@"results"];
    
    
    //*******//download quizz
    [self downloadQuizesForEpisode:episode];
    
    ///saving cases
    for (NSDictionary *obj in objects) {
        
        Case *cse = [[Case alloc]init];
        
        cse.caseId = [obj objectForKey:@"id"];
        cse.caseTitle = [obj objectForKey:@"title"];
        cse.doc_eng = [obj objectForKey:@"eng_doc"];
        cse.doc_jpn = [obj objectForKey:@"jpn_doc"];
        cse.track_link = [obj objectForKey:@"track"];
        
        
        
        //*******//download phrase
        [self extractPhrases:[obj objectForKey:@"phrase"] ForEpisode:episode andCase:cse];
        [self downloadAudioForCase:cse ofEpisode:episode];
        
    }
    
    
    TMLAppDelegate *appDel = (TMLAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDel.databaseManager insertEpisodeIntoDatabase:episode];
    
    
    ///tell delegate that episode is downloaded
    [self.delegate episodeIsDownloaded];
}



- (void)processEpisodeUpdate:(id)responseObject forEpisode:(Episode *)episode{
    NSArray* objects = [responseObject objectForKey:@"results"];
    //*******//download quizz
    [self downloadQuizesForEpisode:episode];
    
    ///saving cases
    for (NSDictionary *obj in objects) {
        
        Case *cse = [[Case alloc]init];
        
        cse.caseId = [obj objectForKey:@"id"];
        cse.caseTitle = [obj objectForKey:@"title"];
        cse.doc_eng = [obj objectForKey:@"eng_doc"]; //NSLog(@"%@",cse.doc_eng);
        cse.doc_jpn = [obj objectForKey:@"jpn_doc"];
        //cse.track_link = [obj objectForKey:@"track"];
        //cse.track_link =
        //Case *newcase = cse;
        TMLAppDelegate *appDel = (TMLAppDelegate *)[UIApplication sharedApplication].delegate;
        cse.track_link = [appDel.databaseManager getTrackLinkForCase:cse andEpisode:episode];
        //*******//download phrase
        //TMLAppDelegate *appDel = (TMLAppDelegate *)[UIApplication sharedApplication].delegate;
        [appDel.databaseManager deletePhrasesforEpisode:episode andCase:cse];
        [self extractPhrases:[obj objectForKey:@"phrase"] ForEpisode:episode andCase:cse];
        //[self downloadAudioForCase:cse ofEpisode:episode];
        if ([appDel.databaseManager ifCase:cse SavedInDatabaseForEpisode:episode]) {
            [appDel.databaseManager deleteCase:cse forEpisode:episode];
            [appDel.databaseManager insertCase:cse forEpisode:episode];
            
        }
        else{
            [self downloadAudioForCase:cse ofEpisode:episode];
        }
        
    }
    
    [self.delegate triedToUpdateEpisode:episode];
    //TMLAppDelegate *appDel = (TMLAppDelegate *)[UIApplication sharedApplication].delegate;
    //*****Change this[appDel.databaseManager insertEpisodeIntoDatabase:episode];
    
    
    ///tell delegate that episode is downloaded
    
}


- (void)downloadQuizesForEpisode:(Episode *)episode{
    TMLAppDelegate *appDel = (TMLAppDelegate *)[UIApplication sharedApplication].delegate;

    //deletee first
    [appDel.databaseManager deleteQuizesforEpisode:episode];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://leoapi.themessengerbd.com/wordquiz/%@",episode.episodeId]];
    AFHTTPRequestOperation *op =  [manager HTTPRequestOperationWithRequest:[NSURLRequest requestWithURL:url] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Quizz *quiz;
        
        NSArray *objects = [responseObject objectForKey:@"results"];
        for (NSDictionary *obj in objects) {
            quiz = [[Quizz alloc] init];
            quiz.type = [obj objectForKey:@"type"];
            quiz.question = [obj objectForKey:@"qus"];
            quiz.choise1 = [obj objectForKey:@"opt1"];
            quiz.choise2 = [obj objectForKey:@"opt2"];
            quiz.choise3 = [obj objectForKey:@"opt3"];
            quiz.choise4 = [obj objectForKey:@"opt4"];
            quiz.answer = [obj objectForKey:@"ans"];
            
            [appDel.databaseManager insertQuiz:quiz forEpisode:episode];
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error in fetchin quizz %@",error.localizedDescription);
        
    }];
    [op start];
}


- (void)extractPhrases:(NSArray *)phrases ForEpisode:(Episode *)episode andCase:(Case *)cse{

    Phrase *phrase;
    
        for (NSDictionary *obj in phrases) {
            phrase = [[Phrase alloc] init];
            phrase.eng_version = [obj objectForKey:@"Eng_Phrase"];
            phrase.jpn_version = [obj objectForKey:@"Jap_Phrase"];
            //phrase.eng_exmpl = [obj objectForKey:@"eng_exmpl"];
            //phrase.jpn_exmpl = [obj objectForKey:@"jpn_exmpl"];
            
            
            TMLAppDelegate *appDel = (TMLAppDelegate *)[UIApplication sharedApplication].delegate;
            [appDel.databaseManager insertPhrase:phrase forEpisode:episode andCase:cse];
        }
        
        
}


- (void)downloadImageForEpisode:(Episode *)episode fromLink:(NSString *)link{
    if (![self checkIfImageAlreadyExistsForEpisode:episode]) {
        NSURL  *url = [NSURL URLWithString:link];
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        if ( urlData )
        {
            NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString  *documentsDirectory = [paths objectAtIndex:0];
            //NSLog(@"doc dir -%@",documentsDirectory);
            
            //NSString *extnsn = [link substringFromIndex:([link length]-4)];
            
            NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/Image/%@.png",episode.catagoryTitle]];//
            
            
            //saving is done on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [urlData writeToFile:dataPath atomically:YES];
            });
        }

    }
}

- (BOOL)checkIfImageAlreadyExistsForEpisode:(Episode *)episode{
    BOOL success = NO;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/Image/%@.png",episode.catagoryTitle]];
    //error = nil;
    
    //if no such folder exists, create it
    if ([[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
        return YES;
    }
    
    return success;
}

@end
