//
//  RepeatTimeViewController.m
//  EnglishLearning
//
//  Created by S A Chowdhury on 3/4/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import "RepeatTimeViewController.h"
#import "TMLAppDelegate.h"

@interface RepeatTimeViewController ()

@end

@implementation RepeatTimeViewController

@synthesize type;

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Satarday";
            break;
        case 1:
            cell.textLabel.text = @"Sunday";
            break;
        case 2:
            cell.textLabel.text = @"Monday";
            break;
        case 3:
            cell.textLabel.text = @"Tuesday";
            break;
        case 4:
            cell.textLabel.text = @"Wednesday";
            break;
        case 5:
            cell.textLabel.text = @"Thursday";
            break;
        case 6:
            cell.textLabel.text = @"Friday";
            break;
            
        default:
            break;
    }
    
    if ([self isPreviouslySelected:cell.textLabel.text]) {
        cell.imageView.image = [UIImage imageNamed:@"right.png"];
    }
    else
        cell.imageView.image = nil;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell.imageView.image) {
        cell.imageView.image = [UIImage imageNamed:@"right.png"];
        [self selectDay:cell.textLabel.text];
    }
    else{
        cell.imageView.image = nil;
        [self deselectDay:cell.textLabel.text];
    }
    
}

#pragma mark - Helper Method


- (BOOL)isPreviouslySelected:(NSString *)day{
    BOOL success = NO;
    
    day = [day substringToIndex:3]; //NSLog(@"%@",day);
    TMLAppDelegate *appDel = (TMLAppDelegate *)[UIApplication sharedApplication].delegate;
    NSArray *repeat;
    if ([self.type isEqualToString:@"RegularAlarm"]) {
        repeat = appDel.alarm.repeat;
    }
    else{
        repeat = appDel.alarm.notificationRepeat;
    }
    for (NSString *str in repeat) {
        if ([str isEqualToString:day]) {//NSLog(@"re %@",str);
            return YES;
            break;
        }
    }
    
    return success;
}

- (void)deselectDay:(NSString *)day{
    day = [day substringToIndex:3];
    TMLAppDelegate *appDel = (TMLAppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *tempDay;
    
    if ([self.type isEqualToString:@"RegularAlarm"]) {
        for (int i=0; i<[appDel.alarm.repeat count]; i++) {
            tempDay = [appDel.alarm.repeat objectAtIndex:i];
            if ([tempDay isEqualToString:day]) {
                [appDel.alarm.repeat removeObjectAtIndex:i];
                break;
            }
        }
    }
    else{
        for (int i=0; i<[appDel.alarm.notificationRepeat count]; i++) {
            tempDay = [appDel.alarm.notificationRepeat objectAtIndex:i];
            if ([tempDay isEqualToString:day]) {
                [appDel.alarm.notificationRepeat removeObjectAtIndex:i];
                break;
            }
        }

    }
}

- (void)selectDay:(NSString *)day{
    TMLAppDelegate *appDel = (TMLAppDelegate *)[UIApplication sharedApplication].delegate;
    day = [day substringToIndex:3];
    
    if ([self.type isEqualToString:@"RegularAlarm"]) {
        [appDel.alarm.repeat addObject:day];
    }
    else{
        [appDel.alarm.notificationRepeat addObject:day];
    }
}

- (IBAction)goBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    TMLAppDelegate *appDel = (TMLAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDel.alarmManager saveCurrentAlarmIntoPlist];
    [appDel.alarmManager setAlarm];

}
@end
