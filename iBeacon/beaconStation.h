//
//  beaconStation.h
//  iBeacon
//
//  Created by ShaoLing on 6/6/14.
//  Copyright (c) 2014 dastone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface beaconStation : UIViewController <CBPeripheralManagerDelegate>

- (void)initPublishBeacon;

@end
