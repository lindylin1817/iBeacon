//
//  beaconStation.m
//  iBeacon
//
//  Created by ShaoLing on 6/6/14.
//  Copyright (c) 2014 dastone. All rights reserved.
//

#import "beaconStation.h"

@interface beaconStation ()

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
@property (weak, nonatomic) IBOutlet UILabel *labelUUID;
@property (weak, nonatomic) IBOutlet UILabel *labelStatus;


@end

@implementation beaconStation

@synthesize beaconRegion = _beaconRegion;
@synthesize peripheralManager = _peripheralManager;



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Create the peripheral manager.
    self.peripheralManager = [[CBPeripheralManager alloc]
                              initWithDelegate:self queue:nil options:nil];
    
    [self initPublishBeacon];
}


- (IBAction)valueChanged:(UISwitch *)sender {
    UISwitch *swc = sender;
    
    if (swc.isOn) {
        [self initPublishBeacon];
    } else {
        [self.peripheralManager stopAdvertising];
    }
    
}


- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    if (peripheral.state < CBPeripheralManagerStatePoweredOn) {
        self.labelStatus.text = @"blue tooth powered off";
    }
    else {
        self.labelStatus.text = @"blue tooth powered on";
    }
}

- (void)initPublishBeacon {
    NSUUID *proximityUUID = [[NSUUID alloc]
                             initWithUUIDString:kBeaconStationUUID];
    
    CLBeaconMajorValue major = 16;
    CLBeaconMinorValue minor = 256;
    
    // Create the beacon region.
    self.beaconRegion = [[CLBeaconRegion alloc]initWithProximityUUID:proximityUUID
                                                               major:major
                                                               minor:minor
                                                          identifier:kID];
    // Create a dictionary of advertisement data.
    NSDictionary *beaconPeripheralData =
    [self.beaconRegion peripheralDataWithMeasuredPower:kPower];
    

    
    // Start advertising your beacon's data.
    [self.peripheralManager startAdvertising:beaconPeripheralData];
    
    
    self.labelUUID.text = kBeaconStationUUID;
    
    NSString *beaconPublished = [[NSString alloc]initWithFormat:@"Major:%d Minor:%d beacon published", major, minor];
    
    self.labelStatus.text = beaconPublished;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
