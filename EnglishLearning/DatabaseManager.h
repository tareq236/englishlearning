//
//  DatabaseManager.h
//  EnglishLearning
//
//  Created by TML BD on 4/3/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Episode.h"
#import "Case.h"
#import "Quizz.h"
#import "Phrase.h"

@interface DatabaseManager : NSObject


-(id)initWtithDatabaseName:(NSString *)database;
- (BOOL)insertEpisodeIntoDatabase:(Episode *)episode;
- (BOOL)updateEpisodeIntoDatabase:(Episode *)episode;
- (BOOL)insertCase:(Case *)cse forEpisode:(Episode *)episode;
- (BOOL)insertQuiz:(Quizz *)quiz forEpisode:(Episode *)episode;
- (BOOL)insertPhrase:(Phrase *)phrase forEpisode:(Episode *)episode andCase:(Case *)cse;
- (BOOL)deleteCase:(Case*)cse forEpisode:(Episode *)episode;
- (BOOL)deleteQuizesforEpisode:(Episode *)episode;
- (BOOL)deletePhrasesforEpisode:(Episode *)episode andCase:(Case *)cse;

- (NSString *)getTrackLinkForCase:(Case *)cse andEpisode:(Episode *)ep;
- (NSArray *)getEpisodeListFromDatabase;
- (BOOL)ifEpisodeSavedInDatabase:(Episode *)episode;
- (BOOL)ifCase:(Case *)cse SavedInDatabaseForEpisode:(Episode *)episode;
- (Episode *)getEpisodeFromDatabaseForId:(NSString *)episodeId;
- (NSArray *)getPhrasesFromDatabase;
- (void)createDemoCases;

@end
