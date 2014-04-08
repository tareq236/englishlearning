//
//  Quizz.h
//  EnglishLearning
//
//  Created by Muhammad Tareq on 4/3/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Quizz : NSObject

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong) NSString *choise1;
@property (nonatomic, strong) NSString *choise2;
@property (nonatomic, strong) NSString *choise3;
@property (nonatomic, strong) NSString *choise4;
@property (nonatomic, strong) NSString *answer;

@end
