//
//  EpisodeListViewController.h
//  EnglishLearning
//
//  Created by TML BD on 4/3/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIManager.h"
#import "EpisodeListCell.h"
#import "StudyViewController.h"

@interface EpisodeListViewController : UIViewController <APIManagerDelegate, UITableViewDelegate, UITableViewDataSource, EpisodeCellDelegate,StudyViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
- (IBAction)goBack:(id)sender;

@end
