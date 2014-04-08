//
//  TMLAppDelegate.m
//  EnglishLearning
//
//  Created by TML BD on 4/3/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import "TMLAppDelegate.h"
#import "APIManager.h"
#import "StudyViewController.h"
#import "HomeViewController.h"

@implementation TMLAppDelegate{
    AudioPlayerViewController *audioPlayer;
}

@synthesize apiManager,databaseManager,alarm,alarmManager,currentlySelectedCell;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //load storyboard
    UIStoryboard *storyboard = [self getAppropriateStoryboard];
    self.window.rootViewController = [storyboard instantiateInitialViewController];
    [self.window makeKeyAndVisible];
    
    
    [self createNecessaryFolders];
    self.apiManager = [[APIManager alloc] init];
    self.databaseManager = [[DatabaseManager alloc] initWtithDatabaseName:@"AlarmDatabase.sqlite"];
    [self.databaseManager createDemoCases];
    self.alarmManager = [[AlarmManager alloc] init];
    
    CGSize _size = [[UIScreen mainScreen] bounds].size;
    NSLog(@"%@",NSStringFromCGSize(_size));
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    if ([[userInfo objectForKey:@"appID"] isEqualToString:@"LEO"]) {
        Episode *ep = [self.databaseManager getEpisodeFromDatabaseForId:[userInfo objectForKey:@"episode"]];
        UIStoryboard *story = [self getAppropriateStoryboard];
        StudyViewController *evc = [story instantiateViewControllerWithIdentifier:@"StudyView"];
        evc.episode = ep;
        evc.parentClass = @"Root";NSLog(@"root-%@",self.window.rootViewController);
        UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
        [nav popToRootViewControllerAnimated:NO];
        [nav pushViewController:evc animated:NO];
        
        [self cancelAllSnoze];
    }
}

- (void)createNecessaryFolders{
    
    // Get documents folder
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Audio"];
    NSError *error = nil;
    
    //if no such folder exists, create it
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    
    dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Image"];
    error = nil;
    
    //if no such folder exists, create it
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    
    //[self.databaseManager createDemoCases];
    //[self createDemoCases];
}


-(void)showAudioPlayerInViewController:(UIViewController *)vc withEpisode:(Episode *)episode{
    if (audioPlayer) {
        CGRect _frame = audioPlayer.view.frame;
        _frame.origin.y = 480;
        //[audioPlayer.view setFrame:_frame];
        //_frame.origin.y = 350;
        
        //[vc.view addSubview:audioPlayer.view];
        
        [UIView animateWithDuration:.40 animations:^{
            [audioPlayer.view setFrame:_frame];
        } completion:^(BOOL finished) {
            [audioPlayer releasePlayer];
            [audioPlayer.view removeFromSuperview];
            audioPlayer = nil;
        }];
        
    }
    else{
        UIStoryboard *storyboard = [self getAppropriateStoryboard];
        //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        audioPlayer = [storyboard instantiateViewControllerWithIdentifier:@"AudioPlayer"];
        audioPlayer.episode = episode;
        //audioPlayer.delegate = vc;
        CGRect _frame = audioPlayer.view.frame;
        _frame.origin.y = 480;
        [audioPlayer.view setFrame:_frame];
        _frame.origin.y = 350;
        
        [vc.view addSubview:audioPlayer.view];
        
        [UIView animateWithDuration:.40 animations:^{
            [audioPlayer.view setFrame:_frame];
        }];
    }
    
}


-(UIStoryboard *)getAppropriateStoryboard{
    UIStoryboard *storyboard;
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        storyboard = [UIStoryboard storyboardWithName:@"Storyboard3.5inch" bundle:nil];
    }
    else{
        storyboard = [UIStoryboard storyboardWithName:@"Storyboard4inch" bundle:nil];
    }
    
    
    return storyboard;
}

#pragma mark - Helper Method

-(void)initializeStoryBoardBasedOnScreenSize {
    UIStoryboard *storyboard = nil;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {    // The iOS device = iPhone or iPod Touch
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        if (iOSDeviceScreenSize.height == 480)
        {   // iPhone 3GS, 4, and 4S and iPod Touch 3rd and 4th generation: 3.5 inch screen (diagonally measured)
            NSLog(@"Loading iphone 4 storyboard");
            // Instantiate a new storyboard object using the storyboard file named MainStoryboard_iPhone
            storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
        }
        if (iOSDeviceScreenSize.height == 568)
        {   // iPhone 5 and iPod Touch 5th generation: 4 inch screen (diagonally measured)
            NSLog(@"Loading iphone 5 storyboard");
            // Instantiate a new storyboard object using the storyboard file named Storyboard_iPhone4
            storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone5" bundle:nil];
        }
        
    } else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        // The iOS device = iPad
        NSLog(@"Loading ipad storyboard");
        // Instantiate a new storyboard object using the storyboard file named Storyboard_iPhone35
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
    }
    // Instantiate the initial view controller object from the storyboard
    UIViewController *initialViewController = [storyboard instantiateInitialViewController];
    
    // Instantiate a UIWindow object and initialize it with the screen size of the iOS device
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Set the initial view controller to be the root view controller of the window object
    self.window.rootViewController  = initialViewController;
    
    // Set the window object to be the key window and show it
    [self.window makeKeyAndVisible];
}

-(void)cancelAllSnoze{
    //at this point we will cancel the notification and reschedule it.
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    unsigned int unitFlag = NSDayCalendarUnit | NSMonthCalendarUnit |NSYearCalendarUnit;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:unitFlag fromDate:[NSDate date]];
    //declare a component for add 7 days to reschedule
    NSDateComponents *comp2add = [[NSDateComponents alloc] init];
    [comp2add setDay:7];
    NSDictionary *userInfo;
    NSDate *currentDate,*notificationDate;
    currentDate = [calendar dateFromComponents:comp];
    for (UILocalNotification *noti in notifications) {
        userInfo = noti.userInfo; NSLog(@"checking notificatoin");
        if ([[userInfo objectForKey:@"appID"] isEqualToString:@"LEO"]) {
            comp = [calendar components:unitFlag fromDate:noti.fireDate];
            notificationDate = [calendar dateFromComponents:comp];NSLog(@"got expected notification");
            if ([currentDate compare:notificationDate] == NSOrderedSame) {
                UILocalNotification *notification = [[UILocalNotification alloc]init];
                notification.fireDate = [calendar dateByAddingComponents:comp2add toDate:noti.fireDate options:0];NSLog(@"changed to %@",noti.fireDate);
                notification.userInfo = noti.userInfo;
                notification.alertBody = noti.alertBody;
                notification.soundName = noti.soundName;
                notification.repeatInterval = noti.repeatInterval;
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                [[UIApplication sharedApplication] cancelLocalNotification:noti];
            }
        }
    }
    
}

@end
