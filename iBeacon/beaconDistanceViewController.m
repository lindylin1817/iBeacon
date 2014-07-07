//
//  beaconDistanceViewController.m
//  iBeacon
//
//  Created by Yonghua Lin on 7/7/14.
//  Copyright (c) 2014 dastone. All rights reserved.
//

#import "beaconDistanceViewController.h"
#import "beaconManager.h"

@interface beaconDistanceViewController ()

@property (strong, nonatomic)beaconManager  *beaconManager;
@property (strong, nonatomic)NSArray        *beaconList;

@end

@implementation beaconDistanceViewController

@synthesize beaconManager = _beaconManager;
@synthesize beaconList = _beaconList;

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
    
    self.beaconManager = [[beaconManager alloc] init];
    [self.beaconManager startMonitoringRegion];
    
    [[NSNotificationCenter defaultCenter]addObserverForName:@"beacons" object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        _beaconList = self.beaconManager.beaconsInRegion;
        
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
