//
//  beaconManager.m
//  iBeacon
//
//  Created by ShaoLing on 13/6/14.
//  Copyright (c) 2014 dastone. All rights reserved.
//

#import "beaconManager.h"


@interface beaconManager ()

@property (strong, nonatomic)NSMutableArray     *beaconsInRegion;
@property (strong, nonatomic) CLBeaconRegion    *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end


@implementation beaconManager

@synthesize beaconsInRegion = _beaconsInRegion;
@synthesize beaconRegion = _beaconRegion;
@synthesize locationManager = _locationManager;

- (NSMutableArray *) beaconsInRegion {
    
    if (!_beaconsInRegion) {
        _beaconsInRegion = [[NSMutableArray alloc]init];
    }
    
    return _beaconsInRegion;
}

- (void)setBeaconsInRegion:(NSMutableArray *)beaconsInRegion {
    _beaconsInRegion = beaconsInRegion;
}

- (void)scanBeacons {
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    
}


- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    
    NSLog(@"%@", region);
    [self scanBeacons];
}

- (void)startMonitoringRegion {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:kBeaconStationUUID];
    //self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:nil identifier:nil];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:kID];
    
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    NSLog(@"init region");
    
}

- (void)stopMonitoringRegion {
    
    [self.locationManager stopMonitoringForRegion:self.beaconRegion];
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"did enter region");

    UILocalNotification *notification = [[UILocalNotification alloc]init];
    notification.alertBody = @"You enter the Region";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];

    //[self scanBeacons];

}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"did exit region");

    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    //self.beaconFoundLabel.text = @"No";
    
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    notification.alertBody = @"You leave the Region";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    
    NSLog(@"did range beacons");
    CLBeacon *beacon = [[CLBeacon alloc] init];
    
    /*for (beacon in beacons) {
        [self.beaconsInRegion addObject:beacon];
        NSLog(@"%@", beacon);
    }*/
    
    self.beaconsInRegion = beacons;
    
    //beacon = [beacons lastObject];
    NSNotification *notification = [NSNotification notificationWithName:@"beacons" object:nil];
    
    [[NSNotificationCenter defaultCenter]postNotification:notification];
    
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


@end
