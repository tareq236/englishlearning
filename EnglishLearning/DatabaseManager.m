//
//  DatabaseManager.m
//  EnglishLearning
//
//  Created by TML BD on 4/3/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import "DatabaseManager.h"
#import "FMDatabase.h"
#import "Episode.h"
#import "FMResultSet.h"

@implementation DatabaseManager{
    FMDatabase *db;
}

-(id)initWtithDatabaseName:(NSString *)database{
    
    self = [super init];
    [self checkForDatabaseFile:database];
    [self createDatabaseManagerWithName:database];
    return self;
}

- (BOOL)insertEpisodeIntoDatabase:(Episode *)episode{
    BOOL success = NO;
    
    @try {
        [db open];
        success = [db executeUpdate:@"INSERT into EpisodeList (e_id, e_title, e_cat) Values(?,?,?);",episode.episodeId,episode.episodeTitle,episode.catagoryTitle, nil];
        
    }
    @catch (NSException *exception) {
        NSLog(@"error in database fetching- %@",[exception description]);
    }
    @finally {
        [db close];
    }
    
    return success;
}

-(NSArray *)getEpisodeListFromDatabase{
    NSMutableArray *episodeList = [[NSMutableArray alloc] init];
    
    @try {
        [db open];
        FMResultSet *results = [db executeQuery:@"SELECT * from EpisodeList"];
        
        while ([results next]) {
            Episode *episode = [[Episode alloc] init];
            episode.episodeId = [results stringForColumn:@"e_id"];
            episode.episodeTitle = [results stringForColumn:@"e_title"];
            episode.catagoryTitle = [results stringForColumn:@"e_cat"];
            episode.isSaved = YES;
//            episode.imageLink = [results stringForColumn:@"e_img"];
//
//            
//            if ([[results stringForColumn:@"selected"] isEqualToString:@"Yes"]) {
//                episode.isSelected = YES;
//            }else episode.isSelected = NO;
            
            [episodeList addObject:episode];//NSLog(@"fetched ---%@",episode.title);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"error in database fetching- %@",[exception description]);
    }
    @finally {
        [db close];
    }
    
    
    return episodeList;
}


-(BOOL)ifEpisodeSavedInDatabase:(Episode *)episode{
    BOOL success = YES;
    
    @try {
        [db open];
        FMResultSet *results = [db executeQuery:[NSString stringWithFormat:@"SELECT * from EpisodeList where e_id=%@",episode.episodeId]];
        
        
        int count = 0;
        while ([results next]) {
            count ++;
        }
        if (count==0) {
            return NO;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"error in database fetching- %@",[exception description]);
    }
    @finally {
        [db close];
    }
    
    return success;
}


-(BOOL)ifCase:(Case *)cse SavedInDatabaseForEpisode:(Episode *)episode{
    BOOL success = YES;
    
    @try {
        [db open];
        FMResultSet *results = [db executeQuery:[NSString stringWithFormat:@"SELECT * from CaseList where e_id=%@ and c_id=%@",episode.episodeId,cse.caseId]];
        
        
        int count = 0;
        while ([results next]) {
            count ++;
        }
        if (count==0) {
            return NO;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"error in database fetching- %@",[exception description]);
    }
    @finally {
        [db close];
    }
    
    return success;
}


-(Episode *)getEpisodeFromDatabaseForId:(NSString *)episodeId{
    Episode *fetchedEpisode;
    
    @try {
        [db open];
        FMResultSet *results = [db executeQuery:[NSString stringWithFormat:@"SELECT * from EpisodeList where e_id=%@",episodeId]];
        
        
        while ([results next]) {
            fetchedEpisode = [[Episode alloc]init];
            fetchedEpisode.episodeId = [results stringForColumn:@"e_id"];
            fetchedEpisode.episodeTitle = [results stringForColumn:@"e_title"];
            fetchedEpisode.catagoryTitle = [results stringForColumn:@"e_cat"];
            fetchedEpisode.isSaved = YES;
            
            fetchedEpisode.quizes = [self getQuizesForEpisode:fetchedEpisode];
            fetchedEpisode.cases = [self getCasesForEpisode:fetchedEpisode];
            
        }

    }
    @catch (NSException *exception) {
        NSLog(@"error in database fetching- %@",[exception description]);
    }
    @finally {
        [db close];
    }
    
    return fetchedEpisode;
}

-(BOOL)insertCase:(Case *)cse forEpisode:(Episode *)episode{
    
    //[self deleteCase:cse forEpisode:episode];
    
    BOOL success = NO;
    
    @try {
        [db open];
        success = [db executeUpdate:@"INSERT into CaseList (e_id, c_id, c_title, eng_doc, jpn_doc, track) Values(?,?,?,?,?,?);",episode.episodeId,cse.caseId,cse.caseTitle,cse.doc_eng,cse.doc_jpn,cse.track_link, nil];
        NSLog(@"case inserted");
    }
    @catch (NSException *exception) {
        NSLog(@"error in case inserting- %@",[exception description]);
    }
    @finally {
        [db close];
    }
    

    return success;
}


-(BOOL)deleteCase:(Case *)cse forEpisode:(Episode *)episode{
    BOOL success = NO;
    
    @try {
        [db open];
        success = [db executeUpdate:[NSString stringWithFormat:@"Delete From CaseList where e_id='%@' and c_id='%@'",episode.episodeId,cse.caseId]];
        //NSLog(@"case inserted");
    }
    @catch (NSException *exception) {
        NSLog(@"error in case deleting- %@",[exception description]);
    }
    @finally {
        [db close];
    }
    
    
    return success;
}


-(BOOL)insertQuiz:(Quizz *)quiz forEpisode:(Episode *)episode{
    
    //[self deleteQuiz:quiz forEpisode:episode];
    
    BOOL success = NO;
    
    @try {
        [db open];
        success = [db executeUpdate:@"INSERT into QuizList (type, e_id, ques, choise1, choise2, choise3, choise4, ans) Values(?,?,?,?,?,?,?,?);",quiz.type,episode.episodeId,quiz.question, quiz.choise1,quiz.choise2,quiz.choise3,quiz.choise4,quiz.answer, nil];
        NSLog(@"quizz inserted");
    }
    @catch (NSException *exception) {
        NSLog(@"error in quiz inserting- %@",[exception description]);
    }
    @finally {
        [db close];
    }
    
    
    return success;
}

-(BOOL)deleteQuizesforEpisode:(Episode *)episode{
    BOOL success = NO;
    
    @try {
        [db open];
        success = [db executeUpdate:[NSString stringWithFormat:@"Delete From QuizList where e_id='%@'",episode.episodeId]];
        //NSLog(@"case inserted");
    }
    @catch (NSException *exception) {
        NSLog(@"error in case deleting- %@",[exception description]);
    }
    @finally {
        [db close];
    }
    
    
    return success;
}

-(BOOL)insertPhrase:(Phrase *)phrase forEpisode:(Episode *)episode andCase:(Case *)cse{
    
    //[self deletePhrase:phrase forEpisode:episode andCase:cse];
    
    BOOL success = NO;
    
    @try {
        [db open];
        success = [db executeUpdate:@"INSERT into PhraseList (e_id, c_id, eng, jpn, eng_exmpl, jpn_exmpl, isNew, isBookmarked) Values(?,?,?,?,?,?,?,?);",episode.episodeId,cse.caseId,phrase.eng_version,phrase.jpn_version,phrase.eng_exmpl,phrase.jpn_exmpl,@"Yes",@"No", nil];
        NSLog(@"phrase inserted");
    }
    @catch (NSException *exception) {
        NSLog(@"error in phrase inserting- %@",[exception description]);
    }
    @finally {
        [db close];
    }
    
    
    return success;
}

-(BOOL)deletePhrasesforEpisode:(Episode *)episode andCase:(Case *)cse{
    BOOL success = NO;
    
    @try {
        [db open];
        success = [db executeUpdate:[NSString stringWithFormat:@"Delete From PhraseList where e_id='%@' and c_id='%@'",episode.episodeId,cse.caseId]];
        //NSLog(@"case inserted");
    }
    @catch (NSException *exception) {
        NSLog(@"error in case deleting- %@",[exception description]);
    }
    @finally {
        [db close];
    }
    
    
    return success;
}

-(NSArray *)getPhrasesFromDatabase{
    NSMutableArray *phrases = [[NSMutableArray alloc]init];
    Phrase *phrase;
    
    @try {
        [db open];
        FMResultSet *results = [db executeQuery:[NSString stringWithFormat:@"SELECT * from PhraseList"]];
        
        
        while ([results next]) {
            phrase = [[Phrase alloc]init];
            phrase.eng_version = [results stringForColumn:@"eng"];
            phrase.jpn_version = [results stringForColumn:@"jpn"];
            phrase.eng_exmpl = [results stringForColumn:@"eng_exmpl"];
            phrase.jpn_exmpl = [results stringForColumn:@"jpn_exmpl"];
            
            if ([[results stringForColumn:@"isNew"] isEqualToString:@"Yes"]) {
                phrase.isNew = YES;
            }else phrase.isNew = NO;
            
            if ([[results stringForColumn:@"isBookmarked"] isEqualToString:@"Yes"]) {
                phrase.isBookmarked = YES;
            }else phrase.isBookmarked = NO;
            
            [phrases addObject:phrase];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"error in database fetching- %@",[exception description]);
    }
    @finally {
        [db close];
    }
    
    return phrases;

}

-(void)createDemoCases{
    
    NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/Image/Home.png"]];
    NSData *imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Home.png" ofType:nil]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
        [imageData writeToFile:dataPath atomically:YES];
    }
    
    //check if already exists
    Quizz *quiz = [[Quizz alloc]init];
    quiz.type = @"Demo Type";
    quiz.question = @"Demo Question";
    quiz.answer = @"Demo Answer 3";
    quiz.choise1 = @"Demo Answer 1";
    quiz.choise2 = @"Demo Answer 2";
    quiz.choise3 = @"Demo Answer 3";
    quiz.choise4 = @"Demo Answer 4";
    
    Phrase *phrase = [[Phrase alloc]init];
    phrase.isNew = NO;
    phrase.isBookmarked = NO;
    phrase.jpn_exmpl = @"これはデモのエピソードです。何エピソードがダ";
    phrase.eng_exmpl = @"Demo Example";
    phrase.jpn_version = @"ドです";
    phrase.eng_version = @"Phrase";
    Episode *episode = [[Episode alloc] init];
    episode.episodeId = @"2505";
    episode.isSaved = YES;
    episode.episodeTitle = @"Demo Episode";
    episode.quizes = [NSArray arrayWithObject:quiz];
    episode.catagoryTitle = @"Home";
    //episde.phrases
    @try {
        [db open];
        FMResultSet *results = [db executeQuery:[NSString stringWithFormat:@"Select * from CaseList where e_id='2505'"]];
        if (![results next]) {
            //load from main bundle and save to database
            NSString *endDoc = @"This is a demo episode. I no episode is downloaded or selected for the alarm, this episode automatically set for the alarm.";
            NSString *jpnDoc = @"これはデモのエピソードです。何エピソードがダウンロードされていないか、アラームを選択している私は、このエピソードは自動的にアラームの設定";
            
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            
            NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Audio/case2505.mp3"];
            NSError *error = nil;
            NSString *pathFromApp = [[NSBundle mainBundle] pathForResource:@"case2505.mp3" ofType:nil];NSLog(@"%@",pathFromApp);
            [[NSFileManager defaultManager] copyItemAtPath:pathFromApp toPath:dataPath error:&error];
            
            //NSString *temp = @"2505", *;
            [db executeUpdate:@"INSERT into CaseList (e_id, c_id, c_title, eng_doc, jpn_doc, track) Values(?,?,?,?,?,?);",@"2505",@"1",@"demo_case",endDoc,jpnDoc,dataPath, nil];
            
            [db executeUpdate:@"INSERT into EpisodeList (e_id, e_title, e_cat) Values(?,?,?);",episode.episodeId,episode.episodeTitle,episode.catagoryTitle, nil];
            
            [db executeUpdate:@"INSERT into QuizList (type, e_id, ques, choise1, choise2, choise3, choise4, ans) Values(?,?,?,?,?,?,?,?);",quiz.type,episode.episodeId,quiz.question, quiz.choise1,quiz.choise2,quiz.choise3,quiz.choise4,quiz.answer, nil];
            
            [db executeUpdate:@"INSERT into PhraseList (e_id, c_id, eng, jpn, eng_exmpl, jpn_exmpl, isNew, isBookmarked) Values(?,?,?,?,?,?,?,?);",episode.episodeId,@"1",phrase.eng_version,phrase.jpn_version,phrase.eng_exmpl,phrase.jpn_exmpl,@"Yes",@"No", nil]; NSLog(@"all inserted");
        }
    }
    @catch (NSException *exception) {
        NSLog(@"database error/////-%@",[exception description]);
    }
    @finally {
        [db close];
    }
}

