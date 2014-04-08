//
//  AlarmManager.m
//  EnglishLearning
//
//  Created by S A Chowdhury on 3/4/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import "AlarmManager.h"
#import "TMLAppDelegate.h"

@implementation AlarmManager{
    NSString *filePath;
    TMLAppDelegate *appDelegate;
    NSDictionary *previousAlarmDetails;
}

-(id)init{
    self = [super init];
    
    [self loadPreviousAlarm];
    
    return self;
}

-(void)saveCurrentAlarmIntoPlist{
    //configure a dictionary
    
    //repeatlist
    NSString *str = @"";
    for (NSString *s in appDelegate.alarm.repeat) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@ ",s]];
    }
    NSString *nstr = @"";
    for (NSString *s in appDelegate.alarm.notificationRepeat) {
        nstr = [nstr stringByAppendingString:[NSString stringWithFormat:@"%@ ",s]];
    }
    //snoze
    NSString *snoze;
    if (appDelegate.alarm.isSnozeEnabled) {
        snoze = @"Yes";
    }
    else snoze = @"No";
    
    //snoze
    NSString *state;
    if (appDelegate.alarm.isEnabled) {
        state = @"Yes";// NSLog(@"saved as enabled");
    }
    else state = @"No";
    NSString *nstate;
    if (appDelegate.alarm.isNotificationSnozeEnabled) {
        nstate = @"Yes";// NSLog(@"saved as enabled");
    }
    else nstate = @"No"; //NSLog(@"noti snoze %@",nstate);
    
    NSArray *objects = [NSArray arrayWithObjects:appDelegate.alarm.alarmTime,appDelegate.alarm.alarmTone,str,snoze,state,appDelegate.alarm.episode.episodeId,appDelegate.alarm.notificationTime,nstate,nstr, nil];
//    for (NSString *s in objects) {
//        NSLog(@"%@",s);
//    }
    NSArray *keys = [NSArray arrayWithObjects:@"Time", @"Tone",@"Repeat",@"Snoze", @"On", @"Episode",@"NotificationTime",@"NotificationSnoze",@"NotificationRepeat", nil];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    NSLog(@"dic - %@",dict);
    NSString *error = nil;
	// create NSData from dictionary
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:dict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
	dict = nil;
    
    // check is plistData exists
	if(plistData)
	{
		// write plistData to our Data.plist file
        [plistData writeToFile:filePath atomically:YES];NSLog(@"Plist updated ");
    }
    else
	{
        NSLog(@"Error in saveData: %@", error);
        //[error release];
    }
}


