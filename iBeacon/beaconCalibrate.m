//
//  beaconCalibrate.m
//  iBeacon
//
//  Created by Yonghua Lin on 28/6/14.
//  Copyright (c) 2014 dastone. All rights reserved.
//

#import "beaconCalibrate.h"
#import "beaconReader.h"
#import "beaconDBAction.h"
#import "beaconLocalArchive.h"

@interface beaconCalibrate ()

@end

@implementation beaconCalibrate

@synthesize beaconRegion = _beaconRegion;
@synthesize locationManager = _locationManager;

long rssi_sum;
unsigned int measure_count, measure_success_count;
const unsigned int max_measure_times = 30;
const unsigned int max_measure_success_times = 10;
unsigned int distance_count;
const unsigned int max_distance_times = 5;

NSArray *distance_array;
NSArray *rssi_array;
NSArray *flag_array;

UILabel *current_distance_label;
UILabel *current_rssi_label;
UILabel *current_flag_label;

bool isInitScan;
bool isCalibrating;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"1");
    // Do any additional setup after loading the view.
    
    self->beaconInfo = [[beaconInfoData alloc] init];
    
    distance_array = [NSArray arrayWithObjects:self.distanceLable1,
                      self.distanceLable2, self.distanceLable3,
                      self.distanceLable4, self.distanceLable5,
                      nil];
    rssi_array = [NSArray arrayWithObjects:self.rssiLable1,
                  self.rssiLable2, self.rssiLable3,
                  self.rssiLable4, self.rssiLable5,
                  nil];
    flag_array = [NSArray arrayWithObjects:self.flagLabel1,
                  self.flagLabel2, self.flagLabel3,
                  self.flagLabel4, self.flagLabel5,
                  nil];
    NSLog(@"11");
    int i = 0;
    UILabel *temp_label;
    distance_count = 0;
 
    for (i = 0; i<max_distance_times; i++){
        temp_label = [distance_array objectAtIndex:i];
        temp_label.text = @"0";
        temp_label = [rssi_array objectAtIndex:i];
        temp_label.text = @"0";
        temp_label = [flag_array objectAtIndex:i];
        temp_label.text = nil;
    }
    
    temp_label = [distance_array objectAtIndex:0];
    temp_label.text = @"0";
    
    
    current_distance_label = [distance_array objectAtIndex:0];
    self.finishButton.hidden = NO;
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    self.startButton.enabled = NO;
    self.uuidLabel.text = nil;
    
    NSLog(@"aa");
    
    
    self.locationManager = [[CLLocationManager alloc] init];
    NSLog(@"aa1");

    self.locationManager.delegate = self;
    NSLog(@"aa2");

    //To do the initScan
    isInitScan = true;
    isCalibrating = false;
    
    [self initRegion];
    [self locationManager:self.locationManager didStartMonitoringForRegion:self.beaconRegion];
    
    
    self.startButton.enabled = NO;
    
    
    [self.distanceSlider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
    
   
    NSLog(@"UUID is %@", self.uuidLabel.text);
    
}

