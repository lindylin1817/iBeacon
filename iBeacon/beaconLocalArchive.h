//
//  beaconLocalArchive.h
//  iBeacon
//
//  Created by Yonghua Lin on 12/7/14.
//  Copyright (c) 2014 dastone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "beaconInfoData.h"

@interface beaconLocalArchive : NSObject

+(void)beaconInfoSave : (beaconInfoData *)beaconInfo error : (NSError *)error;
+(beaconInfoData *)beaconInfoQuery : (NSString *)beaconID error : (NSError *)error;

-(NSString *)fileName: (NSString *)beaconID;

@end
