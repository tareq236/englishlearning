//
//  SelectEpisodeCell.m
//  EnglishLearning
//
//  Created by S A Chowdhury on 4/4/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import "SelectEpisodeCell.h"
#import "TMLAppDelegate.h"

@implementation SelectEpisodeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //[self decorateCell];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)selectEpisodeAction:(id)sender {
    TMLAppDelegate *appDel = (TMLAppDelegate *)[UIApplication sharedApplication].delegate;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        appDel.currentlySelectedCell.selectStatusImageView.image = [UIImage imageNamed:@"downloaded.png"];
        self.selectStatusImageView.image = [UIImage imageNamed:@"selected.png"];
        appDel.currentlySelectedCell = self;
        appDel.alarm.episode = self.episode;
        [appDel.alarmManager saveCurrentAlarmIntoPlist];
        [appDel.alarmManager setAlarm];

    });
    
}

-(void)decorateCellWithEpisode:(Episode *)ep{
    self.episode = ep;
    
    self.episodeTitleLabel.text = self.episode.episodeTitle;
    self.catagoryLabel.text = self.episode.catagoryTitle;
    
    self.selectStatusImageView.image = [UIImage imageNamed:@"downloaded.png"];
    
    TMLAppDelegate *appDel = (TMLAppDelegate *)[UIApplication sharedApplication].delegate;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/Image/%@.png",ep.catagoryTitle]];
    
    if (![appDel.apiManager checkIfImageAlreadyExistsForEpisode:ep]) {
        [appDel.apiManager downloadImageForEpisode:ep fromLink:ep.imageLink];
    }
    
    UIImage *img = [UIImage imageWithContentsOfFile:dataPath];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.catagoryImageView.image = img;
    });
    
    
    
//    self.layer.borderColor = [UIColor redColor].CGColor;
//    self.layer.borderWidth = 1;
//    self.layer.cornerRadius = 5;
//    self.layer.masksToBounds = YES;
//    CGRect _frame = CGRectMake(5, 10, 310, 55);
//    [self setFrame:_frame];
}
@end
