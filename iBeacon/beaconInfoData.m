//
//  beaconInfoData.m
//  iBeacon
//
//  Created by Yonghua Lin on 3/7/14.
//  Copyright (c) 2014 dastone. All rights reserved.
//

#import "beaconInfoData.h"
#import "objc/runtime.h"

@implementation beaconInfoData

/*
+(beaconInfoData *) alloc {
    /*
    beaconInfoData *_beaconInfoData = [beaconInfoData alloc];
    _beaconInfoData->beaconMetrics = [NSMutableArray arrayWithCapacity:5];
    return _beaconInfoData;
    return (*_zoneAlloc)((Class)self, 0, malloc_default_zone());
}*/

-(beaconInfoData *) init {
    
    self->beaconMetrics = [NSMutableArray arrayWithCapacity:5];
    return self;

}

@end
