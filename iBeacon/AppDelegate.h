//
//  AppDelegate.h
//  iBeacon
//
//  Created by ShaoLing on 27/5/14.
//  Copyright (c) 2014 dastone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "beaconCalibrate.h"

@class beaconCalibrate;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) IBOutlet beaconCalibrate *mybeaconCalibrate;

@end
