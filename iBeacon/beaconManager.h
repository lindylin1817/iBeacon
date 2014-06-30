//
//  beaconManager.h
//  iBeacon
//
//  Created by ShaoLing on 13/6/14.
//  Copyright (c) 2014 dastone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface beaconManager : NSObject <CLLocationManagerDelegate>

- (NSMutableArray *) beaconsInRegion;
- (void)scanBeacons;
- (void)startMonitoringRegion;
- (void)stopMonitoringRegion;

@end

#define kBeaconStationUUID @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"
#define kID @"com.my.AirLocate"
#define kPower @-59