//
//  AlarmOptionViewController.h
//  EnglishLearning
//
//  Created by S A Chowdhury on 3/4/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmOptionViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *repeatButton;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) IBOutlet UISwitch *snozeSwitch;
@property (strong, nonatomic) IBOutlet UILabel *repeatLabel;
@property (strong, nonatomic) NSString *mode;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

- (IBAction)goBackAction:(id)sender;
- (IBAction)goNextAction:(id)sender;
- (IBAction)snozeSwitchAction:(id)sender;

@end
