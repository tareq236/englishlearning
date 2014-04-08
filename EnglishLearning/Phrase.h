//
//  Phrase.h
//  LEO1
//
//  Created by TML BD on 3/27/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Phrase : NSObject

@property (nonatomic, assign) BOOL isNew;
@property (nonatomic, assign) BOOL isBookmarked;
@property (nonatomic, strong) NSString *eng_version;
@property (nonatomic, strong) NSString *jpn_version;
@property (nonatomic, strong) NSString *eng_exmpl;
@property (nonatomic, strong) NSString *jpn_exmpl;


@end