#pragma mark - Helper Methods

- (void)checkForDatabaseFile:(NSString *)databaseName{
    // Get documents folder
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //check for database
    NSLog(@"checking.....database");
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:databaseName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]) {
        NSString *pathFromApp = [[NSBundle mainBundle] pathForResource:databaseName ofType:nil];
        NSError *error = nil;
        [[NSFileManager defaultManager] copyItemAtPath:pathFromApp toPath:dataPath error:&error];
        NSLog(@"created new database");
    }
    
}

- (void)createDatabaseManagerWithName:(NSString *)databaseName{
    
    //check if already exists
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:databaseName];
    
    db = [FMDatabase databaseWithPath:dataPath];
}

- (NSArray *)getCasesForEpisode:(Episode *)episode{
    NSMutableArray *cases = [[NSMutableArray alloc ]init];
    
    Case *fetchedCase;
    
    @try {
        //[db open];
        FMResultSet *results = [db executeQuery:[NSString stringWithFormat:@"SELECT * from CaseList where e_id=%@",episode.episodeId]];
        
        
        while ([results next]) {NSLog(@"fetching case- %@",[results stringForColumn:@"c_title"]);
            fetchedCase = [[Case alloc]init];
            fetchedCase.caseId = [results stringForColumn:@"c_id"];
            fetchedCase.caseTitle = [results stringForColumn:@"c_title"];
            fetchedCase.doc_eng = [results stringForColumn:@"eng_doc"];
            fetchedCase.doc_jpn = [results stringForColumn:@"jpn_doc"];
            fetchedCase.track_link = [results stringForColumn:@"track"];
            
            //fetch phrases for this case
            fetchedCase.phrases = [self getPhrasesForEpisode:episode andCase:fetchedCase];
            
            [cases addObject:fetchedCase];
            fetchedCase = nil;
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"error in database fetching- %@",[exception description]);
    }
    @finally {
        //[db close];
    }
    
    return cases;

}

