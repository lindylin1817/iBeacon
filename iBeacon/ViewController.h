//
//  ViewController.h
//  iBeacon
//
//  Created by ShaoLing on 27/5/14.
//  Copyright (c) 2014 dastone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"


@interface ViewController : UIViewController

@property (assign, nonatomic)sqlite3 *beaconDB;

- (void)openDB;
- (void)createBeaconList;
- (void)insertBeacon;

@end
