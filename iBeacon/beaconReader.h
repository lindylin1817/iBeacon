//
//  beaconReader.h
//  iBeacon
//
//  Created by ShaoLing on 6/6/14.
//  Copyright (c) 2014 dastone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface beaconReader : UITableViewController <CLLocationManagerDelegate>

- (void)setBeaconDetails:(CLBeacon*)beacon;

@end
