//
//  SelectEpisodeCell.h
//  EnglishLearning
//
//  Created by S A Chowdhury on 4/4/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Episode.h"

@interface SelectEpisodeCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *selectStatusImageView;
@property (strong, nonatomic) IBOutlet UILabel *catagoryLabel;
@property (strong, nonatomic) IBOutlet UILabel *episodeTitleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *catagoryImageView;
@property (strong, nonatomic) Episode *episode;

- (IBAction)selectEpisodeAction:(id)sender;
- (void)decorateCellWithEpisode:(Episode *)ep;

@end
