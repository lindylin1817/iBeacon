//
//  beaconDistanceTableViewController.m
//  iBeacon
//
//  Created by Yonghua Lin on 7/7/14.
//  Copyright (c) 2014 dastone. All rights reserved.
//

#import "beaconDistanceTableViewController.h"
#import "beaconManager.h"
#import "beaconLocalArchive.h"

@interface beaconDistanceTableViewController ()

@property (strong, nonatomic)beaconManager  *beaconManager;
@property (strong, nonatomic)NSArray        *beaconList;
@property (strong, nonatomic)NSMutableArray        *beaconInfoList;

@end

@implementation beaconDistanceTableViewController

@synthesize beaconManager = _beaconManager;
@synthesize beaconList = _beaconList;
@synthesize beaconInfoList = _beaconInfoList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.beaconManager = [[beaconManager alloc] init];
    [self.beaconManager startMonitoringRegion];
    
    self.beaconInfoList = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter]addObserverForName:@"beacons" object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        _beaconList = self.beaconManager.beaconsInRegion;
        UITableView *tableView = (UITableView *)self.view;
        [tableView reloadData];
        
    }];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [self.beaconList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"beaconDistanceCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSInteger row = indexPath.row;
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }

    if ([self.beaconList count] == 0) {
        if (row == 0) {
            cell.textLabel.text = @"search beacons...";
            cell.detailTextLabel.text = nil;
            return cell;
        }
    } else {
        
        if (row < [self.beaconList count]) {
            
            
            CLBeacon *beacon = [self.beaconList objectAtIndex:row];
            
            if (beacon) {
                NSLog(@"%ld: beacon is %@, %d, %d", (long)row, beacon.proximityUUID.UUIDString, beacon.major, beacon.minor);
                
                //To build the beaconID
                NSMutableString *hexString_major_32 = [NSMutableString stringWithCapacity:4];
                
                
                NSString *hexString_major = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%X",(unsigned int)beacon.major]];
                
                for (int i = 0; i < 4 - [hexString_major length]; i++) {
                    [hexString_major_32 appendString:@"0"];
                }
                
                [hexString_major_32 appendString:hexString_major];
                
                NSMutableString *hexString_minor_32 = [NSMutableString stringWithCapacity:4];
                
                NSString *hexString_minor = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%X",(unsigned int)beacon.minor]];
                
                for (int i = 0; i < 4 - [hexString_minor length]; i++) {
                    [hexString_minor_32 appendString:@"0"];
                }
                
                [hexString_minor_32 appendString:hexString_minor];
                
                NSString *beaconID = [[beacon.proximityUUID.UUIDString stringByAppendingString:hexString_major] stringByAppendingString:hexString_minor];
                
                //To show the detected beaconID
                cell.textLabel.text = beaconID;

                //To check if beacon has been calibrated via checking the local archive document
                NSError *error;
                
                beaconInfoData *beacon_info = [beaconLocalArchive beaconInfoQuery:beaconID error:error];
                
                if (!beacon_info){
                
                    NSLog(@"Query local document for beacon has error: %@", [error localizedDescription]);
                    cell.detailTextLabel.text = @"Not calibrated";
                } else {
                    
                }

            } else {
                return cell;
            }
        }
        
        else {
            return cell;
        }
    }
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
