//
//  QuizViewController.m
//  LEO1
//
//  Created by TML BD on 3/25/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import "QuizViewController.h"
#import "MultipleChoiseCell.h"
#import "Quizz.h"

@interface QuizViewController (){
    FMDatabase *db;
    //NSMutableArray *quizes;
    Quizz *quizz;
    int count;
    int correct;
}

@end

@implementation QuizViewController

@synthesize episode;//,e_id;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //quizes = [[NSMutableArray alloc] init];
    //[self loadQuizes];
    quizz = [self.episode.quizes objectAtIndex:0];
    [self decorateViews];
    count = 0;
    correct = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)decorateViews{
    self.questionLabel.text = quizz.question;
    [self.choiceTable reloadData];
    self.quesNoLabel.text = [NSString stringWithFormat:@"Q.No %i/%lu",count,(unsigned long)[self.episode.quizes count]];
}

- (void)loadQuizes{
//    //initiate database
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"AlarmDatabase.sqlite"];
//    
//    db = [FMDatabase databaseWithPath:dataPath];
//    
//    //load quizes for the episode
//    @try {
//        [db open];
//        FMResultSet *results = [db executeQuery:[NSString stringWithFormat:@"Select * from QuizList where e_id='%@'",e_id]];NSLog(@"loading quiz");
//        while ([results next]) {
//            Quizz *quiz = [[Quizz alloc] init];
//            quiz.type = [results stringForColumn:@"type"];
//            quiz.question = [results stringForColumn:@"ques"];
//            quiz.choise1 = [results stringForColumn:@"choise1"];
//            quiz.choise2 = [results stringForColumn:@"choise2"];
//            quiz.choise3 = [results stringForColumn:@"choise3"];
//            quiz.choise4 = [results stringForColumn:@"choise4"];
//            quiz.answer = [results stringForColumn:@"ans"];
//            
//            [quizes addObject:quiz];
//        }
//    }
//    @catch (NSException *exception) {
//        NSLog(@"database error in loading quiz ???-%@",[exception description]);
//    }
//    @finally {
//        [db close];
//        quizz = [quizes objectAtIndex:0];
//    }
}

- (IBAction)goBack:(id)sender {
    //[self.navigationController popViewControllerAnimated:YES];
    [self.delegate quizViewControllerDidFinish];
}

#pragma  mark TableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MultipleChoiseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuizCell"];
    if (!cell) {
        cell = [[MultipleChoiseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QuizCell"];
    }
    
    Quizz *quix = quizz;
    switch (indexPath.row) {
        case 0:
            cell.indexImage.image = [UIImage imageNamed:@"a.png"];
            cell.choiseLabel.text = quix.choise1;
            break;
        case 1:
            cell.indexImage.image = [UIImage imageNamed:@"b.png"];
            cell.choiseLabel.text = quix.choise2;
            break;
        case 2:
            cell.indexImage.image = [UIImage imageNamed:@"c.png"];
            cell.choiseLabel.text = quix.choise3;
            break;
        case 3:
            cell.indexImage.image = [UIImage imageNamed:@"d.png"];
            cell.choiseLabel.text = quix.choise4;
            break;
            
        default:
            break;
    }
    
    cell.statusImage.image = nil;
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //do something for answer
    [self checkAnswerForChoise:(MultipleChoiseCell *)[tableView cellForRowAtIndexPath:indexPath]];
    //load next
    [self performSelector:@selector(loadNextQuiz) withObject:nil afterDelay:1.0];
    
}

- (void)loadNextQuiz{
    if (++count >= [self.episode.quizes count]) {
        //handle it
        NSString *msg = [NSString stringWithFormat:@"You got %i correct out of %lu",correct,(unsigned long)[self.episode.quizes count]];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Test Result" message:msg delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
        [self performSelector:@selector(goBack:) withObject:nil afterDelay:2];
    }
    else{
        //animation
        CGRect _frame = self.bodyView.frame;
        CGRect _frame1 = self.bodyView.frame;
        CGRect _frame2 = self.bodyView.frame;
        _frame.origin.x -= _frame.size.width;
        _frame1.origin.x += _frame.size.width;
        
        [UIView animateWithDuration:0.25 animations:^{
            [self.bodyView setFrame:_frame];
        } completion:^(BOOL finished) {
            quizz = [self.episode.quizes objectAtIndex:count];
            [self decorateViews];
            [self.bodyView setFrame:_frame1];
            
            [UIView animateWithDuration:0.25 animations:^{
                [self.bodyView setFrame:_frame2];
            } completion:^(BOOL finished) {
                
            }];
        }];
        
        
        
    }
}

- (void)checkAnswerForChoise:(MultipleChoiseCell *)choice{
    if ([quizz.answer isEqualToString:choice.choiseLabel.text]) {
        choice.statusImage.image = [UIImage imageNamed:@"right.png"];
        correct ++;
    }
    else{
        choice.statusImage.image = [UIImage imageNamed:@"wrong.png"];
        //get right cell
        
        
        for (int i=0; i<4; i++) {
            choice = (MultipleChoiseCell *)[self.choiceTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if ([choice.choiseLabel.text isEqualToString:quizz.answer]) {
                choice.statusImage.image = [UIImage imageNamed:@"right.png"];
                break;
            }
        }
    }
}

@end
