//
//  PhrasesViewController.h
//  LEO1
//
//  Created by TML BD on 3/24/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhraseCell.h"
#import "PhraseDetailViewController.h"

@interface PhrasesViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,PhraseCellDelegate,PhraseDetailViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableVw;
- (IBAction)goBack:(id)sender;

@end
