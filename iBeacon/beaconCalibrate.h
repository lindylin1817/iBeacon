//
//  beaconCalibrate.h
//  iBeacon
//
//  Created by Yonghua Lin on 28/6/14.
//  Copyright (c) 2014 dastone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface beaconCalibrate : UIViewController <CLLocationManagerDelegate>

- (void)initRegion;

@property (nonatomic, retain) IBOutlet UILabel *uuidLabel;
@property (nonatomic, retain) IBOutlet UILabel *distanceLable1;
@property (nonatomic, retain) IBOutlet UILabel *rssiLable1;
@property (nonatomic, retain) IBOutlet UILabel *distanceLable2;
@property (nonatomic, retain) IBOutlet UILabel *rssiLable2;
@property (nonatomic, retain) IBOutlet UILabel *distanceLable3;
@property (nonatomic, retain) IBOutlet UILabel *rssiLable3;
@property (nonatomic, retain) IBOutlet UILabel *distanceLable4;
@property (nonatomic, retain) IBOutlet UILabel *rssiLable4;
@property (nonatomic, retain) IBOutlet UILabel *distanceLable5;
@property (nonatomic, retain) IBOutlet UILabel *rssiLable5;

@property (nonatomic, retain) IBOutlet UILabel *flagLabel1;
@property (nonatomic, retain) IBOutlet UILabel *flagLabel2;
@property (nonatomic, retain) IBOutlet UILabel *flagLabel3;
@property (nonatomic, retain) IBOutlet UILabel *flagLabel4;
@property (nonatomic, retain) IBOutlet UILabel *flagLabel5;

@property (nonatomic, retain) IBOutlet UIButton *startButton;
@property (nonatomic, retain) IBOutlet UIButton *finishButton;

@property (nonatomic, retain) IBOutlet UISlider *distanceSlider;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end
