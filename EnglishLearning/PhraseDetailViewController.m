//
//  PhraseDetailViewController.m
//  LEO1
//
//  Created by TML BD on 3/28/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import "PhraseDetailViewController.h"
#import "Phrase.h"
#import "FMDatabase.h"

@interface PhraseDetailViewController (){
    //FMDatabase *db;
}

@end

@implementation PhraseDetailViewController

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
    [self decorateViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)decorateViewController{
    if ([self.phraselist count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"There is no phrase saved in database." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        [self performSelector:@selector(goBack) withObject:nil afterDelay:1];
    }
    else{
        //NSLog(@"%i no phrase is selected",self.currentIndex);
        Phrase *phrase = [self.phraselist objectAtIndex:self.currentIndex];
        self.engPhraseLabel1.text = phrase.eng_version;
        self.jpnPhraseLabel.text = phrase.jpn_version;
        NSString *txt = [NSString stringWithFormat:@"%@\n%@",phrase.eng_exmpl,phrase.jpn_exmpl];
        self.exampleField1.text = txt;
        
        if (phrase.isBookmarked) {
            self.bookmarkImageVw1.image = [UIImage imageNamed:@"bookmarked.png"];
            NSLog(@"bookmarked");
        }
        else {
            self.bookmarkImageVw1.image = [UIImage imageNamed:@"unmarked.png"];
        }
    }
}

- (IBAction)goToList1:(id)sender {
    [self performSelector:@selector(goBack) withObject:nil afterDelay:0];
}

- (IBAction)goToList2:(id)sender {
    [self performSelector:@selector(goBack) withObject:nil afterDelay:0];
}

- (IBAction)changeBookmark2:(id)sender {
    Phrase *ph = [self.phraselist objectAtIndex:self.currentIndex];
    if (ph.isBookmarked) {
        ph.isBookmarked = NO;
        self.bookmarkImageVw2.image = [UIImage imageNamed:@"unmarked.png"];
    }
    else {
        ph.isBookmarked = YES;
        self.bookmarkImageVw2.image = [UIImage imageNamed:@"bookmarked.png"];
    }
    
    [self.delegate PhraseDetailViewDidChangeBookmarkForPhrase:[self.phraselist objectAtIndex:self.currentIndex]];

}

- (IBAction)changeBookmark1:(id)sender {
    Phrase *ph = [self.phraselist objectAtIndex:self.currentIndex];
    if (ph.isBookmarked) {
        ph.isBookmarked = NO;
        self.bookmarkImageVw1.image = [UIImage imageNamed:@"unmarked.png"];
    }
    else {
        ph.isBookmarked = YES;
        self.bookmarkImageVw1.image = [UIImage imageNamed:@"bookmarked.png"];
    }
    
    [self.delegate PhraseDetailViewDidChangeBookmarkForPhrase:[self.phraselist objectAtIndex:self.currentIndex]];
}

- (IBAction)viewSwiped:(UISwipeGestureRecognizer *)sender {
    switch ([sender direction]) {
        case UISwipeGestureRecognizerDirectionRight:
            [self animateToDirection:@"Right"];
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            [self animateToDirection:@"Left"];
            break;
        default:
            break;
    }
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)animateToDirection:(NSString *)direction{
    
    if ([direction isEqualToString:@"Right"]) {
        self.currentIndex --;
        
    }
    else {
        self.currentIndex ++;
    }
    if (self.currentIndex < 0) {
        self.currentIndex = [self.phraselist count] -1;
    }
    else if (self.currentIndex == [self.phraselist count]){
        self.currentIndex = 0;
    }

    
    
    UIView *currentView,*sideView;
    
    //self.engPhraseLabel1.text = @"view 1";
    //self.engPhraseLabel2.text = @"view 2";
    Phrase *phrase = [self.phraselist objectAtIndex:self.currentIndex];
    NSString *txt;
    //determine visible view
    if (self.view1.frame.origin.x == 0) {
        currentView = self.view1;
        sideView = self.view2;
        
        //set values for next view
        self.engPhraseLabel2.text = phrase.eng_version;
        self.jpnPhraseLabel2.text = phrase.jpn_version;
        txt = [NSString stringWithFormat:@"%@\n%@",phrase.eng_exmpl,phrase.jpn_exmpl];
        self.exampleField2.text = txt;
        
        if (phrase.isBookmarked) {
            self.bookmarkImageVw2.image = [UIImage imageNamed:@"bookmarked.png"];
        }
        else {
            self.bookmarkImageVw2.image = [UIImage imageNamed:@"unmarked.png"];
        }
    }
    else {
        currentView = self.view2;
        sideView = self.view1;
        
        self.engPhraseLabel1.text = phrase.eng_version;
        self.jpnPhraseLabel.text = phrase.jpn_version;
        txt = [NSString stringWithFormat:@"%@\n%@",phrase.eng_exmpl,phrase.jpn_exmpl];
        self.exampleField1.text = txt;
        
        if (phrase.isBookmarked) {
            self.bookmarkImageVw1.image = [UIImage imageNamed:@"bookmarked.png"];
        }
        else {
            self.bookmarkImageVw1.image = [UIImage imageNamed:@"unmarked.png"];
        }
    }

    CGRect _frame1,_frame2;
    _frame1 = currentView.frame;
    _frame2 = sideView.frame;
    
    
    
    if ([direction isEqualToString:@"Right"]) {
        _frame1.origin.x = 320;
        _frame2.origin.x = -320;
        [sideView setFrame: _frame2];
        _frame2.origin.x = 0;
    }
    else {
        _frame1.origin.x = -320;
        _frame2.origin.x = 320;
        [sideView setFrame:_frame2];
        _frame2.origin.x = 0;
    }
    
    [UIView animateWithDuration:.50 animations:^{
        [currentView setFrame:_frame1];
        [sideView setFrame:_frame2];
    }];
    
}

//- (void)phraseIsSeen{
//    //initiate database
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"AlarmDatabase.sqlite"];
//    
//    db = [FMDatabase databaseWithPath:dataPath];
//    
//    NSString *update = [NSString stringWithFormat:@"UPDATE Phraselist SET isNew = '%@' WHERE jpn = '%@' and eng = '%@'",@"No",self.ph.jpn_version,phrase.eng_version];
//    [db executeUpdate:update];
//}
@end
