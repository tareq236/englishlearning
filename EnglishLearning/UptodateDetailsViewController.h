//
//  UptodateDetailsViewController.h
//  EnglishLearning
//
//  Created by TML BD on 4/5/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UptodateDetailsViewController : UIViewController

@property (strong, nonatomic) NSString *details;
@property (weak, nonatomic) IBOutlet UITextView *detailsTextView;
- (IBAction)goBack:(id)sender;

@end
