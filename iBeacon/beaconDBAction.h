//
//  beaconDBAction.h
//  iBeacon
//
//  Created by Yonghua Lin on 2/7/14.
//  Copyright (c) 2014 dastone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "beaconInfoData.h"

@interface beaconDBAction : NSObject{
   
}

//- (void)beaconDBQuery;
//- (void)beaconDBAdd;
//- (void)beaconDBInit;



+ (BOOL)checkCalibrated : (NSString *)beaconID;
+ (NSData *) buildJSONBeaconDB: (beaconInfoData *)beacon_info_data;
- (void)fetchCalibrateInfo;
+ (NSError *)addBeaconwithCalibrateInfo: (NSData *)beacon_info_json;
- (void)updateCalibrateInfo;

#define DBEntryfound 200
#define DBEntryNotfound 202

@end
