//
//  StudyViewController.h
//  EnglishLearning
//
//  Created by TML BD on 4/4/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Episode.h"
#import "Case.h"
#import "AudioPlayerViewController.h"
#import "QuizViewController.h"

@protocol StudyViewControllerDelegate;

@interface StudyViewController : UIViewController <AudioPlayerViewControllerDelegate, QuizViewControllerDelegate>

@property (strong, nonatomic) Episode *episode;
@property (weak, nonatomic) IBOutlet UILabel *topBarLabel;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (weak, nonatomic) id <StudyViewControllerDelegate> delegate;
@property (strong, nonatomic) NSString *parentClass;

- (IBAction)showEnglishVersion:(id)sender;
- (IBAction)showJapaneseVersion:(id)sender;
- (IBAction)showPhrase:(id)sender;
- (IBAction)doneStudy:(id)sender;
@end

@protocol StudyViewControllerDelegate

- (void)studyViewControllerDidFinishStudy;

@end
