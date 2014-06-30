//
//  beaconReader.m
//  iBeacon
//
//  Created by ShaoLing on 6/6/14.
//  Copyright (c) 2014 dastone. All rights reserved.
//

#import "beaconReader.h"

@interface beaconReader ()

@property (strong, nonatomic)NSArray        *beaconDetailsTitle;
@property (strong, nonatomic)NSMutableArray *beaconDetailsValue;

@end

@implementation beaconReader

@synthesize beaconDetailsTitle = _beaconDetailsTitle;
@synthesize beaconDetailsValue = _beaconDetailsValue;



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    /*self.beaconInfo = [self.beaconManager getBeaconsInfo];
     
     return [self.beaconInfo count];*/
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.beaconDetailsTitle count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"beacon details cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    NSInteger row = indexPath.row;
    
    cell.textLabel.text = [self.beaconDetailsTitle objectAtIndex:row];
    cell.detailTextLabel.text = [self.beaconDetailsValue objectAtIndex:row];
    
    return cell;
}

- (void)setBeaconDetails:(CLBeacon*)beacon {

    if (!_beaconDetailsTitle) {
        _beaconDetailsTitle = [NSArray arrayWithObjects:@"UUID", @"major", @"minor", @"distance", @"rssi", nil];
    }
    
    if (!_beaconDetailsValue) {
        _beaconDetailsValue = [[NSMutableArray alloc]init];
    }

    NSString *major = [[NSString alloc]initWithFormat:@"%@", beacon.major];
    NSString *minor = [[NSString alloc]initWithFormat:@"%@", beacon.minor];
    
    NSString *distance = [[NSString alloc]init];
    if (beacon.proximity == CLProximityUnknown) {
        distance = @"Unknow proximity";
    } else if (beacon.proximity == CLProximityImmediate) {
        distance = @"Immediate";
    } else if (beacon.proximity == CLProximityNear) {
        distance = @"Near";
    } else if (beacon.proximity == CLProximityFar) {
        distance = @"Far";
    }
    
    NSString *rssi = [[NSString alloc]initWithFormat:@"%li", beacon.rssi];
    
    [self.beaconDetailsValue addObject:beacon.proximityUUID.UUIDString];
    [self.beaconDetailsValue addObject:major];
    [self.beaconDetailsValue addObject:minor];
    [self.beaconDetailsValue addObject:distance];
    [self.beaconDetailsValue addObject:rssi];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
}


@end
