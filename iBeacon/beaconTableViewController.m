//
//  beaconTableViewController.m
//  iBeacon
//
//  Created by ShaoLing on 13/6/14.
//  Copyright (c) 2014 dastone. All rights reserved.
//

#import "beaconTableViewController.h"
#import "beaconManager.h"
#import "beaconReader.h";

@interface beaconTableViewController ()

@property (strong, nonatomic)NSArray        *beaconInfo;
@property (strong, nonatomic)beaconManager  *beaconManager;

@end

@implementation beaconTableViewController

@synthesize beaconManager = _beaconManager;
@synthesize beaconInfo = _beaconInfo;

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.beaconManager = [[beaconManager alloc] init];
    [self.beaconManager startMonitoringRegion];

    [[NSNotificationCenter defaultCenter]addObserverForName:@"beacons" object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        _beaconInfo = self.beaconManager.beaconsInRegion;
        UITableView *tableView = (UITableView *)self.view;
        [tableView reloadData];

    }];
    
    
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
    /*self.beaconInfo = [self.beaconManager getBeaconsInfo];
    
    return [self.beaconInfo count];*/
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.beaconInfo count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"beaconFoundCell"forIndexPath:indexPath];
    
    // Configure the cell...
    
    NSInteger row = indexPath.row;
    
    if ([self.beaconInfo count] == 0) {
        if (row == 0) {
            cell.textLabel.text = @"search beacons...";
            cell.detailTextLabel.text = nil;
            return cell;
        }
    } else {
        
        if (row < [self.beaconInfo count]) {
        
            CLBeacon *beacon = [self.beaconInfo objectAtIndex:row];
        
            if (beacon) {
                NSString *details = [[NSString alloc] initWithFormat:@"major:%@, minor:%@", beacon.major, beacon.minor];
            
                cell.textLabel.text = beacon.proximityUUID.UUIDString;
                cell.detailTextLabel.text = details;
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


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        if (indexPath){
            if ([segue.identifier isEqualToString:@"beacon details"]) {
                if ([segue.destinationViewController isKindOfClass:[beaconReader class]]) {
                    
                    CLBeacon *beacon = [[self.beaconManager beaconsInRegion]objectAtIndex:indexPath.row];
                    [segue.destinationViewController setBeaconDetails:beacon];
                }
            }
        }
    }
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
