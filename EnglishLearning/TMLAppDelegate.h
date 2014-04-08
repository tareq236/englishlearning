//
//  TMLAppDelegate.h
//  EnglishLearning
//
//  Created by TML BD on 4/3/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIManager.h"
#import "DatabaseManager.h"
#import "Alarm.h"
#import "AlarmManager.h"
#import "SelectEpisodeCell.h"
#import "AudioPlayerViewController.h"

@interface TMLAppDelegate : UIResponder <UIApplicationDelegate,APIManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) APIManager *apiManager;
@property (strong, nonatomic) DatabaseManager *databaseManager;
@property (strong, nonatomic) Alarm *alarm;
@property (strong, nonatomic) AlarmManager *alarmManager;
@property (strong, nonatomic) SelectEpisodeCell *currentlySelectedCell;


- (void)showAudioPlayerInViewController:(UIViewController *)vc withEpisode:(Episode *)episode;
- (UIStoryboard *)getAppropriateStoryboard;

@end
