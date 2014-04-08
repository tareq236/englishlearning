//
//  QuerieViewController.h
//  EnglishLearning
//
//  Created by TML BD on 4/4/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueryTypeViewController.h"

@interface QuerieViewController : UIViewController <QueryTypeViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *queryType;
@property (weak, nonatomic) IBOutlet UIScrollView *queryScrollView;
@property (weak, nonatomic) IBOutlet UITextField *subjectTextField;
@property (weak, nonatomic) IBOutlet UITextView *bodyTextView;
@property (weak, nonatomic) IBOutlet UITextView *informationTextView;
@property (weak, nonatomic) IBOutlet UILabel *queryTypeLabel;

- (IBAction)selectQueryType:(id)sender;
- (IBAction)submitAction:(id)sender;
- (IBAction)goBackAction:(id)sender;
@end
