//
//  PhraseDetailViewController.h
//  LEO1
//
//  Created by TML BD on 3/28/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Phrase.h"

@protocol PhraseDetailViewControllerDelegate;

@interface PhraseDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *bookmarkButton1;
@property (weak, nonatomic) IBOutlet UIButton *bookmarkButton2;
@property (weak, nonatomic) IBOutlet UILabel *engPhraseLabel1;
@property (weak, nonatomic) IBOutlet UILabel *jpnPhraseLabel;
@property (weak, nonatomic) IBOutlet UITextView *exampleField1;
@property (weak, nonatomic) IBOutlet UILabel *engPhraseLabel2;
@property (weak, nonatomic) IBOutlet UILabel *jpnPhraseLabel2;
@property (weak, nonatomic) IBOutlet UITextView *exampleField2;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) NSArray *phraselist;
@property (nonatomic, assign) int currentIndex;
@property (weak, nonatomic) IBOutlet UIImageView *bookmarkImageVw1;
@property (weak, nonatomic) IBOutlet UIImageView *bookmarkImageVw2;
@property (weak, nonatomic) id <PhraseDetailViewControllerDelegate> delegate;



- (IBAction)changeBookmark2:(id)sender;
- (IBAction)changeBookmark1:(id)sender;
- (IBAction)viewSwiped:(UISwipeGestureRecognizer *)sender;
- (IBAction)goBack:(id)sender;


@end

@protocol PhraseDetailViewControllerDelegate

- (void)PhraseDetailViewDidChangeBookmarkForPhrase:(Phrase *)ph;

@end
