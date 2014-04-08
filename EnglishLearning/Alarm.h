//
//  Alarm.h
//  EnglishLearning
//
//  Created by S A Chowdhury on 3/4/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Episode.h"

@interface Alarm : NSObject

@property (nonatomic, strong) NSDate *alarmTime;
@property (nonatomic, strong) NSDate *notificationTime;
@property (nonatomic, strong) NSString *alarmTone;
@property (nonatomic, strong) NSMutableArray *repeat;
@property (nonatomic, strong) NSMutableArray *notificationRepeat;
@property (nonatomic, assign) BOOL isSnozeEnabled;
@property (nonatomic, assign) BOOL isNotificationSnozeEnabled;
@property (nonatomic, strong) Episode *episode;
@property (nonatomic, assign) BOOL isEnabled;
@property (nonatomic, assign) int numberOfSnoze;

@end
