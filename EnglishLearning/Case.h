//
//  Case.h
//  EnglishLearning
//
//  Created by Muhammad Tareq on 4/3/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Case : NSObject

@property (nonatomic, strong) NSString *caseId;
@property (nonatomic, strong) NSString *caseTitle;
@property (nonatomic, strong) NSString *doc_eng;
@property (nonatomic, strong) NSString *doc_jpn;
//@property (nonatomic, strong) NSString *phrase_eng;
//@property (nonatomic, strong) NSString *phrase_jpn;
@property (nonatomic, strong) NSString *track_link;
@property (nonatomic, strong) NSArray *phrases;

@end
