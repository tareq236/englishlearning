//
//  NewsFaqViewController.m
//  EnglishLearning
//
//  Created by TML BD on 4/5/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import "NewsFaqViewController.h"

@interface NewsFaqViewController ()

@end

@implementation NewsFaqViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
