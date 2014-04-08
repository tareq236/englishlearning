//
//  StudyViewController.m
//  EnglishLearning
//
//  Created by TML BD on 4/4/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import "StudyViewController.h"
#import "Phrase.h"
#import "TMLAppDelegate.h"
#import "QuizViewController.h"


@interface StudyViewController (){
    int case_count;
    Case *cse;
    AudioPlayerViewController *player;
}

@end

@implementation StudyViewController

@synthesize episode,parentClass;

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
    


    
    self.detailTextView.layer.borderColor = [UIColor redColor].CGColor;
    self.detailTextView.layer.borderWidth = 5;
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    case_count = 0;
    [self decorateViewController];
    [self loadPlayer];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [player releasePlayer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showQuizView"]) {
        QuizViewController *qvc = (QuizViewController *)segue.destinationViewController;
        qvc.episode = self.episode;
    }
}


#pragma mark - Hepler Methods

- (void)decorateViewController{
    cse = [self.episode.cases objectAtIndex:case_count];
    
    self.topBarLabel.text = [NSString stringWithFormat:@"%@ - Case %i",self.episode.episodeTitle,case_count+1];//self.episode.episodeTitle;
    self.detailTextView.text = cse.doc_eng;
    
}

- (IBAction)showEnglishVersion:(id)sender {
    cse = [self.episode.cases objectAtIndex:case_count];
    self.detailTextView.text = cse.doc_eng;
}

- (IBAction)showJapaneseVersion:(id)sender {
    cse = [self.episode.cases objectAtIndex:case_count];
    self.detailTextView.text = cse.doc_jpn;
}

- (IBAction)showPhrase:(id)sender {
    //parse phrase into string
    NSString *str = @"";
    
    for (Phrase *phrase in cse.phrases) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"English - %@\nJapanese - %@\n\n",phrase.eng_version,phrase.jpn_version]];
    }
    
    self.detailTextView.text = str;
}

- (void)loadPlayer{
    ////*****load player
    TMLAppDelegate *appDel = (TMLAppDelegate *)[UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [appDel getAppropriateStoryboard];
    player = (AudioPlayerViewController *)[storyboard instantiateViewControllerWithIdentifier:@"AudioPlayer"];
    player.delegate = self;
    player.episode = self.episode;
    player.parentClass = @"StudyView";
    CGRect _frame = player.view.frame;
    _frame.origin.y = 380;
    [player.view setFrame:_frame];
    
    [self.view addSubview:player.view];

    //[appDel showAudioPlayerInViewController:self withEpisode:self.episode];
}

- (IBAction)doneStudy:(id)sender {
    if ([self.parentClass isEqualToString:@"Root"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    [self.delegate studyViewControllerDidFinishStudy];
}



#pragma mark - Audio Player View COntroller Delegate

-(void)audioPlayerClickedNext{NSLog(@" case - %i out of %i",case_count,self.episode.cases.count);
    if (case_count  < self.episode.cases.count) {
        case_count ++;
        [self decorateViewController];
    }
}

-(void)audioPlayerClickedPrevious{
    case_count --;
    [self decorateViewController];
}

-(void)showQuizViewController{
    TMLAppDelegate *appDel = (TMLAppDelegate *)[UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [appDel getAppropriateStoryboard];
    QuizViewController *qvc = [storyboard instantiateViewControllerWithIdentifier:@"QuizView"];
    qvc.episode = self.episode;
    qvc.delegate = self;
    [self presentViewController:qvc animated:YES completion:nil];
}

#pragma mark - QuizViewController Delegate

-(void)quizViewControllerDidFinish{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
