//
//  TimeTableTableViewController.m
//  brisbane.transit
//
//  Created by Bo Wang on 17/10/2014.
//  Copyright (c) 2014 Bo Software. All rights reserved.
//

#import "TimeTableTableViewController.h"
#import "GtfsUtility.h"
#import "StopTimeTableItem.h"
#import "StopTimeTableViewCell.h"
#import "TimeTableDetailsTableViewController.h"
#import "SavedTrips.h"
#import "FavoritesTableViewController.h"
#import "prefix.h"
#import "GtfsUtility.h"
#import "Helper.h"
#import "RealTimeUtil.h"
#import "RealTimeInfo.h"
#import "TripDetailsViewController.h"

@interface TimeTableTableViewController ()
{
    NSString * dayStr;
    Helper *helper;
    
    NSDateFormatter *timeFormat;
    NSTimer * timer;
}


@end

@implementation TimeTableTableViewController

- (IBAction)changeSeg:(id)sender {
    [_myIndicator startAnimating];
    
    if(_mySegment.selectedSegmentIndex == 1){
        dayStr = @"monday";
    }else if (_mySegment.selectedSegmentIndex==2){
        dayStr = @"tuesday";
    }else if(_mySegment.selectedSegmentIndex==3){
        dayStr = @"wednesday";
    }else if(_mySegment.selectedSegmentIndex==4){
        dayStr = @"thursday";
    }else if (_mySegment.selectedSegmentIndex==5){
        dayStr= @"friday";
    }else if (_mySegment.selectedSegmentIndex==6){
        dayStr=@"saturday";
    }else if(_mySegment.selectedSegmentIndex==0){
        dayStr=@"sunday";
    }
    [GtfsUtility getTimeTable:_route.route_id indicator:_myIndicator controller:self stopFrom:_stopsFrom stopTo:_stopsTo dayStr:dayStr routeType:_routeType];
    //[self.tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    _adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    if (_stopsFrom.stop_name==nil){
        self.navigationItem.rightBarButtonItem =nil;
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    int weekday = [comps weekday];
    _mySegment.selectedSegmentIndex=(weekday-1);
    if(_mySegment.selectedSegmentIndex == 1){
        dayStr = @"monday";
    }else if (_mySegment.selectedSegmentIndex==2){
        dayStr = @"tuesday";
    }else if(_mySegment.selectedSegmentIndex==3){
        dayStr = @"wednesday";
    }else if(_mySegment.selectedSegmentIndex==4){
        dayStr = @"thursday";
    }else if (_mySegment.selectedSegmentIndex==5){
        dayStr= @"friday";
    }else if (_mySegment.selectedSegmentIndex==6){
        dayStr=@"saturday";
    }else if(_mySegment.selectedSegmentIndex==0){
        dayStr=@"sunday";
    }
    [_myIndicator startAnimating];
    timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HHmmss"];
    [GtfsUtility getTimeTable:_route.route_id indicator:_myIndicator controller:self stopFrom:_stopsFrom stopTo:_stopsTo dayStr:dayStr routeType:_routeType];
}