-(NSString *)getTrackLinkForCase:(Case *)cse andEpisode:(Episode *)ep{
    NSString *fetchedCase;
    
    @try {
        [db open];
        FMResultSet *results = [db executeQuery:[NSString stringWithFormat:@"SELECT track from CaseList where e_id=%@ and c_id=%@",ep.episodeId,cse.caseId]];
        
        
        while ([results next]) {//NSLog(@"fetching case- %@",[results
            fetchedCase = [results stringForColumn:@"track"];

        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"error in database fetching- %@",[exception description]);
    }
    @finally {
        [db close];
    }
    NSLog(@"fetched link - %@",fetchedCase);
    return fetchedCase;
}

- (NSArray *)getPhrasesForEpisode:(Episode *)episode andCase:(Case *)cse{
    NSMutableArray *phrases = [[NSMutableArray alloc ]init];
    
    Phrase *fetchedPhrase;
    
    @try {
        //[db open];
        FMResultSet *results = [db executeQuery:[NSString stringWithFormat:@"SELECT * from PhraseList where e_id='%@' and c_id='%@'",episode.episodeId,cse.caseId]];
        
        
        while ([results next]) {//NSLog(@"fetching case- %@",[results stringForColumn:@"c_title"]);
            fetchedPhrase = [[Phrase alloc]init];
            fetchedPhrase.eng_version = [results stringForColumn:@"eng"];
            fetchedPhrase.jpn_version = [results stringForColumn:@"jpn"];
            fetchedPhrase.eng_exmpl = [results stringForColumn:@"eng_exmpl"];
            fetchedPhrase.jpn_exmpl = [results stringForColumn:@"jpn_exmpl"];
            if ([[results stringForColumn:@"isBookmarked"] isEqualToString:@"Yes"]) {
                fetchedPhrase.isBookmarked = YES;
            }
            else fetchedPhrase.isBookmarked = NO;
            
            if ([[results stringForColumn:@"isNew"] isEqualToString:@"Yes"]) {
                fetchedPhrase.isNew = YES;
            }
            else fetchedPhrase.isNew = NO;
            
            
            [phrases addObject:fetchedPhrase];
            fetchedPhrase = nil;
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"error in database fetching- %@",[exception description]);
    }
    @finally {
        //[db close];
    }
    
    return phrases;
    
}


