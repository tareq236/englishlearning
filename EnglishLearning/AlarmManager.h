//
//  AlarmManager.h
//  EnglishLearning
//
//  Created by S A Chowdhury on 3/4/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlarmManager : NSObject

- (void)saveCurrentAlarmIntoPlist;
- (void)setAlarm;
- (void)cancelAllAlarm;

@end
