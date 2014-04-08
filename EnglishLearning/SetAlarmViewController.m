//
//  SetAlarmViewController.m
//  EnglishLearning
//
//  Created by TML BD on 4/3/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import "SetAlarmViewController.h"
#import "TMLAppDelegate.h"
#import "AlarmOptionViewController.h"

@interface SetAlarmViewController ()

@end

@implementation SetAlarmViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateLabels];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToSetTime:(id)sender {
}

- (IBAction)goToSetEpisode:(id)sender {
}

- (IBAction)goToSetPushNotification:(id)sender {
}

- (IBAction)alarmSwitchAction:(id)sender {
    TMLAppDelegate *appDel = (TMLAppDelegate *)[UIApplication sharedApplication].delegate;
    if (self.alarmSwitch.isOn) {
        appDel.alarm.isEnabled = YES;
        [appDel.alarmManager setAlarm];
    }
    else {
        appDel.alarm.isEnabled = NO;
        [appDel.alarmManager cancelAllAlarm];
    }

    
}

- (IBAction)goBackAction:(id)sender {
    TMLAppDelegate *appDel = (TMLAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDel.alarmManager setAlarm];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goNextAction:(id)sender {
    [self performSegueWithIdentifier:@"showAlarmOption" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showAlarmOption"]) {
        AlarmOptionViewController *aovc = (AlarmOptionViewController *)segue.destinationViewController;
        aovc.type = @"RegularAlarm";
        aovc.mode = @"full";
    }
    else if ([segue.identifier isEqualToString:@"showNotificationOption"]) {
        AlarmOptionViewController *aovc = (AlarmOptionViewController *)segue.destinationViewController;
        aovc.type = @"PushNotification";
    }
}

#pragma mark- Helper Method

- (void)updateLabels{
    TMLAppDelegate *appDel = (TMLAppDelegate *)[UIApplication sharedApplication].delegate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"h:mm"];
    self.alarmTimeLabel.text = [formatter stringFromDate:appDel.alarm.alarmTime];
    self.pushNotificationLabel.text = [formatter stringFromDate:appDel.alarm.alarmTime];
    self.episodeNameLabel.text = appDel.alarm.episode.episodeTitle; NSLog(@"settin title -%@",appDel.alarm.episode.episodeTitle);
    
    if (appDel.alarm.isEnabled) {
        [self.alarmSwitch setOn:YES];
    }
    else [self.alarmSwitch setOn:NO];
}

@end
