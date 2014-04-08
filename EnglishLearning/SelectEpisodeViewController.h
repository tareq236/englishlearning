//
//  SelectEpisodeViewController.h
//  EnglishLearning
//
//  Created by S A Chowdhury on 4/4/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectEpisodeViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *listTable;
@property (strong, nonatomic) NSString *mode;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

- (IBAction)goBackAction:(id)sender;
- (IBAction)goNextAction:(id)sender;

@end
