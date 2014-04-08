//
//  AudioPlayerViewController.m
//  EnglishLearning
//
//  Created by TML BD on 4/4/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import "AudioPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "Case.h"

@interface AudioPlayerViewController (){
    AVAudioPlayer *player;
    int count_case;
    NSTimer *timer;
}

@end

@implementation AudioPlayerViewController

@synthesize episode,parentClass;

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
    count_case = 0;
    [self loadTrack];
    [self playAction:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playAction:(id)sender {
    if (player.isPlaying) {
        [player pause];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.playButton.imageView.image = [UIImage imageNamed:@"player_play.png"];
        });
        
    }
    else{
        [player prepareToPlay];
        [player play];
        [self updateLabels];
        
        //start the timer
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateLabels) userInfo:nil repeats:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.playButton.imageView.image = [UIImage imageNamed:@"player_pause.png"];
        });
    }
    
}

- (IBAction)nextAction:(id)sender {
    if (player.isPlaying) {
        [player stop];
    };
    NSLog(@"running %i / %i",count_case,self.episode.cases.count);
    if (count_case < [self.episode.cases count]-1) {
        count_case ++;
        [self loadTrack];
        [self playAction:nil];
        [self.delegate audioPlayerClickedNext];
    }
    else{
        if ([self.parentClass isEqualToString:@"StudyView"]) {
            [self.delegate showQuizViewController];
        }
    }
}

- (IBAction)previousAction:(id)sender {
    if (player.isPlaying) {
        [player stop];
    };
    
    if (count_case > 0) {
        count_case --;
        [self loadTrack];
        [self playAction:nil];
        [self.delegate audioPlayerClickedPrevious];
    }
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    [player stop];
    player.currentTime = self.playerSlider.value;
    [player prepareToPlay];
    [player play];
    
    
    self.currentTimeLabel.text = [self timeForDuration:self.playerSlider.value];
}



#pragma  mark - Helper Methods

- (void)loadTrack{
    //initialize the player
    Case *cse = [self.episode.cases objectAtIndex:count_case];NSLog(@"loaded track - %@",cse.caseTitle);
    
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfFile:cse.track_link];
    player = nil;
    player = [[AVAudioPlayer alloc]initWithData:data error:&error];
    player.delegate = self;
    if (!player) {
        NSLog(@"errrrror initiating player-%@",error);
    }
    
    //initialize the labels
    self.totalTimeLabel.text = [self timeForDuration:player.duration];//[NSString stringWithFormat:@"%f",player.duration];
    self.currentTimeLabel.text = [NSString stringWithFormat:@"0:0:0"];
    
    [self.playerSlider setMaximumValue:player.duration];
}

-(void)updateLabels{
    self.playerSlider.value = player.currentTime;
    self.currentTimeLabel.text = [self timeForDuration:self.playerSlider.value];
}

-(NSString *)timeForDuration:(float)t{
    int h,m,s;
    h = (int)t /3600;
    m = (int)(t / 60) % 60;
    s = (int)t % 60;
    
    NSString *time = [NSString stringWithFormat:@"%i:%i:%i",h,m,s];
    
    return time;
    
}

-(void)releasePlayer{
    [player stop];
    player = nil;
}



#pragma mark -  Audio Player Delegate

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [timer invalidate];
    timer = nil;
}
@end
