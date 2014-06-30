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

#define kBeaconStationUUID @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self initPublishBeacon];
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
    
    // Create the beacon region.
    self.beaconRegion = [[CLBeaconRegion alloc]
                                    initWithProximityUUID:proximityUUID
                                    identifier:@"com.mycompany.myregion"];
    // Create a dictionary of advertisement data.
    NSDictionary *beaconPeripheralData =
    [self.beaconRegion peripheralDataWithMeasuredPower:nil];
    
    // Create the peripheral manager.
    self.peripheralManager = [[CBPeripheralManager alloc]
                                              initWithDelegate:self queue:nil options:nil];
    
    // Start advertising your beacon's data.
    [self.peripheralManager startAdvertising:beaconPeripheralData];
    
    self.labelUUID.text = kBeaconStationUUID;
    self.labelStatus.text = @"beacon published";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
