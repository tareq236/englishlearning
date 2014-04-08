//
//  EpisodeListViewController.m
//  EnglishLearning
//
//  Created by TML BD on 4/3/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import "EpisodeListViewController.h"
#import "EpisodeListCell.h"
#import "TMLAppDelegate.h"
#import "MBProgressHUD.h"
#import "StudyViewController.h"

@interface EpisodeListViewController (){
    NSArray *episodeList;
    TMLAppDelegate *appDelegate;
}

@end

@implementation EpisodeListViewController

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
    appDelegate = (TMLAppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.apiManager.delegate = self;
    episodeList = [[NSArray alloc] init];
    [self loadData];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if ([segue.identifier isEqualToString:@"showQuiz"]) {
//        QuizViewController *qvc = (QuizViewController *)segue.destinationViewController;
//        qvc.e_id = self.episode.identifier;
//        //qvc.episode = self.episode;
//        //NSLog(@"%@ %@",qvc.episode.identifier,self.episode.identifier);
//    }
//}

#pragma mark - helper method

- (void)loadData{
    
    
    //fetch from database
    episodeList = [appDelegate.databaseManager getEpisodeListFromDatabase];
    //fetch from api
    [appDelegate.apiManager fetchEpisodeListFromApi];
}

- (void)syncDtabaseResultsWithFetchedResult:(NSArray *)fetched{
    NSMutableArray *syncdList = [[NSMutableArray alloc] initWithArray:episodeList];
    
    for (Episode *ep in fetched) {

        if (![appDelegate.databaseManager ifEpisodeSavedInDatabase:ep]) {
            NSLog(@"episode -%@ already not in database",ep.episodeTitle);
            [syncdList addObject:ep];
        }
        
    }
    
    episodeList = syncdList;
    syncdList = nil;
    
}


#pragma mark - Table Viewn DataSource and Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return episodeList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EpisodeListCell *cell = (EpisodeListCell *)[self.listTableView dequeueReusableCellWithIdentifier:@"EpisodeCell"];
    
    if (!cell) {
        cell = [[EpisodeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EpisodeCell"];
    }
    cell.delegate = self;
    [cell decorateCellWithEpisode:[episodeList objectAtIndex:indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Episode *epsd = (Episode *)[episodeList objectAtIndex:indexPath.row];
    
    
    
    if (epsd.isSaved) {
//        if ([epsd.episodeId isEqualToString:@"2505"]) {
//            [self triedToUpdateEpisode:epsd];
//        }
//        else {
        //check for updates
        //[appDelegate.apiManager tryToUpdateEpisode:epsd];
        //appDelegate.apiManager.delegate = self;
        //}
        // do this when after trying to update
        ////this work will be done in delegation method triedToUpdate
    epsd = [appDelegate.databaseManager getEpisodeFromDatabaseForId:epsd.episodeId];
    
    UIStoryboard *storyboard = [appDelegate getAppropriateStoryboard];
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    StudyViewController *studyViewController = [storyboard instantiateViewControllerWithIdentifier:@"StudyView"];
    studyViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    studyViewController.delegate = self;
    studyViewController.episode = epsd;
    
    [self presentViewController:studyViewController animated:YES completion:nil];
    }
//    epsd = [appDelegate.databaseManager getEpisodeFromDatabaseForId: epsd.episodeId];
//    
//    [appDelegate showAudioPlayerInViewController:self withEpisode:epsd];
    
}





#pragma mark APIManager Delegate

-(void)resultsForFetchingEpisodeList:(NSArray *)episodes{
    //NSArray *fetchedList = episodes;
    [self syncDtabaseResultsWithFetchedResult:episodes];
    [self.listTableView reloadData];
}

-(void)triedToUpdateEpisode:(Episode *)ep{
    ep = [appDelegate.databaseManager getEpisodeFromDatabaseForId:ep.episodeId];
    
    UIStoryboard *storyboard = [appDelegate getAppropriateStoryboard];
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    StudyViewController *studyViewController = [storyboard instantiateViewControllerWithIdentifier:@"StudyView"];
    studyViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    studyViewController.delegate = self;
    studyViewController.episode = ep;
    
    [self presentViewController:studyViewController animated:YES completion:nil];
}

#pragma mark - EpisodeCell delegate

-(void)downloadingStarted{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)downloadingFinished{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    //[self loadData];
    [self.listTableView reloadData];
}


#pragma mark StudyViewController Delegate

-(void)studyViewControllerDidFinishStudy{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)goBack:(id)sender {NSLog(@"jjj");
    [self.navigationController popViewControllerAnimated:YES];
}
@end
