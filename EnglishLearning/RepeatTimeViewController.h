//
//  RepeatTimeViewController.h
//  EnglishLearning
//
//  Created by S A Chowdhury on 3/4/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepeatTimeViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) NSString *type;

- (IBAction)goBackAction:(id)sender;

@end
