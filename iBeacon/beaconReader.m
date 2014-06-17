//
//  beaconReader.m
//  iBeacon
//
//  Created by ShaoLing on 6/6/14.
//  Copyright (c) 2014 dastone. All rights reserved.
//

#import "beaconReader.h"

@interface beaconReader ()
@property (weak, nonatomic) IBOutlet UILabel *beaconFoundLabel;
@property (weak, nonatomic) IBOutlet UILabel *proximityUUIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (weak, nonatomic) IBOutlet UILabel *minorLabel;
@property (weak, nonatomic) IBOutlet UILabel *accuracyLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *rssiLabel;

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation beaconReader

@synthesize beaconRegion = _beaconRegion;
@synthesize locationManager = _locationManager;

- (IBAction)valueChanged:(UISwitch *)sender {
    if (sender.isOn) {
        [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    } else {
        [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    }
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    self.beaconFoundLabel.text = @"did start monitoring";
}

- (void)initRegion {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:kBeaconStationUUID];
    //self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:nil identifier:nil];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:kID];
    
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    self.beaconFoundLabel.text = @"init success";
    //NSLog(@"init region");
    
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"did enter region");
    self.beaconFoundLabel.text = @"did enter region";
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    notification.alertBody = @"You enter the Region";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"did exit region");
    self.beaconFoundLabel.text = @"did exit success";
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    //self.beaconFoundLabel.text = @"No";

    UILocalNotification *notification = [[UILocalNotification alloc]init];
    notification.alertBody = @"You leave the Region";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];

}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    CLBeacon *beacon = [[CLBeacon alloc] init];
    beacon = [beacons lastObject];
    
    //self.beaconFoundLabel.text = @"Yes";
    self.proximityUUIDLabel.text = beacon.proximityUUID.UUIDString;
    self.majorLabel.text = [NSString stringWithFormat:@"%@", beacon.major];
    self.minorLabel.text = [NSString stringWithFormat:@"%@", beacon.minor];
    self.accuracyLabel.text = [NSString stringWithFormat:@"%f", beacon.accuracy];
    if (beacon.proximity == CLProximityUnknown) {
        self.distanceLabel.text = @"Unknown Proximity";
    } else if (beacon.proximity == CLProximityImmediate) {
        self.distanceLabel.text = @"Immediate";
    } else if (beacon.proximity == CLProximityNear) {
        self.distanceLabel.text = @"Near";
    } else if (beacon.proximity == CLProximityFar) {
        self.distanceLabel.text = @"Far";
    }
    self.rssiLabel.text = [NSString stringWithFormat:@"%i", beacon.rssi];
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    
    if (state == CLRegionStateInside) {
        notification.alertBody = @"You are in Region";
    } else if (state == CLRegionStateOutside) {
        notification.alertBody = @"You are out of Region";
    } else {
        return;
    }
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self initRegion];
    [self locationManager:self.locationManager didStartMonitoringForRegion:self.beaconRegion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    [self.locationManager stopMonitoringForRegion:self.beaconRegion];
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    
}


@end
