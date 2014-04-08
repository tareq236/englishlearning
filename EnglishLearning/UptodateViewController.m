//
//  UptodateViewController.m
//  EnglishLearning
//
//  Created by TML BD on 4/5/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import "UptodateViewController.h"
#import "TMLAppDelegate.h"
#import "UptodateDetailsViewController.h"

@interface UptodateViewController (){
    NSArray *types;
}

@end

@implementation UptodateViewController

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
    
    types = [[NSArray alloc]init];
    TMLAppDelegate *appDel = (TMLAppDelegate *)[UIApplication sharedApplication].delegate;
    appDel.apiManager.delegate = self;
    [appDel.apiManager fetchUptoDateInformation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UptodateDetailsViewController *udvc = (UptodateDetailsViewController *)segue.destinationViewController;
    udvc.details = sender;
}

#pragma mark Helper Methods

- (void)decorateView{
}

#pragma mark - APIManager Delegate 

-(void)uptoDateInFormation:(NSArray *)infos{
    types = infos;
    [self.listTableView reloadData];
}

#pragma mark - TableView Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = [[types objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"showDetails" sender:[[types objectAtIndex:indexPath.row] objectForKey:@"details"]];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return types.count;
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
