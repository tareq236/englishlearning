//
//  Episode.h
//  EnglishLearning
//
//  Created by TML BD on 4/3/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Episode : NSObject

@property (strong, nonatomic) NSString *episodeId;
@property (strong, nonatomic) NSString *episodeTitle;
@property (strong, nonatomic) NSString *catagoryTitle;
@property (assign, nonatomic) BOOL isSaved;
@property (strong, nonatomic) NSArray *cases;
@property (strong, nonatomic) NSArray *quizes;
@property (strong, nonatomic) NSString *imageLink;

@end
