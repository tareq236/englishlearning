//
//  EpisodeListCell.m
//  EnglishLearning
//
//  Created by TML BD on 4/3/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import "EpisodeListCell.h"
#import "TMLAppDelegate.h"

@implementation EpisodeListCell{
    //Episode *currentEpisode;
}

@synthesize epsd;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)decorateCellWithEpisode:(Episode *)episode{
    //currentEpisode = episode;
    self.epsd = episode;
    self.episodeNameLabel.text = episode.episodeTitle;
    self.episodeCatagoryLabel.text = episode.catagoryTitle;
    
    if (episode.isSaved) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.statusImageView.image = [UIImage imageNamed:@"downloaded.png"];
        });
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.statusImageView.image = [UIImage imageNamed:@"download.png"];
        });
    }
    TMLAppDelegate *appDel = (TMLAppDelegate *)[UIApplication sharedApplication].delegate;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/Image/%@.png",episode.catagoryTitle]];
    
    if (![appDel.apiManager checkIfImageAlreadyExistsForEpisode:episode]) {
        [appDel.apiManager downloadImageForEpisode:episode fromLink:episode.imageLink];
    }
    
    UIImage *img = [UIImage imageWithContentsOfFile:dataPath];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.catagoryImageVw.image = img;
    });
}

- (IBAction)downloadAction:(id)sender {
    //first download the episode cases and audio files
    
    if (!self.epsd.isSaved) {
        TMLAppDelegate *appDel = (TMLAppDelegate *)[UIApplication sharedApplication].delegate;
        appDel.apiManager.delegate = self;
        [appDel.apiManager downloadEpisode:self.epsd];
        [self.delegate downloadingStarted];
        
    }
}


#pragma mark -APIManager delegate

-(void)episodeIsDownloaded{
    //stop HUD
    self.epsd.isSaved = YES;
    [self.delegate downloadingFinished];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusImageView.image = [UIImage imageNamed:@"downloaded.png"];
    });
}
@end
