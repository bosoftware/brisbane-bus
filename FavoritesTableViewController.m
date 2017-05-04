//
//  FavoritesTableViewController.m
//  brisbane.transit
//
//  Created by Bo Wang on 12/10/2014.
//  Copyright (c) 2014 Bo Software. All rights reserved.
//

#import "FavoritesTableViewController.h"
//#import <iAd/iAd.h>
#import "SavedTrips.h"
#import "TimeTableTableViewController.h"
#import "Helper.h"

@interface FavoritesTableViewController (){
    Helper *helper;
}

@end

@implementation FavoritesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //    ADBannerView *adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    //    adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    //    [self.view addSubview:adView];
    _adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    _adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _savedTripArray = [SavedTrips getSavedTrips];
    [self.tableView reloadData];
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
    int count = _savedTripArray.count;
    if (![Helper isBought]){
        count = count+1;
        
    }
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==_savedTripArray.count){
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
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"savedTrip"];
        if ( cell == nil ) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"savedTrip"];
        }
        SavedTrips * trip = [_savedTripArray objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor blueColor];
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.text = [NSString stringWithFormat:@"%@ -- %@",trip.stop_from_name,trip.stop_to_name];
        
        return cell;
    }
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        SavedTrips * trip = [_savedTripArray objectAtIndex:indexPath.row];
        [SavedTrips deleteTrip:trip];
        _savedTripArray = [SavedTrips getSavedTrips];
        [self.tableView reloadData];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


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
    if ([segue.identifier isEqualToString:@"showTimeTable"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        SavedTrips * item = [_savedTripArray objectAtIndex:indexPath.row];
        TimeTableTableViewController * controller = [segue destinationViewController];
        Stops * from = [[Stops alloc]init];
        from.stop_id = item.stop_from;
        Stops * to = [[Stops alloc]init];
        to.stop_id=item.stop_to;
        controller.stopsFrom=from;
        controller.stopsTo=to;
        controller.routeType=item.route_id;
        
    }
}




@end