-(void)refresh:(NSTimer *)timer{
    [RealTimeUtil getRealTimeArray:_stopsFrom.stop_id controller:self];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    timer = [NSTimer scheduledTimerWithTimeInterval: 30.0
                                             target: self
                                           selector:@selector(refresh:)
                                           userInfo: nil repeats:YES];
    [self refresh:timer];
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
    
    int count = _stopTimes.count;
    if (![Helper isBought]){
        count = count+1;
        
    }
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==_stopTimes.count){
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
        
        
        StopTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timeTable" forIndexPath:indexPath];
        StopTimeTableItem * item = [_stopTimes objectAtIndex:indexPath.row];
        cell.stopFromName.text = item.stopFrom1Name;
        
        cell.stopFromTime.text = [GtfsUtility getTimeString:item.stopFrom1Time];
        
        cell.stopToName.text = item.stopTo1Name;
        
        cell.stopToTime.text = [GtfsUtility getTimeString:item.stopTo1Time];
        
        cell.headSign.text = [NSString stringWithFormat:@"To %@",item.tripHeadSign];
        
        if (item.delay!=nil&&item.delay.length>0){
            long delayin = item.delay.longLongValue;
            long delaym = delayin/60;
            if (delaym<0){
                cell.delay.text = [NSString stringWithFormat:@"%ld m early",abs(delaym)];
                cell.delay.textColor = [UIColor blueColor];
            }else if (delaym==0){
                cell.delay.text = @"On time";
                cell.delay.textColor = [UIColor darkGrayColor];
            }
            else{
                cell.delay.text = [NSString stringWithFormat:@"%ld m late",abs(delaym)];
                cell.delay.textColor = [UIColor redColor];
            }
        }else{
            cell.delay.text = @"Scheduled";
            cell.delay.textColor = [UIColor darkGrayColor];
        }
        cell.routeName.text=item.stopRouteName;
        /*
         NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
         [dateFormatter setDateFormat:@"HH"];
         int hour = [[dateFormatter stringFromDate:[NSDate date]] intValue];
         [dateFormatter setDateFormat:@"mm"];
         int minute = [[dateFormatter stringFromDate:[NSDate date]] intValue];
         
         NSString * hourStr = [item.stopFrom1Time substringWithRange:NSMakeRange(0, 2)];
         int hourdiff = [hourStr integerValue];
         hourdiff -= hour;
         hourdiff *= 60;
         NSString *minStr = [item.stopFrom1Time substringWithRange:NSMakeRange(2, 2)];
         int mindiff = [minStr integerValue];
         mindiff -= minute;
         hourdiff += mindiff;
         
         if (hourdiff<30&&hourdiff>0){
         cell.timeLeft.text = [NSString stringWithFormat:@"%d mintues",hourdiff];
         }else{
         cell.timeLeft.text=@"";
         }
         */
        cell.timeLeft.text = item.arriveTime;
        // Configure the cell...
        
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
    if ([segue.identifier isEqualToString:@"tripDetails"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        StopTimeTableItem * item = [_stopTimes objectAtIndex:indexPath.row];
        TripDetailsViewController * controller = [segue destinationViewController];
        controller.tripId = item.tripId;
        controller.routeName = item.stopRouteName;
        
    }else if([segue.identifier isEqualToString:@"backToRoot"]){
        SavedTrips * savedTrip = [[SavedTrips alloc]init];
        savedTrip.stop_from = _stopsFrom.stop_id;
        savedTrip.stop_from_name = _stopsFrom.stop_name;
        savedTrip.stop_to = _stopsTo.stop_id;
        savedTrip.stop_to_name = _stopsTo.stop_name;
        savedTrip.route_id = _routeType;
        savedTrip.route_name = _route.route_short_name;
        [SavedTrips saveTrip:savedTrip];
    }
}

-(void) setResponseArray:(id)responseArray{
    _stopTimes = [[NSMutableArray alloc]init];
    
    [_myIndicator stopAnimating];
    if (((NSArray*)responseArray).count==0){
        //ShowAlerViewWithMessage(@"Sorry,No service avaliable");
        [GtfsUtility ToastNotification:@"Sorry,No service avaliable now, Please try it later" andView:self.view andLoading:NO andIsBottom:NO ];
    }
    NSMutableArray * array = [[NSMutableArray alloc]init];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    for (StopTimeTableItem *item in (NSArray*)responseArray){
        if ([item.stopFrom1Time intValue]>[item.stopTo1Time intValue]){
            continue;
        }
        if (item.keysArray==nil){
            item.keysArray = [[NSMutableArray alloc]init];
        }
        NSString * key = [NSString stringWithFormat:@"%@|%@",item.stopRouteName,item.stopFrom1Time];
        if (![array containsObject:key]){
            [array addObject:key];
            NSLog(key);
            [dic setValue:item forKey:key];
            [item.keysArray addObject:item.tripId];
            [_stopTimes addObject:item];
        }else{
            StopTimeTableItem * olditem = [dic objectForKey:key];
            [olditem.keysArray addObject:item.tripId];
        }
        
    }
    [self.tableView reloadData];
    if (_stopTimes.count==0){
        //ShowAlerViewWithMessage(@"Sorry,No service avaliable");
        [GtfsUtility ToastNotification:@"Sorry,No service avaliable now, Please try it later" andView:self.view andLoading:NO andIsBottom:NO ];
        return;
    }
    
    for (StopTimeTableItem *item in _stopTimes){
        @try {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH"];
            int hour = [[dateFormatter stringFromDate:[NSDate date]] intValue];
            [dateFormatter setDateFormat:@"mm"];
            int minute = [[dateFormatter stringFromDate:[NSDate date]] intValue];
            NSString * hourStr = [item.stopFrom1Time substringWithRange:NSMakeRange(0, 2)];
            int hourdiff = [hourStr integerValue];
            hourdiff -= hour;
            hourdiff *= 60;
            NSString *minStr = [item.stopFrom1Time substringWithRange:NSMakeRange(2, 2)];
            int mindiff = [minStr integerValue];
            mindiff -= minute;
            hourdiff += mindiff;
            if (hourdiff>=0){
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[_stopTimes indexOfObject:item] inSection:0];
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                break;
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    }
}
- (IBAction)saveTrip:(id)sender {
    //    SavedTrips * savedTrip = [[SavedTrips alloc]init];
    //    savedTrip.stop_from = _stopsFrom.stop_id;
    //    savedTrip.stop_from_name = _stopsFrom.stop_name;
    //    savedTrip.stop_to = _stopsTo.stop_id;
    //    savedTrip.stop_to_name = _stopsTo.stop_name;
    //    savedTrip.route_id = _route.route_id;
    //    savedTrip.route_name = _route.route_short_name;
    //    [SavedTrips saveTrip:savedTrip];
    //    FavoritesTableViewController * controller = [[FavoritesTableViewController alloc]init];
    //    [self.navigationController pushViewController:controller animated:YES];
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}


-(void) setRealTimeInfoArray:(id)newArray{
    
    
    
    
    long currentTime = [[NSDate date] timeIntervalSince1970];
    
    
    for (StopTimeTableItem * item in _stopTimes){
        
        
        NSDate * date = [self getDateTime:item.stopFrom1Time];
        
        
        long m = ([date timeIntervalSince1970]- currentTime)/60;
        
        if (m<0){
            continue;
        }
        if (m<30){
            item.arriveTime=[NSString stringWithFormat:@"%ld min",m];
        }else{
            item.arriveTime = [GtfsUtility getTimeString:item.stopFrom1Time];
        }
        for (RealTimeInfo * r in newArray){
            NSString * tripId = r.tripId;
            if ([item.keysArray containsObject:r.tripId] && ![r.departureTime isEqualToString:@""]){
                item.delay = r.delay;
                item.tripId=r.tripId;
                m = (r.departureTime.longLongValue-currentTime)/60;
                if (m<0){
                    continue;
                }
                if (m<30){
                    item.arriveTime=[NSString stringWithFormat:@"%ld min",m];
                }
                //realtimeInfo.departureTime = [NSString stringWithFormat:@"%lld", (r.departureTime.longLongValue-currentTime)/60];
            }
        }
    }
    
    [self.myIndicator stopAnimating];
    
    [self.tableView reloadData];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [timer invalidate];
    //timer = nil;
}

-(NSDate *) getDateTime:(NSString*)time{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    NSString * hourStr = [time substringWithRange:NSMakeRange(0, 2)];
    NSString *minStr = [time substringWithRange:NSMakeRange(2, 2)];
    int hour = hourStr.integerValue;
    if (hour>24){
        hour =hour-24;
        [components setDay:components.day+1];
    }
    //[components setDay:components.day];
    [components setHour:hour];
    [components setMinute:minStr.integerValue];
    return [calendar dateFromComponents:components];
}
@end
