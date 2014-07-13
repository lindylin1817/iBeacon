//
//  beaconInfoData.h
//  iBeacon
//
//  Created by Yonghua Lin on 3/7/14.
//  Copyright (c) 2014 dastone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface beaconInfoData : NSObject<NSCoding, NSCopying>


@property (nonatomic, retain) NSString *beaconID;
@property (nonatomic, retain) NSString *uuid;
@property (nonatomic, retain) NSString *major;
@property (nonatomic, retain) NSString *minor;
@property (nonatomic, retain) NSMutableArray *beaconMetrics;
    


//+(beaconInfoData *) alloc;

+(beaconInfoData *) init;

@end
