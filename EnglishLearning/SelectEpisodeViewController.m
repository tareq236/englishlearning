//
//  SelectEpisodeViewController.m
//  EnglishLearning
//
//  Created by S A Chowdhury on 4/4/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import "SelectEpisodeViewController.h"
#import "Episode.h"
#import "TMLAppDelegate.h"
#import "SelectEpisodeCell.h"
#import "AlarmOptionViewController.h"


@interface SelectEpisodeViewController (){
    NSArray *episodeList;
    TMLAppDelegate *appDelegate;
}

@end

@implementation SelectEpisodeViewController

@synthesize mode;

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
    appDelegate = (TMLAppDelegate *)[UIApplication sharedApplication].delegate;
    
    
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [self fetchEpisodeList];
    [self.listTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goNextAction:(id)sender {
    NSArray *viewControllers = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[viewControllers objectAtIndex:1] animated:YES];
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if ([self.mode isEqualToString:@"full"]) {
//        AlarmOptionViewController *aovc = (AlarmOptionViewController *)segue.destinationViewController;
//        aovc.type = @"PushNotification";
//    }
//    
//}


#pragma mark - TableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return episodeList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectEpisodeCell *cell = (SelectEpisodeCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell) {
        cell = [[SelectEpisodeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    [cell decorateCellWithEpisode:[episodeList objectAtIndex:indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectEpisodeCell *cell = (SelectEpisodeCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell selectEpisodeAction:nil];
}


#pragma mark- Helper Method

- (void)fetchEpisodeList{
    episodeList = [[NSArray alloc]init];
    episodeList = [appDelegate.databaseManager getEpisodeListFromDatabase];
}
@end
