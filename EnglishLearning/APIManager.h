//
//  APIManager.h
//  EnglishLearning
//
//  Created by TML BD on 4/3/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Episode.h"
#import "AFHTTPRequestOperationManager.h"

@protocol APIManagerDelegate;

@interface APIManager : NSObject

@property (weak, nonatomic) id <APIManagerDelegate> delegate;

- (void)fetchEpisodeListFromApi;
- (void)downloadEpisode:(Episode *)episode;
- (void)sendMail:(NSDictionary *)dic;
- (void)fetchUptoDateInformation;
- (void)tryToUpdateEpisode:(Episode *)episode;
- (BOOL)checkIfImageAlreadyExistsForEpisode:(Episode *)episode;
- (void)downloadImageForEpisode:(Episode *)episode fromLink:(NSString *)link;

@end

@protocol APIManagerDelegate

@optional
-(void)resultsForFetchingEpisodeList:(NSArray *)episodes;
-(void)episodeIsDownloaded;
-(void)uptoDateInFormation:(NSArray *)infos;
-(void)triedToUpdateEpisode:(Episode *)ep;


@end

//@end
