//
//  beaconInfoData.h
//  iBeacon
//
//  Created by Yonghua Lin on 3/7/14.
//  Copyright (c) 2014 dastone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface beaconInfoData : NSObject{
@public NSString *beaconID;
@public NSString *uuid;
@public NSString *major;
@public NSString *minor;
@public NSMutableArray *beaconMetrics;
    

}

//+(beaconInfoData *) alloc;

+(beaconInfoData *) init;

@end
