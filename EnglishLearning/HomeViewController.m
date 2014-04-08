//
//  TMLViewController.m
//  EnglishLearning
//
//  Created by TML BD on 4/3/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import "HomeViewController.h"
#import "TMLAppDelegate.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToSetAlarmPage:(id)sender {
}

- (IBAction)goToEpisodePage:(id)sender {
}

- (IBAction)goToNewsFaqPage:(id)sender {
//    TMLAppDelegate *appDel = (TMLAppDelegate *)[UIApplication sharedApplication].delegate;
//    [appDel showAudioPlayerInViewController:self withEpisode:[appDel.databaseManager getEpisodeFromDatabaseForId:@"8"]];
}

#pragma mark -Study ViewController Delegate

-(void)studyViewControllerDidFinishStudy{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
