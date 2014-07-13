//
//  beaconDBAction.m
//  iBeacon
//
//  Created by Yonghua Lin on 2/7/14.
//  Copyright (c) 2014 dastone. All rights reserved.
//

#import "beaconDBAction.h"
#import "beaconInfoData.h"

@implementation beaconDBAction

static NSString *checkCalibratedURL = @"http://114.215.109.207:3000/beacons/";

static NSString *fetchCalibrateURL = @"http://114.215.109.207:3000/fetchCalibrate.json";

static NSString *addBeaconwithCalibrateInfoURL = @"http://114.215.109.207:3000/beacons.json";

static NSString *updateCalibrateInfoURL = @"http://114.215.109.207:3000/updateCalibrateInfo.json";

+ (void)beaconAdd{
    
    
    return;
}




+ (NSString *)fetchCalibrateInfo: (beaconInfoData *)beacon_info{
    NSURL *req_url;

    req_url= [NSURL URLWithString: [[checkCalibratedURL stringByAppendingString:beacon_info.beaconID] stringByAppendingString:@".json"]];
    NSLog(@"%@", req_url);
 //   req_url = [NSURL URLWithString: checkCalibratedURL];
    NSString *return_str = nil;
    
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:req_url];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    
    if (error == nil)
    {
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"HttpResponseCode:%d", responseCode);
        NSLog(@"HttpResponseBody %@", responseString);
        if (responseCode == DBEntryfound){
            return_str = responseString;
        } else {
            return_str = nil;
        }
    } else {
        NSLog(@"Httperror:%@%d", error.localizedDescription, error.code);
    }
    
    return return_str;
}

+ (BOOL)checkCalibrated: (beaconInfoData *) beacon_info_data{
    if ([beaconDBAction fetchCalibrateInfo:beacon_info_data]){
        NSLog(@"Calibrated");
        return true;
    } else {
        NSLog(@"not calibrated");
        return false;
    }
}

+ (beaconInfoData *) parseJSONBeaconDB: (NSString *)beacon_json_str{
    
    
    NSData *data= [beacon_json_str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    
    beaconInfoData *beacon_info_data = [[beaconInfoData alloc] init];
    
    NSDictionary *beacon_json_dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    //NSDictionary *beacon_json_dic = (NSDictionary *)data;
    
    NSLog(@"Dersialized JSON Dictionary = %@", beacon_json_dic);
    
    NSDictionary *beacon_info = [beacon_json_dic objectForKey:@"beaconinfo"];
    
    beacon_info_data.uuid = [beacon_info objectForKey:@"UUID"];
    
    beacon_info_data.major = [beacon_info objectForKey:@"major"];
    
    beacon_info_data.minor = [beacon_info objectForKey:@"minor"];
    
    NSArray *beacon_metrics = [beacon_info objectForKey:@"BeaconMetrics"];
    
    [beacon_info_data.beaconMetrics setArray:beacon_metrics];
    
    return beacon_info_data;
     
}

+ (NSData *) buildJSONBeaconDB: (beaconInfoData *)beacon_info_data{
    
    NSLog(@"in buildJsonBeaconDB");
    
    NSMutableDictionary *beacon_info_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    
    NSData *beacon_info_json;
    
    NSError *error;
    
    //NSMutableArray *beacon_metrics;
    
    //NSMutableDictionary *beacon_matrix_entry;
    
    //NSUInteger entry_count;
    [beacon_info_dic setObject:beacon_info_data.beaconID forKey:@"beaconID"];
    [beacon_info_dic setObject:beacon_info_data.uuid forKey:@"uuid"];
    [beacon_info_dic setObject:beacon_info_data.major forKey:@"major"];
    [beacon_info_dic setObject:beacon_info_data.minor forKey:@"minor"];
    NSLog(@"bb1");
    NSLog(@"beacon_info_dic: %@", beacon_info_dic);
    [beacon_info_dic setObject:beacon_info_data.beaconMetrics forKey:@"BeaconMetrics"];
    NSLog(@"bb2");
 
    beacon_info_json = [NSJSONSerialization dataWithJSONObject:beacon_info_dic options: NSJSONWritingPrettyPrinted  error:&error];
    
    NSLog(@"bb3");
  
    if ([beacon_info_json length] > 0 && error == nil){
        return beacon_info_json;
    }else{
        return nil;
    }
    
    [beacon_info_dic removeAllObjects];
 //   NSLog(@"beacon_info_json is %@", beacon_info_json);
    return beacon_info_json;
}

    
+ (NSError *)addBeaconwithCalibrateInfo: (NSData *) beacon_info_json {
    
 //   NSString *JSONString = [dic JSONRepresentation];
 //   NSLog(@"Format JSON : %@", [JSONString description]);
    
    NSURL *postURL=[NSURL URLWithString:addBeaconwithCalibrateInfoURL];
 //   NSData *postData = [JSONString dataUsingEncoding:NSUTF8StringEncodingallowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[beacon_info_json length]];

    NSMutableURLRequest *requestPOST = [[NSMutableURLRequest alloc] init];
    
    NSError *error;

    [requestPOST setURL:postURL];
    [requestPOST setHTTPMethod:@"POST"];
    [requestPOST setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [requestPOST setValue:@"application/json"forHTTPHeaderField:@"Content-Type"];
    [requestPOST setHTTPBody:beacon_info_json];
    [requestPOST setTimeoutInterval:3];
    
    NSData *data=[NSURLConnection sendSynchronousRequest:requestPOST returningResponse:nil error:&error];
    NSString *dataContent = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"dataContent = %@",dataContent);
    NSLog(@"return data: %@", data);
  //  NSDictionary *items = [dataContent JSONValue];
  //  NSLog(@"items=%@",items);
    return error;
}



- (void)updateCalibrateInfo {
    
}

@end
