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
    
    self.beaconMetrics = [NSMutableArray arrayWithCapacity:5];
    return self;

}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_beaconID forKey:@"_beaconID"];
    [aCoder encodeObject:_uuid forKey:@"_uuid"];
    [aCoder encodeObject:_major forKey:@"_major"];
    [aCoder encodeObject:_minor forKey:@"_minor"];
    [aCoder encodeObject:_beaconMetrics forKey:@"_beaconMetrics"];
}

- (id)initWithCoder: (NSCoder *)aDecoder
{
    if (self == [super init])
    {
        _beaconID = [aDecoder decodeObjectForKey:@"_beaconID"];
        _uuid = [aDecoder decodeObjectForKey:@"_uuid"];
        _minor = [aDecoder decodeObjectForKey:@"_minor"];
        _major = [aDecoder decodeObjectForKey:@"_major"];
        _beaconMetrics = [aDecoder decodeObjectForKey:@"_beaconMetric"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    beaconInfoData *beaconInfo = [[[self class] allocWithZone:zone] init];
    
    beaconInfo.beaconID = [self.beaconID copyWithZone:zone];
    beaconInfo.beaconMetrics = [self.beaconMetrics copyWithZone:zone];
    beaconInfo.uuid = [self.uuid copyWithZone:zone];
    beaconInfo.major = [self.major copyWithZone:zone];
    beaconInfo.minor = [self.minor copyWithZone:zone];
    
    return beaconInfo;
}

@end
