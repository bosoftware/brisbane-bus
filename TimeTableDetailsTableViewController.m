//
//  TimeTableDetailsTableViewController.m
//  brisbane.transit
//
//  Created by Bo Wang on 18/10/2014.
//  Copyright (c) 2014 Bo Software. All rights reserved.
//

#import "TimeTableDetailsTableViewController.h"
#import "GtfsUtility.h"
#import "StopTimeTableDetailsItem.h"
#import "StopPointMapViewController.h"
#import "Helper.h"

@interface TimeTableDetailsTableViewController (){
    Helper *helper;
}

@end

@implementation TimeTableDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    _adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    [GtfsUtility getTripDetails:_tripId indicator:_myIndicator controller:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    int count = _stopDetails.count;
    if (![Helper isBought]){
        count = count+1;
        
    }
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==_stopDetails.count){
        UITableViewCell *tempcell;
        NSString *identifier = @"AdTableItem";
        tempcell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (tempcell == nil) {
            tempcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        } else {
            [[tempcell.contentView subviews] //clear the cell view
             makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
        
        [tempcell.contentView addSubview:self.adView];
        return tempcell;
        
    }else{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tripDetails" forIndexPath:indexPath];
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor orangeColor];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        // Configure the cell...
        StopTimeTableDetailsItem * item = [_stopDetails objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",item.stopName,[GtfsUtility getTimeString:item.arrive_time]];
        return cell;
    }
    
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if ([segue.identifier isEqualToString:@"stopLocationOnMap"]){
        StopTimeTableDetailsItem * item = [_stopDetails objectAtIndex:indexPath.row];
        StopPointMapViewController * controller = [segue destinationViewController];
        controller.stopItem = item;
        controller.stopDetails = _stopDetails;
    }
}

-(void) setResponseArray:(id)responseArray{
    _stopDetails = responseArray;
    [self.tableView reloadData];
    [_myIndicator stopAnimating];
}

@end