- (NSArray *)getQuizesForEpisode:(Episode *)episode{
    NSMutableArray *quizes = [[NSMutableArray alloc ]init];
    
    Quizz *fetchedQuiz;
    
    @try {
        //[db open];
        FMResultSet *results = [db executeQuery:[NSString stringWithFormat:@"SELECT * from QuizList where e_id=%@",episode.episodeId]];
        
        
        while ([results next]) {//NSLog(@"fetching quiz- %@",[results stringForColumn:@"c_title"]);
            fetchedQuiz = [[Quizz alloc]init];
            fetchedQuiz.type = [results stringForColumn:@"type"];
            fetchedQuiz.question = [results stringForColumn:@"ques"];
            fetchedQuiz.choise1 = [results stringForColumn:@"choise1"];
            fetchedQuiz.choise2 = [results stringForColumn:@"choise2"];
            fetchedQuiz.choise3 = [results stringForColumn:@"choise3"];
            fetchedQuiz.choise4 = [results stringForColumn:@"choise4"];
            fetchedQuiz.answer = [results stringForColumn:@"ans"];
            
            
            [quizes addObject:fetchedQuiz];
            fetchedQuiz = nil;
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"error in database fetching- %@",[exception description]);
    }
    @finally {
        //[db close];
    }
    
    return quizes;
    
}

@end