-(void)setAlarm{// set new alarm and save into plist
    
    if (appDelegate.alarm.isEnabled) {
        [self saveCurrentAlarmIntoPlist];
        [self cancelAllAlarm];
        
        
        
        
        if ([[appDelegate.alarm.repeat objectAtIndex:0] isEqualToString:@"Never"]) {
            if ([[NSDate date] compare:appDelegate.alarm.alarmTime] == NSOrderedDescending) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Your alarm is not set.\nReason - No Repeat Alarm with an erlier time from current time" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
                [alert show];
                return;
            }
            //NSLog(@"now is %@\nalarm is -%@",[NSDate date],self.appDelegate.alarm.alarmTime);
            [self setNotificationForTime:appDelegate.alarm.alarmTime Repeat:NO Type:@"regularAlarm"];
            if (appDelegate.alarm.isSnozeEnabled) {
                [self setSnozeFor:3 startingAt:appDelegate.alarm.alarmTime forRepeat:NO Type:@"regularSnoze"];
            }[self setPushNotification];
        }
        else{
            [self setPushNotification];
            //get date day value
            int day = 0;
            NSDate *date = appDelegate.alarm.alarmTime;
            NSDateFormatter *fromatter = [[NSDateFormatter alloc]init];
            [fromatter setDateFormat:@"E"];
            
            if ([[fromatter stringFromDate:date] isEqualToString:@"Sat"]) {
                day = 0;
            }
            else if ([[fromatter stringFromDate:date] isEqualToString:@"Sun"]) {
                day = 1;
            }
            else if ([[fromatter stringFromDate:date] isEqualToString:@"Mon"]) {
                day = 2;
            }
            else if ([[fromatter stringFromDate:date] isEqualToString:@"Tue"]) {
                day = 3;
            }
            else if ([[fromatter stringFromDate:date] isEqualToString:@"Wed"]) {
                day = 4;
            }
            else if ([[fromatter stringFromDate:date] isEqualToString:@"Thu"]) {
                day = 5;
            }
            else if ([[fromatter stringFromDate:date] isEqualToString:@"Fri"]) {
                day = 6;
            }
            
            NSDateComponents *comp = [[NSDateComponents alloc]init];
            //[comp setDay:day];
            
            
            
            //
            for (NSString *str in appDelegate.alarm.repeat) {
                int d =100;
                if ([str isEqualToString:@"Sat"]) {
                    d = (7-day)%7;
                    [comp setDay:d];
                    date = [ [NSCalendar currentCalendar] dateByAddingComponents:comp toDate:appDelegate.alarm.alarmTime options:0];
                    //[self setNotificationForTime:date Repeat:YES];
                }
                else if ([str isEqualToString:@"Sun"]) {
                    d = (8-day)%7;
                    [comp setDay:d];
                    date = [ [NSCalendar currentCalendar] dateByAddingComponents:comp toDate:appDelegate.alarm.alarmTime options:0];
                    //[self setNotificationForTime:date Repeat:YES];
                }
                else if ([str isEqualToString:@"Mon"]) {
                    d = (9-day)%7;
                    [comp setDay:d];
                    date = [ [NSCalendar currentCalendar] dateByAddingComponents:comp toDate:appDelegate.alarm.alarmTime options:0];
                    //[self setNotificationForTime:date Repeat:YES];
                }
                else if ([str isEqualToString:@"Tue"]) {
                    d = (10-day)%7;
                    [comp setDay:d];
                    date = [ [NSCalendar currentCalendar] dateByAddingComponents:comp toDate:appDelegate.alarm.alarmTime options:0];
                    //[self setNotificationForTime:date Repeat:YES];
                }
                else if ([str isEqualToString:@"Wed"]) {
                    d = (11-day)%7;
                    [comp setDay:d];
                    date = [ [NSCalendar currentCalendar] dateByAddingComponents:comp toDate:appDelegate.alarm.alarmTime options:0];
                    //[self setNotificationForTime:date Repeat:YES];
                }
                else if ([str isEqualToString:@"Thu"]) {
                    d= (12-day)%7;
                    [comp setDay:d];
                    date = [ [NSCalendar currentCalendar] dateByAddingComponents:comp toDate:appDelegate.alarm.alarmTime options:0];
                    //[self setNotificationForTime:date Repeat:YES];
                }
                else if ([str isEqualToString:@"Fri"]) {
                    d = (13-day)%7;
                    [comp setDay:d];
                    date = [ [NSCalendar currentCalendar] dateByAddingComponents:comp toDate:appDelegate.alarm.alarmTime options:0];
                    //[self setNotificationForTime:date Repeat:YES];
                }
                else{
                    NSLog(@"returned");
                    return;
                }
                NSLog(@"date%@ added %i",appDelegate.alarm.alarmTime,d);
                [self setNotificationForTime:date Repeat:YES Type:@"regularAlarm"];
                if (appDelegate.alarm.isSnozeEnabled) {
                    [self setSnozeFor:3 startingAt:date forRepeat:YES Type:@"regularAlarm"];
                }
            }
        }
        
        
    }
}


