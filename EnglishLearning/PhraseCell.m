//
//  PhraseCell.m
//  LEO1
//
//  Created by TML BD on 3/27/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import "PhraseCell.h"
#import "FMDatabase.h"

@implementation PhraseCell{
    Phrase *currentPhrase;
}

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

- (IBAction)bookmarkTapped:(id)sender {
    if (currentPhrase.isBookmarked) {
        currentPhrase.isBookmarked = NO;
        self.bookmarkImageVw.image = [UIImage imageNamed:@"unmarked.png"];
    }
    else{
        currentPhrase.isBookmarked = YES;
        self.bookmarkImageVw.image = [UIImage imageNamed:@"bookmarked.png"];
    }
    [self.delegate changeBookmarkStatusForPhrase:currentPhrase];
    
}

-(void)decorateCellWithPhrase:(Phrase *)phrase{
    self.phraseTitle.text = phrase.eng_version;
    self.phraseSubtitle.text = phrase.jpn_version;
    
    //NSLog(@"phrase status %hhd",phrase.isNew);
    if (phrase.isNew) {
        self.statusImageVw.image = [UIImage imageNamed:@"newbanner.png"];
    }
    else{
       // [self.statusImageVw setHidden:YES];
    }
    if (phrase.isBookmarked) {
        self.bookmarkImageVw.image = [UIImage imageNamed:@"bookmarked.png"];
    }
    else{
        self.bookmarkImageVw.image = [UIImage imageNamed:@"unmarked.png"];
    }
    
    currentPhrase = phrase;
}





@end
