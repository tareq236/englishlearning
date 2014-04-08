//
//  PhraseCell.h
//  LEO1
//
//  Created by TML BD on 3/27/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Phrase.h"

@protocol PhraseCellDelegate;

@interface PhraseCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bookmarkImageVw;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageVw;
@property (weak, nonatomic) IBOutlet UILabel *phraseTitle;
@property (weak, nonatomic) IBOutlet UILabel *phraseSubtitle;
@property (weak, nonatomic) id <PhraseCellDelegate> delegate;

- (IBAction)bookmarkTapped:(id)sender;
-(void)decorateCellWithPhrase:(Phrase *)phrase;

@end

@protocol PhraseCellDelegate

- (void)changeBookmarkStatusForPhrase:(Phrase *)phrase;

@end