-(void)cancelAllAlarm{
    
    UIApplication *app = [UIApplication sharedApplication];
    //[app cancelAllLocalNotifications];
    NSArray *notifications = [app scheduledLocalNotifications];
    NSDictionary *dic;
    
    for (UILocalNotification *notification in notifications) {
        dic = notification.userInfo;
        
        if ([[dic objectForKey:@"appID"] isEqualToString:@"LEO"]) {
            [app
             cancelLocalNotification:notification];
        }
    }
}



#pragma mark - Helper Methods

- (void)loadPreviousAlarm{
    //get property list from main bundle
		filePath = [[NSBundle mainBundle] pathForResource:@"AlarmDetails" ofType:@"plist"];
    
    appDelegate = (TMLAppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.alarm = [[Alarm alloc] init];
    
    // read property list into memory as an NSData object
	NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:filePath];
	NSString *errorDesc = nil;
	NSPropertyListFormat format;
	// convert static property liost into dictionary object
	previousAlarmDetails = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
	if (!previousAlarmDetails)
	{
		NSLog(@"Error reading plist: %@, format: %u", errorDesc, format);
	}
    NSLog(@"%@",previousAlarmDetails);
    //set the alarm object
    appDelegate.alarm.alarmTime = [previousAlarmDetails objectForKey:@"Time"];
    appDelegate.alarm.notificationTime = [previousAlarmDetails objectForKey:@"NotificationTime"]; //NSLog(@"noti time %@",appDelegate.alarm.notificationTime);
    appDelegate.alarm.alarmTone = [previousAlarmDetails objectForKey:@"Tone"];
    //NSLog(@"loading%@",[self.previousAlarmDetails objectForKey:@"NotificationTime"]);
    
    NSString *str = [previousAlarmDetails objectForKey:@"Repeat"];
    //NSLog(@"123str-%@",str);
    //repeat
    appDelegate.alarm.repeat = [[NSMutableArray alloc] init];
    for (NSString *s in [str componentsSeparatedByString:@" "]) {
        [appDelegate.alarm.repeat addObject:s];
        //NSLog(@"loading %@",s);
    }
    
    str = [previousAlarmDetails objectForKey:@"NotificationRepeat"];
    //NSLog(@"123str-%@",str);
    //repeat
    appDelegate.alarm.notificationRepeat = [[NSMutableArray alloc] init];
    for (NSString *s in [str componentsSeparatedByString:@" "]) {
        [appDelegate.alarm.notificationRepeat addObject:s];
        //NSLog(@"loading %@",s);
    }
    //snoze
    NSString *snoze = [previousAlarmDetails objectForKey:@"Snoze"];
    if ([snoze isEqualToString:@"Yes"]) {
        appDelegate.alarm.isSnozeEnabled = YES;
    }
    else appDelegate.alarm.isSnozeEnabled = NO;
    
    snoze = [previousAlarmDetails objectForKey:@"NotificationSnoze"];
    if ([snoze isEqualToString:@"Yes"]) {
        appDelegate.alarm.isNotificationSnozeEnabled = YES;
    }
    else appDelegate.alarm.isNotificationSnozeEnabled = NO;
    
    //Alarm on/off
    NSString *state = [previousAlarmDetails objectForKey:@"On"];
    if ([state isEqualToString:@"Yes"]) {
        appDelegate.alarm.isEnabled = YES;//NSLog(@"in plist alarm is on");
    }
    else appDelegate.alarm.isEnabled = NO;
    
    
    //set alarm time
    //appDelegate.alarm.alarmTime = [previousAlarmDetails objectForKey:@"Time"];
    //[self setAlarmTime:time];
    
    ////// do for the other details
    appDelegate.alarm.episode = [[Episode alloc]init];
    //appDelegate.alarm.episode.episodeId = [previousAlarmDetails objectForKey:@"Episode"];
    appDelegate.alarm.episode = [appDelegate.databaseManager getEpisodeFromDatabaseForId:[previousAlarmDetails objectForKey:@"Episode"]];//[appDelegate.databaseManager getEpisodeFromDatabaseForId:[previousAlarmDetails objectForKey:@"Episode"]];
    //NSLog(@"prev ep =%@",appDelegate.alarm.episode.episodeTitle);
    //NSLog(@"alarm details- %@",appDelegate.alarm.alarmTime);
}


