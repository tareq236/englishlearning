//
//  PhrasesViewController.m
//  LEO1
//
//  Created by TML BD on 3/24/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import "PhrasesViewController.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "Phrase.h"
#import "PhraseCell.h"
#import "PhraseDetailViewController.h"
#import "TMLAppDelegate.h"

@interface PhrasesViewController (){
    FMDatabase *db;
    NSArray *phrases;
    TMLAppDelegate *appDel;
}

@end

@implementation PhrasesViewController

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
    
    //initiate database
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"AlarmDatabase.sqlite"];
    
    db = [FMDatabase databaseWithPath:dataPath];
    
    self.tableVw.delegate = self;
    self.tableVw.dataSource = self;
    
    phrases = [[NSMutableArray alloc]init];
    appDel = (TMLAppDelegate *)[UIApplication sharedApplication].delegate;
    //phrases = [appDel.databaseManager getPhrasesFromDatabase];
    //[self loadData];
    [self.tableVw reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    phrases = [appDel.databaseManager getPhrasesFromDatabase];//[self loadData];
    [self.tableVw reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

////-(void)loadData{
//    [phrases removeAllObjects];
//    @try {
//        [db open];
//        FMResultSet *results = [db executeQuery:@"SELECT DISTINCT eng from PhraseList"];
//        
//        Phrase *phrase;
//        while ([results next]) {
//            FMResultSet *results1 = [db executeQuery:[NSString stringWithFormat:@"SELECT * from PhraseList where eng='%@'",[results stringForColumn:@"eng"]]];
//            [results1 next];
//            
//            phrase = [[Phrase alloc]init];
//            phrase.eng_version = [results1 stringForColumn:@"eng"];
//            phrase.jpn_version = [results1 stringForColumn:@"jpn"];
//            phrase.eng_exmpl = [results1 stringForColumn:@"eng_exmpl"];
//            phrase.jpn_exmpl = [results1 stringForColumn:@"jpn_exmpl"];
//            if([[results1 stringForColumn:@"isBookmarked"] isEqualToString:@"Yes"]) phrase.isBookmarked = YES;
//            else phrase.isBookmarked = NO;
//            if([[results1 stringForColumn:@"isNew"] isEqualToString:@"Yes"]) phrase.isNew = YES;
//            else phrase.isNew = NO;
//            
//            [phrases addObject:phrase];//NSLog(@"status-%hhd",[phrase isBookmarked]);
//        }
//    }
//    @catch (NSException *exception) {
//        NSLog(@"error in database fetching- %@",[exception description]);
//    }
//    @finally {
//        [db close];
//    }
//
//}


#pragma mark - Table View Delegate And Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [phrases count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PhraseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"phraseCell"];
    
    if (!cell) {
        cell = [[PhraseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"phraseCell"];
    }
    
    [cell decorateCellWithPhrase:[phrases objectAtIndex:indexPath.row]];
    cell.delegate = self;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"showPhraseDetails" sender:indexPath];
    [self changeNewStatusForPhrase:[phrases objectAtIndex:indexPath.row]];
    
    PhraseCell *cell = (PhraseCell *)[self.tableVw cellForRowAtIndexPath:indexPath];
    cell.statusImageVw.image = nil;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"showPhraseDetails"]) {
        PhraseDetailViewController *pdvc = (PhraseDetailViewController *)[segue destinationViewController];
        pdvc.phraselist = phrases;
        NSIndexPath *index = sender;
        pdvc.currentIndex = index.row;
        pdvc.delegate = self;
    }
    
}

#pragma mark - PhraseCell delegate

-(void)changeBookmarkStatusForPhrase:(Phrase *)phrase{
    
    
    @try {
        [db open];
        [db clearCachedStatements];
        NSString *status = [NSString new];
        if (phrase.isBookmarked) {
            status = @"Yes";
        } else status = @"No";
        NSString *update = [NSString stringWithFormat:@"UPDATE Phraselist SET isBookmarked = '%@' WHERE jpn = '%@' and eng = '%@'",status,phrase.jpn_version,phrase.eng_version];
        [db executeUpdate:update];
        //[db executeUpdate:@"UPDATE Phraselist SET isBookmarked = ? WHERE jpn = ? and eng = ?",status,phrase.jpn_version,phrase.eng_version];
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"bookmark update error - %@",exception);
    }
    @finally {
        [db clearCachedStatements];
        [db close];
        NSLog(@"updated");
    }
}


-(void)changeNewStatusForPhrase:(Phrase *)phrase{
    
    
    @try {
        [db open];
        [db clearCachedStatements];
        NSString *status = [NSString new];
        status = @"No";
        NSString *update = [NSString stringWithFormat:@"UPDATE Phraselist SET isNew = '%@' WHERE jpn = '%@' and eng = '%@'",status,phrase.jpn_version,phrase.eng_version];
        [db executeUpdate:update];
        //[db executeUpdate:@"UPDATE Phraselist SET isBookmarked = ? WHERE jpn = ? and eng = ?",status,phrase.jpn_version,phrase.eng_version];
        phrase.isNew = NO;
        
    }
    @catch (NSException *exception) {
        NSLog(@"new update error - %@",exception);
    }
    @finally {
        [db clearCachedStatements];
        [db close];
        NSLog(@" phrase old status updated");
    }
}

#pragma mark PhraseDetailViewController Delegate

- (void)PhraseDetailViewDidChangeBookmarkForPhrase:(Phrase *)ph{
    [self changeBookmarkStatusForPhrase:ph];
    [self.tableVw reloadData];
}

@end
