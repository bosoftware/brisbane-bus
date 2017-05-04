//
//  RealTimeTableViewController.m
//  SydneyTransit
//
//  Created by Bo Wang on 20/06/2015.
//  Copyright (c) 2015 Bo Software. All rights reserved.
//

#import "RealTimeTableViewController.h"
#import "StopTimeTableItem.h"
#import "RealTimeInfo.h"
#import "RealTimeTableViewCell.h"
#import "RealTimeUtil.h"
#import "Stops.h"
#import "TimeTableDetailsTableViewController.h"
#import "Helper.h"
#import "PurchasedViewController.h"
#import "RealTimeUtil.h"
#import "TripDetailsViewController.h"

@interface RealTimeTableViewController (){
    NSDateFormatter *timeFormat;
    NSTimer * timer;
}

@end

@implementation RealTimeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _stop.stop_name;
    timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HHmmss"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = self.stop.stop_name;
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [GtfsUtility getTimeTable:_stop.stop_id indicator:self.myIndicator controller:self];
    
    timer = [NSTimer scheduledTimerWithTimeInterval: 30.0
                                             target: self
                                           selector:@selector(refresh:)
                                           userInfo: nil repeats:YES];
    [self refresh:timer];
}

-(void)refresh:(NSTimer *)timer{
    
    [RealTimeUtil getRealTimeArray:_stop.stop_id controller:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [timer invalidate];
    //timer = nil;
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
    return self.realTimeInfoArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    RealTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"realTimeTableCell"];
    
    if (cell==nil) {
        cell = [[RealTimeTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"realTimeTableCell"];
        
    }
    RealTimeInfo * realtimeInfo = [self.realTimeInfoArray objectAtIndex:indexPath.row];
    cell.routeName.text = realtimeInfo.routeName;
    cell.time.text = realtimeInfo.departureTime;
    cell.details.text=[NSString stringWithFormat:@"To %@",realtimeInfo.tripName];
    if (realtimeInfo.delay!=nil&&realtimeInfo.delay.length>0){
        long delayin = realtimeInfo.delay.longLongValue;
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
    
    //cell.delay.text = realtimeInfo.delay;
    return cell;
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
    if ([segue.identifier isEqual:@"showTimetable"]){
        TripDetailsViewController * controller = [segue destinationViewController];
        RealTimeInfo * info = [_realTimeInfoArray objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        controller.tripId=info.tripId;
        controller.routeName = info.routeName;
        
    }
}
-(void) setRealTimeInfoArray:(id)newArray{
    _realTimeInfoArray = [[NSMutableArray alloc]init];
    
   
    
    long currentTime = [[NSDate date] timeIntervalSince1970];
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    
    for (StopTimeTableItem * item in self.timetableResponseArray){
        
        RealTimeInfo * realtimeInfo = [[RealTimeInfo alloc]init];
        realtimeInfo.routeName = item.stopRouteName;
        realtimeInfo.tripId = item.tripId;
        realtimeInfo.stopName=item.stopFrom1Name;
        realtimeInfo.tripName = item.tripName;
        
        NSDate * date = [self getDateTime:item.stopFrom1Time];
        
        
        long m = ([date timeIntervalSince1970]- currentTime)/60;
        realtimeInfo.oriDeTime = [NSString stringWithFormat:@"%ld",m];
        if (m<0){
            continue;
        }
        if (m<30){
            realtimeInfo.departureTime=[NSString stringWithFormat:@"%ld min",m];
        }else{
            realtimeInfo.departureTime = [GtfsUtility getTimeString:item.stopFrom1Time];
        }
        for (RealTimeInfo * r in newArray){
            
            
            if ([item.keysArray containsObject:r.tripId] && ![r.departureTime isEqualToString:@""]){
                realtimeInfo.delay = r.delay;
                realtimeInfo.tripId=r.tripId;
                m = (r.departureTime.longLongValue-currentTime)/60;
                
                if (m<30){
                    realtimeInfo.oriDeTime = [NSString stringWithFormat:@"%ld",m];
                    realtimeInfo.departureTime=[NSString stringWithFormat:@"%ld min",m];
                }else{
                    NSLog(r.departureTime);
                }
                //realtimeInfo.departureTime = [NSString stringWithFormat:@"%lld", (r.departureTime.longLongValue-currentTime)/60];
            }
        }
       
        [_realTimeInfoArray addObject:realtimeInfo];
       
        
    }
     _realTimeInfoArray = [_realTimeInfoArray sortedArrayUsingSelector:@selector(compare:)];
    [self.myIndicator stopAnimating];
    
    [self.tableView reloadData];
    
}
-(void) setResponseArray:(id)responseArray{
    _timetableResponseArray = [[NSMutableArray alloc]init];
    //[RealTimeUtil getRealTimeArray:_stop.stop_id controller:self];
    
    _realTimeInfoArray = [[NSMutableArray alloc]init];
    NSMutableArray * array = [[NSMutableArray alloc]init];
    
    NSDate * currentDate = [NSDate date];
    long currentTime = [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    
    for (StopTimeTableItem * item in responseArray){
        if (item.keysArray==nil){
            item.keysArray = [[NSMutableArray alloc]init];
        }
        NSString * key = [NSString stringWithFormat:@"%@|%@",item.stopRouteName,item.stopFrom1Time];
        if (![array containsObject:key]){
            [array addObject:key];
            NSLog(key);
            [dic setValue:item forKey:key];
            RealTimeInfo * realtimeInfo = [[RealTimeInfo alloc]init];
            realtimeInfo.routeName = item.stopRouteName;
            realtimeInfo.tripId = item.tripId;
            realtimeInfo.stopName=item.stopFrom1Name;
            realtimeInfo.tripName = item.tripName;
            [item.keysArray addObject:item.tripId];
            NSDate * date = [self getDateTime:item.stopFrom1Time];
            
            long a =[date timeIntervalSince1970];
            long m = (a - currentTime)/60;
            realtimeInfo.oriDeTime = [NSString stringWithFormat:@"%ld",m];
            if (m<0){
                continue;
            }
            if (m<30){
                realtimeInfo.departureTime=[NSString stringWithFormat:@"%ld min",m];
            }else{
                realtimeInfo.departureTime = [GtfsUtility getTimeString:item.stopFrom1Time];
            }
            [_timetableResponseArray addObject:item];
            [_realTimeInfoArray addObject:realtimeInfo];
        }else{
            StopTimeTableItem * olditem = [dic objectForKey:key];
            [olditem.keysArray addObject:item.tripId];
        }
        
    }
    if (_realTimeInfoArray.count==0){
        //ShowAlerViewWithMessage(@"Sorry,No service avaliable");
        [GtfsUtility ToastNotification:@"Sorry,No service avaliable now, Please try it later" andView:self.view andLoading:NO andIsBottom:NO ];
        return;
    }
    _realTimeInfoArray = [_realTimeInfoArray sortedArrayUsingSelector:@selector(compare:)];
    
    [self.myIndicator stopAnimating];
    
    [self.tableView reloadData];
    
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
- (IBAction)saveStop:(id)sender {
    int count = [Stops getSavedStops].count;
    
    if ([Helper isBought]||count<3){
        [Stops saveStop:self.stop];
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Saved"
                                                        message:@"Saved successfully"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Sorry, You can only add two stops in free version. Please update to premium version to support us."
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Support",nil];
        alert.delegate = self;
        [alert show];
    }
    
    
}



- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button Index =%ld",buttonIndex);
    if (buttonIndex == 0)
    {
        NSLog(@"You have clicked Cancel");
    }
    else if(buttonIndex == 1)
    {
        NSLog(@"You have clicked GOO");
        PurchasedViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"purchase"];
        [self.navigationController pushViewController:controller animated:YES];
    }
}
@end
