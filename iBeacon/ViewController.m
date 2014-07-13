//
//  ViewController.m
//  iBeacon
//
//  Created by ShaoLing on 27/5/14.
//  Copyright (c) 2014 dastone. All rights reserved.
//

#import "ViewController.h"


@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *mobileUUID;
    
    mobileUUID = [[NSProcessInfo processInfo] globallyUniqueString];
    
    NSLog(@"My UUID is %@", mobileUUID);
	// Do any additional setup after loading the view, typically from a nib.
    
    //To put the local DB operation here. To load the beaconInfo. from DB. 
}

- (NSString *)dbFilePath{
    NSArray *dbPaths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *dbDocPath = [dbPaths objectAtIndex:0];
    NSString *dbFileName = [dbDocPath stringByAppendingPathComponent:@"data.db"];
    NSLog(@"%@", dbFileName);
    return dbFileName;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


@end
