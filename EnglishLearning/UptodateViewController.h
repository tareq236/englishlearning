//
//  UptodateViewController.h
//  EnglishLearning
//
//  Created by TML BD on 4/5/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIManager.h"

@interface UptodateViewController : UIViewController<APIManagerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *typeScrollView;
@property (weak, nonatomic) IBOutlet UITextView *detailsTextView;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
- (IBAction)goBack:(id)sender;
@end
