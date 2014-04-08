//
//  QueryTypeViewController.h
//  EnglishLearning
//
//  Created by TML BD on 4/4/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QueryTypeViewControllerDelegate;

@interface QueryTypeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) id <QueryTypeViewControllerDelegate> delegate;


@end


@protocol QueryTypeViewControllerDelegate

- (void)queryTypeIsSelectedWithType:(NSString *)type;

@end