-(void)setNotificationForTime:(NSDate *)date Repeat:(BOOL)repeat Type:(NSString *)type{
    //check and cancel erlier alarm time
    if ([[NSDate date] compare:date] == NSOrderedDescending) {
        NSDateComponents *comp = [[NSDateComponents alloc]init];
        [comp setDay:7];
        NSLog(@"prev date%@",date);
        NSLog(@"current date%@",[NSDate date]);
        date = [[NSCalendar currentCalendar] dateByAddingComponents:comp toDate:date options:0];
        NSLog(@"remodified date%@",date);
    }
    //
    
    
    //create a local notification
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    //set fire time
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:flags fromDate:date];
    NSDate* dateOnly = [calendar dateFromComponents:components];
    notification.fireDate = dateOnly;
    
    
    //////select alret body;
    //TMLAppDelegate *appDel = (TMLAppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *msg;
    if ([type isEqualToString:@"regularAlarm"] || [type isEqualToString:@"regularSnoze"] ) {
        msg = [NSString stringWithFormat:@"Episode - %@",appDelegate.alarm.episode.episodeId];
    } else msg = [NSString stringWithFormat:@"You need to study episode - %@",appDelegate.alarm.episode.episodeId];
    
    
    
    notification.alertBody = msg;
    //NSData *sound = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] URLForResource:@"case2505" withExtension:@"mp3"]];
    notification.soundName = @"case2505.mp3";//UILocalNotificationDefaultSoundName;
    
    if (repeat) {
        notification.repeatInterval = NSWeekCalendarUnit;
    }
    
    NSArray *objects = [NSArray arrayWithObjects:@"LEO", appDelegate.alarm.episode.episodeId, type , nil];
    NSArray *keys = [NSArray arrayWithObjects:@"appID", @"episode", @"type", nil];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    notification.userInfo = userInfo;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification]; NSLog(@"notification is set - %@ %@",notification.fireDate,notification.soundName);
}


-(void)setSnozeFor:(NSInteger )times startingAt:(NSDate *)time forRepeat:(BOOL)repeat Type:(NSString *)type{
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    [comp setMinute:5];
    for (int i = 1; i<= times; i++) {
        time = [[NSCalendar currentCalendar] dateByAddingComponents:comp toDate:time options:0];
        [self setNotificationForTime:time Repeat:repeat Type:type];
    }
    
}


