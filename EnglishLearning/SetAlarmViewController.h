//
//  SetAlarmViewController.h
//  EnglishLearning
//
//  Created by TML BD on 4/3/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol SetAlarmViewControllerDelegate;

@interface SetAlarmViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISwitch *alarmSwitch;
@property (strong, nonatomic) IBOutlet UILabel *alarmTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *episodeNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *pushNotificationLabel;
//@property (weak, nonatomic) id <SetAlarmViewControllerDelegate> delegate;

- (IBAction)goToSetTime:(id)sender;
- (IBAction)goToSetEpisode:(id)sender;
- (IBAction)goToSetPushNotification:(id)sender;
- (IBAction)alarmSwitchAction:(id)sender;
- (IBAction)goBackAction:(id)sender;
- (IBAction)goNextAction:(id)sender;

@end

//@protocol SetAlarmViewControllerDelegate
//
//- (void)dismissSetAlarmViewController;
//
//@end
