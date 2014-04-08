//
//  EpisodeListCell.h
//  EnglishLearning
//
//  Created by TML BD on 4/3/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Episode.h"
#import "APIManager.h"

@protocol EpisodeCellDelegate;

@interface EpisodeListCell : UITableViewCell <APIManagerDelegate>


@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet UILabel *episodeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *episodeCatagoryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) id <EpisodeCellDelegate> delegate;
@property (strong,nonatomic) Episode *epsd;
@property (weak, nonatomic) IBOutlet UIImageView *catagoryImageVw;


- (IBAction)downloadAction:(id)sender;
- (void)decorateCellWithEpisode:(Episode *)episode;

@end


@protocol EpisodeCellDelegate

-(void)downloadingStarted;
-(void)downloadingFinished;

@end