- (void)setPushNotification{
    
//    if ([[appDelegate.alarm.notificationRepeat objectAtIndex:0] isEqualToString:@"Never"]) {
//        if ([[NSDate date] compare:appDelegate.alarm.notificationTime] == NSOrderedDescending) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Your alarm is not set.\nReason - 'No Repeat' Push Notification with an erlier time from current time" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
//            [alert show];
//            return;
//        }
//        //NSLog(@"now is %@\nalarm is -%@",[NSDate date],appDelegate.alarm.alarmTime);
//        [self setNotificationForTime:appDelegate.alarm.notificationTime Repeat:NO Type:@"pushAlarm"];
//        if (appDelegate.alarm.isNotificationSnozeEnabled) {
//            [self setSnozeFor:3 startingAt:appDelegate.alarm.notificationTime forRepeat:NO Type:@"pushSnoze"];
//        }NSLog(@"push date%@ added",appDelegate.alarm.notificationTime);
//    }
//    else{
//        
//        
//        
//        //get date day value
//        int day = 0;
//        NSDate *date = appDelegate.alarm.notificationTime;
//        NSDateFormatter *fromatter = [[NSDateFormatter alloc]init];
//        [fromatter setDateFormat:@"E"];
//        
//        if ([[fromatter stringFromDate:date] isEqualToString:@"Sat"]) {
//            day = 0;
//        }
//        else if ([[fromatter stringFromDate:date] isEqualToString:@"Sun"]) {
//            day = 1;
//        }
//        else if ([[fromatter stringFromDate:date] isEqualToString:@"Mon"]) {
//            day = 2;
//        }
//        else if ([[fromatter stringFromDate:date] isEqualToString:@"Tue"]) {
//            day = 3;
//        }
//        else if ([[fromatter stringFromDate:date] isEqualToString:@"Wed"]) {
//            day = 4;
//        }
//        else if ([[fromatter stringFromDate:date] isEqualToString:@"Thu"]) {
//            day = 5;
//        }
//        else if ([[fromatter stringFromDate:date] isEqualToString:@"Fri"]) {
//            day = 6;
//        }
//        
//        NSDateComponents *comp = [[NSDateComponents alloc]init];
//        //[comp setDay:day];
//        
//        
//        
//        //
//        for (NSString *str in appDelegate.alarm.notificationRepeat) {
//            int d =100;
//            if ([str isEqualToString:@"Sat"]) {
//                d = (7-day)%7;
//                [comp setDay:d];
//                date = [ [NSCalendar currentCalendar] dateByAddingComponents:comp toDate:appDelegate.alarm.notificationTime options:0];
//                //[self setNotificationForTime:date Repeat:YES];
//            }
//            else if ([str isEqualToString:@"Sun"]) {
//                d = (8-day)%7;
//                [comp setDay:d];
//                date = [ [NSCalendar currentCalendar] dateByAddingComponents:comp toDate:appDelegate.alarm.notificationTime options:0];
//                //[self setNotificationForTime:date Repeat:YES];
//            }
//            else if ([str isEqualToString:@"Mon"]) {
//                d = (9-day)%7;
//                [comp setDay:d];
//                date = [ [NSCalendar currentCalendar] dateByAddingComponents:comp toDate:appDelegate.alarm.notificationTime options:0];
//                //[self setNotificationForTime:date Repeat:YES];
//            }
//            else if ([str isEqualToString:@"Tue"]) {
//                d = (10-day)%7;
//                [comp setDay:d];
//                date = [ [NSCalendar currentCalendar] dateByAddingComponents:comp toDate:appDelegate.alarm.notificationTime options:0];
//                //[self setNotificationForTime:date Repeat:YES];
//            }
//            else if ([str isEqualToString:@"Wed"]) {
//                d = (11-day)%7;
//                [comp setDay:d];
//                date = [ [NSCalendar currentCalendar] dateByAddingComponents:comp toDate:appDelegate.alarm.notificationTime options:0];
//                //[self setNotificationForTime:date Repeat:YES];
//            }
//            else if ([str isEqualToString:@"Thu"]) {
//                d= (12-day)%7;
//                [comp setDay:d];
//                date = [ [NSCalendar currentCalendar] dateByAddingComponents:comp toDate:appDelegate.alarm.notificationTime options:0];
//                //[self setNotificationForTime:date Repeat:YES];
//            }
//            else if ([str isEqualToString:@"Fri"]) {
//                d = (13-day)%7;
//                [comp setDay:d];
//                date = [ [NSCalendar currentCalendar] dateByAddingComponents:comp toDate:appDelegate.alarm.notificationTime options:0];
//                //[self setNotificationForTime:date Repeat:YES];
//            }
//            else{
//                NSLog(@"returned");
//                return;
//            }
//            NSLog(@"push date%@ added %i",appDelegate.alarm.notificationTime,d);
//            [self setNotificationForTime:date Repeat:YES Type:@"pushAlarm"];
//            if (appDelegate.alarm.isNotificationSnozeEnabled) {
//                [self setSnozeFor:3 startingAt:date forRepeat:YES Type:@"pushSnoze"];
//            }
//        }
//    }
//    
}


@end
