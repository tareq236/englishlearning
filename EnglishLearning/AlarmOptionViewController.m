//
//  AlarmOptionViewController.m
//  EnglishLearning
//
//  Created by S A Chowdhury on 3/4/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import "AlarmOptionViewController.h"
#import "RepeatTimeViewController.h"
#import "TMLAppDelegate.h"
#import "SelectEpisodeViewController.h"

@interface AlarmOptionViewController (){
    UIDatePicker *timePicker;
}

@end

@implementation AlarmOptionViewController

@synthesize type,mode;

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

- (void)viewWillAppear:(BOOL)animated{
    //load picker
    [self loadPicker];
    TMLAppDelegate *appDel = (TMLAppDelegate *)[UIApplication sharedApplication].delegate;
    
    //update label
    NSString *str = @"";
    if ([self.type isEqualToString:@"RegularAlarm"]) {
        
        for (NSString *s in appDel.alarm.repeat) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@ ",s]];
        }
        
        if (appDel.alarm.isSnozeEnabled) {
            [self.snozeSwitch setOn:YES];
        }
        else [self.snozeSwitch setOn:NO];
    }
    else{ //str = @"fdsdfs";
        for (NSString *s in appDel.alarm.notificationRepeat) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@ ",s]];
        }
        
        if (appDel.alarm.isNotificationSnozeEnabled) {
            [self.snozeSwitch setOn:YES];
        }
        else [self.snozeSwitch setOn:NO];
        
        self.titleLabel.text = @"プッシュ通知セット";
        
        self.nextButton.imageView.image = [UIImage imageNamed:@"finish_button.png"];
    }
    
    self.repeatLabel.text = str;
    
    //update switch
//    if (appDel.alarm.isSnozeEnabled) {
//        [self.snozeSwitch setOn:YES];
//    }
//    else [self.snozeSwitch setOn:NO];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBackAction:(id)sender {
    TMLAppDelegate *appDel = (TMLAppDelegate *)[UIApplication sharedApplication].delegate;
    
    if ([self.type isEqualToString:@"RegularAlarm"]) {
        appDel.alarm.alarmTime = timePicker.date;
    }
    else{
        appDel.alarm.notificationTime = timePicker.date;
    }

    
    [appDel.alarmManager saveCurrentAlarmIntoPlist];
    [appDel.alarmManager setAlarm];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goNextAction:(id)sender {
    TMLAppDelegate *appDel = (TMLAppDelegate *)[UIApplication sharedApplication].delegate;
    if ([self.type isEqualToString:@"RegularAlarm"] && [self.mode isEqualToString:@"full"]) {
        [self performSegueWithIdentifier:@"showEpisode" sender:nil];
        appDel.alarm.alarmTime = timePicker.date;
        [appDel.alarmManager saveCurrentAlarmIntoPlist];
    }
    else{
        appDel.alarm.alarmTime = timePicker.date;
        //appDel.alarm.notificationTime = timePicker.date;
        [appDel.alarmManager saveCurrentAlarmIntoPlist];
        
        
        NSArray *viewControllers = [self.navigationController viewControllers];
        [self.navigationController popToViewController:[viewControllers objectAtIndex:1] animated:YES];
    }
    
    
    
    [appDel.alarmManager setAlarm];
}

- (IBAction)snozeSwitchAction:(id)sender {
    TMLAppDelegate *appDel = (TMLAppDelegate *)[UIApplication sharedApplication].delegate;
    if ([self.type isEqualToString:@"RegularAlarm"]) {
        appDel.alarm.alarmTime = timePicker.date;
        appDel.alarm.isSnozeEnabled = self.snozeSwitch.isOn;
    }
    else{
        appDel.alarm.notificationTime = timePicker.date;
        appDel.alarm.isNotificationSnozeEnabled = self.snozeSwitch.isOn;
    }
    
    [appDel.alarmManager setAlarm];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showRepeat"]) {
        RepeatTimeViewController *rtvc = (RepeatTimeViewController  *)[segue destinationViewController];
        rtvc.type = self.type;
    }
    else if ([segue.identifier isEqualToString:@"showEpisode"]) {
        SelectEpisodeViewController *rtvc = (SelectEpisodeViewController  *)[segue destinationViewController];
        rtvc.mode = self.mode;
    }
    TMLAppDelegate *appDel = (TMLAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDel.alarmManager setAlarm];
}


#pragma mark Helper Methods

-(void)loadPicker{
    if (timePicker) {
        [timePicker removeFromSuperview];
        timePicker = nil;
    }
    timePicker = [[UIDatePicker alloc] init];
    [timePicker setDatePickerMode:UIDatePickerModeTime];
    CGRect _frame = timePicker.frame;
    _frame.origin.y = 50;
    [timePicker setFrame:_frame];
    
    [self.view addSubview:timePicker];
    
    //correct todays time
//    NSDate *dt = [NSDate date];
//    unsigned unitFlag = NSDayCalendarUnit | NSMonthCalendarUnit |NSYearCalendarUnit;
//    NSDateComponents *comp = [[NSCalendar currentCalendar] components:unitFlag fromDate:dt];
//    unitFlag = NSHourCalendarUnit | NSMinuteCalendarUnit;
//    NSDateComponents *comp1 = [[NSCalendar currentCalendar] components:unitFlag fromDate:self.currnetAlarm.alarmTime];
//    [comp setHour:comp1.hour];
//    [comp setMinute:comp1.minute];
//    dt = [[NSCalendar currentCalendar] dateFromComponents:comp];
//    [self.timePicker setDate:dt animated:YES];
}
@end