- (IBAction)CalibrationFinish:(UIButton *)sender {
    
   
    UILabel *distance_label, *rssi_label;
    
    for (unsigned int i = 0; i < max_distance_times; i++) {
        NSLog(@"i = %d ", i);

        distance_label = [distance_array objectAtIndex:i];
        rssi_label = [rssi_array objectAtIndex:i];
        [self->beaconInfo.beaconMetrics addObject: [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:distance_label.text, rssi_label.text, nil]forKeys: [NSArray arrayWithObjects:@"distance", @"rssi", nil]]];
    }
    NSLog(@"%@", self->beaconInfo.beaconMetrics);
    
    
    NSData *beacon_info_json = [beaconDBAction buildJSONBeaconDB:self->beaconInfo];
    NSError *error = [beaconDBAction addBeaconwithCalibrateInfo:beacon_info_json];
    
    UIAlertView *alert = [UIAlertView alloc];
    if (error){
        NSLog(@"Upload data failed: %@", [error localizedDescription]);
        [alert initWithTitle:@"Data upload failed" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    } else {
        [alert initWithTitle:@"Data upload success!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    }
    [alert show];
    
    [beaconLocalArchive beaconInfoSave:beaconInfo error:error];
    
    if (error){
        [alert initWithTitle:@"Save to local failed" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    } else {
        [alert initWithTitle:@"Save to local success!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    }
    [alert show];
    
    
    //To remove all objects in the beaconMetrics after the "finish"
    [self->beaconInfo.beaconMetrics removeAllObjects];
    
    return;
}

- (IBAction)CalibrationStart:(UIButton *)sender {
    NSLog(@"Start button");
    
    
    
    rssi_sum = 0;
    measure_count = 0;
    measure_success_count = 0;

    current_rssi_label = [rssi_array objectAtIndex:distance_count];
    current_flag_label = [flag_array objectAtIndex:distance_count];
        
    self.startButton.enabled = NO;
    self.finishButton.enabled = NO;
    
    isCalibrating = true;
    
    [self initRegion];
    [self locationManager:self.locationManager didStartMonitoringForRegion:self.beaconRegion];

    
    [self.activityIndicator startAnimating];
}


- (void)initRegion {
    NSLog(@"In initRegion of Calibration");
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"];
    //self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:nil identifier:nil];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"Apple AirLocate E2C56DB5"];
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    
    //NSLog(@"init region");
    
}

- (void)sliderValueChanged{
    NSLog(@"sliderValueChanged");
    
    current_distance_label.text = [[NSString alloc]initWithFormat:@"%.0f", self.distanceSlider.value];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    NSLog(@"In locationManager didStartMonitoringForRegion");
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"did enter region");
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    CLBeacon *beacon = [[CLBeacon alloc] init];
    beacon = [beacons lastObject];
    
    NSLog(@"in LocationManager didRangeBeacons");

    self.uuidLabel.text = beacon.proximityUUID.UUIDString;
  //  NSLog(@"%@", self.uuidLabel.text);
    if (isInitScan && self.uuidLabel.text) {
        
        NSLog(@"found the beacon : ", self.uuidLabel.text);
        self->beaconInfo.uuid = beacon.proximityUUID.UUIDString;
        
        NSMutableString *hexString_major_32 = [NSMutableString stringWithCapacity:4];
       
        
        NSString *hexString_major = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%X",(unsigned int)beacon.major]];
        
        for (int i = 0; i < 4 - [hexString_major length]; i++) {
            [hexString_major_32 appendString:@"0"];
        }
        
        [hexString_major_32 appendString:hexString_major];
        self->beaconInfo.major = hexString_major_32;
        
        NSLog(@"%@", hexString_major_32);
        
        NSMutableString *hexString_minor_32 = [NSMutableString stringWithCapacity:4];
        
        NSString *hexString_minor = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%X",(unsigned int)beacon.minor]];
        
        for (int i = 0; i < 4 - [hexString_minor length]; i++) {
            [hexString_minor_32 appendString:@"0"];
        }
        
        [hexString_minor_32 appendString:hexString_minor];
        self->beaconInfo.minor = hexString_minor_32;
        NSLog(@"%@", hexString_minor_32);
        
        self->beaconInfo.beaconID = [[self->beaconInfo.uuid stringByAppendingString:self->beaconInfo.major] stringByAppendingString:self->beaconInfo.minor];

//to speed up the debug
/*        NSLog(@"to send link");
         if ([beaconDBAction checkCalibrated : self->beaconInfo]){
         self.checkCalibrateLabel.text = @"This beacon has been calibrated";
         } else {
         self.checkCalibrateLabel.text = @"This beacon hasn't been calibrated";
         } */
        
        isInitScan = false;
        self.startButton.enabled = YES; //Finish initial scan, wait for calibration start
        [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    } else if (!isInitScan) {
         current_rssi_label.text = [NSString stringWithFormat:@"%i", beacon.rssi];
    }
   
    
    if ((!isInitScan) && (isCalibrating)){
        measure_count++;
    }
    
    if (beacon.rssi<0){
        measure_success_count++;
        rssi_sum = rssi_sum + beacon.rssi;
    }
    
    if ((measure_success_count == max_measure_success_times) || (measure_count == max_measure_times)){
        current_rssi_label.textColor = [UIColor yellowColor];
        current_distance_label.textColor = [UIColor yellowColor];
        current_flag_label.text = @"⚑";
        
        isCalibrating = false;
         
        if (measure_count == max_measure_times){  //Failed with long distance
            rssi_sum = 0;
            current_flag_label.textColor = [UIColor redColor];
        } else {
            current_flag_label.textColor = [UIColor greenColor];
        }
        
        current_rssi_label.text = [NSString stringWithFormat:@"%i", rssi_sum/max_measure_success_times];



        
        [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
        distance_count++;
        
        if (distance_count == max_distance_times){
            self.startButton.enabled = NO;
        } else {
            self.startButton.enabled = YES;
            current_distance_label = [distance_array objectAtIndex:distance_count];
        }
        [self.activityIndicator stopAnimating];
        self.finishButton.enabled = YES;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
