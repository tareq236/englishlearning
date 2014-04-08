//
//  UptodateDetailsViewController.m
//  EnglishLearning
//
//  Created by TML BD on 4/5/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import "UptodateDetailsViewController.h"

@interface UptodateDetailsViewController ()

@end

@implementation UptodateDetailsViewController

@synthesize details;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.detailsTextView.layer.borderColor = [UIColor blackColor].CGColor;
    self.detailsTextView.layer.borderWidth = 1;
    self.detailsTextView.text = details;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
