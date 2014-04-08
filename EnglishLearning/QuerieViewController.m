//
//  QuerieViewController.m
//  EnglishLearning
//
//  Created by TML BD on 4/4/14.
//  Copyright (c) 2014 TML BD. All rights reserved.
//

#import "QuerieViewController.h"
#import "TMLAppDelegate.h"

@interface QuerieViewController (){
    NSDictionary *information;
}

@end

@implementation QuerieViewController

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
    
    [self decorateViewController];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectQueryType:(id)sender {
}

- (IBAction)submitAction:(id)sender {
    
    //prepare mail
    NSString *msg = [NSString stringWithFormat:@"Message - %@\n\nInformation - %@",self.bodyTextView.text,self.informationTextView.text];


    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.subjectTextField.text,@"userEmail",self.queryTypeLabel.text,@"queryType",msg,@"msgBody", nil];
    TMLAppDelegate *appDel = (TMLAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDel.apiManager sendMail:dic];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)goBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    QueryTypeViewController *qtvc = (QueryTypeViewController *)segue.destinationViewController;
    
    qtvc.delegate = self;
}

#pragma mark - Helper Method

- (void)decorateViewController{
    self.queryScrollView.contentSize = CGSizeMake(320, 500);
    
    self.bodyTextView.layer.borderColor = [UIColor redColor].CGColor;
    self.bodyTextView.layer.borderWidth = 2;
    
    self.informationTextView.layer.borderColor = [UIColor redColor].CGColor;
    self.informationTextView.layer.borderWidth = 2;
    
    
    [self getInformation];
    
    NSString *ios_V =[information valueForKey:@"iOSVersion"];
    NSString *device = [information valueForKey:@"devicemodel"];
    NSArray *values = [information valueForKey:@"AppVersion"];
    
    
    NSString *info = [NSString stringWithFormat:@"iOS Version - %@\nDevice Model - %@\nApp Version - %@",ios_V,device,values];
    
    self.informationTextView.text =info;
    //self.queryType.backgroundColor = [UIColor grayColor];
}

- (void)getInformation{
    NSArray *keys = [NSArray arrayWithObjects:@"iOSVersion",@"deviceVesion",@"AppVersion", nil];
    NSString *ios_V =[[UIDevice currentDevice] systemVersion];
    NSString *device = [[UIDevice currentDevice] systemName];//[self platformNiceString];NSLog(@"ver - %@",device);
    NSArray *values = [NSArray arrayWithObjects:ios_V,device,@"1.1.0", nil];
    
    information = [NSDictionary dictionaryWithObject:values forKey:keys];
}

///these two methods are for device model
//- (NSString *)platformRawString {
//    
//    size_t size;
//    
//    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
//    
//    char *machine = malloc(size);
//    
//    sysctlbyname("hw.machine", machine, &size, NULL, 0);
//    
//    NSString *platform = [NSString stringWithUTF8String:machine];
//    
//    free(machine);
//    
//    return platform;
//    
//}
//
//- (NSString *)platformNiceString {
//    
//    NSString *platform = [self platformRawString];
//    
//    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
//    
//    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
//    
//    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
//    
//    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
//    
//    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
//    
//    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
//    
//    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
//    
//    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
//    
//    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
//    
//    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
//    
//    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
//    
//    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad 1";
//    
//    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
//    
//    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
//    
//    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
//    
//    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
//    
//    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (4G,2)";
//    
//    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (4G,3)";
//    
//    if ([platform isEqualToString:@"i386"])         return @"Simulator";
//    
//    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
//    
//    return platform;
//    
//}

#pragma mark - QueryTypeViewController Delegate

-(void)queryTypeIsSelectedWithType:(NSString *)type{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.queryTypeLabel.text = type;
    });NSLog(@"%@",type);
    
}

#pragma mark - Text Field and Text View Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


@end
