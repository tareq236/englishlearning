//
//  TMLViewController.h
//  EnglishLearning
//
//  Created by TML BD on 4/3/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudyViewController.h"

@interface HomeViewController : UIViewController <StudyViewControllerDelegate>

- (IBAction)goToSetAlarmPage:(id)sender;
- (IBAction)goToEpisodePage:(id)sender;
- (IBAction)goToNewsFaqPage:(id)sender;

@end
