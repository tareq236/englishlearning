//
//  QuizViewController.h
//  LEO1
//
//  Created by TML BD on 3/25/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Episode.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

@protocol QuizViewControllerDelegate;

@interface QuizViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) Episode *episode;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (nonatomic, strong) NSString *e_id;
@property (weak, nonatomic) IBOutlet UITableView *choiceTable;
@property (weak, nonatomic) IBOutlet UIView *bodyView;
@property (weak, nonatomic) IBOutlet UILabel *quesNoLabel;
@property (weak, nonatomic) id <QuizViewControllerDelegate> delegate;
- (IBAction)goBack:(id)sender;

@end

@protocol QuizViewControllerDelegate

- (void)quizViewControllerDidFinish;

@end
