//
//  AudioPlayerViewController.h
//  EnglishLearning
//
//  Created by TML BD on 4/4/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Episode.h"
#import <AVFoundation/AVFoundation.h>

@protocol AudioPlayerViewControllerDelegate;

@interface AudioPlayerViewController : UIViewController <AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *previouseButton;
@property (weak, nonatomic) IBOutlet UISlider *playerSlider;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) id <AudioPlayerViewControllerDelegate> delegate;
@property (strong, nonatomic) Episode *episode;
@property (strong, nonatomic) NSString *parentClass;

- (IBAction)playAction:(id)sender;
- (IBAction)nextAction:(id)sender;
- (IBAction)previousAction:(id)sender;
- (IBAction)sliderValueChanged:(UISlider *)sender;
- (void)releasePlayer;


@end

@protocol AudioPlayerViewControllerDelegate

- (void)audioPlayerClickedNext;
- (void)audioPlayerClickedPrevious;
- (void)showQuizViewController;

@end
