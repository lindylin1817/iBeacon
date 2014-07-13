//
//  beaconLocalArchive.m
//  iBeacon
//
//  Created by Yonghua Lin on 12/7/14.
//  Copyright (c) 2014 dastone. All rights reserved.
//

#import "beaconLocalArchive.h"
#import "beaconInfoData.h"

@implementation beaconLocalArchive

-(NSString *)fileName: (NSString *)beaconID{
    
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *tempStr = [beaconID stringByAppendingString:@".arch"];
    return [Path stringByAppendingPathComponent:tempStr];

}

+(void)beaconInfoSave : (beaconInfoData *)beaconInfo error : (NSError *)error {
    
    NSString *errStr = [error localizedDescription];
    
    if (!beaconInfo){
        errStr = @"beaconInfo is nil";
        return;
    }
    
    if (!beaconInfo.beaconID){
        errStr = @"beaconID is nil";
        return;
    }
    
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *tempStr = [beaconInfo.beaconID stringByAppendingString:@".arch"];
    NSString *filename = [Path stringByAppendingPathComponent:tempStr];
    
    NSLog(@"beacon data is saved at %@", filename);
    
    NSMutableData *data = [[NSMutableData alloc] init ];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:beaconInfo forKey:@"datakey"];
    [archiver finishEncoding];
    [data writeToFile:filename atomically:YES];
                                 
    NSLog(@"save finishe");
    errStr = nil;
    return;
}

+(beaconInfoData *)beaconInfoQuery : (NSString *)beaconID : error:(NSError *)error {
    
    NSString *errStr = [error localizedDescription];
    
    beaconInfoData *beacon_info;
    
    if (!beaconID){
        errStr = @"beaconID is nil";
        return nil;
    }
    
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [[Path stringByAppendingPathComponent:beaconID] stringByAppendingPathComponent:@".arch"];
    
    beacon_info = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
    
    if (!beacon_info){
        errStr = (@"There is no beacon_info for beacon ID %@", beaconID);
    }
    
    
    return beacon_info;
}

@end
