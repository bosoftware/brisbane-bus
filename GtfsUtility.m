//
//  GtfsUtility.m
//  brisbane.transit
//
//  Created by Bo Wang on 12/10/2014.
//  Copyright (c) 2014 Bo Software. All rights reserved.
//

#import "GtfsUtility.h"
#import "prefix.h"
#import "AFHTTPClient.h"
#import  <UIKit/UIKit.h>
#import "NetworkResponseProtocol.h"
#import "Routes.h"
#import "Stops.h"
#import "StopTimeTableItem.h"
#import "StopTimeTableDetailsItem.h"
#import "GCDiscreetNotificationView.h"
#define ROUTE_QUERY  1
#define STOP_QUERY  2
#define STOP_TO_QUERY 3
#define STOP_TIME_TABLE_QUERY 4
#define TRIP_DETAILS_QUERY 5

@implementation GtfsUtility


+(void) networkQuery:(NSDictionary *) parameters  indicator:(UIActivityIndicatorView*) indicatorView  controller:(id<NetworkResponseProtocol>) control  queryType:(NSInteger) type{
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:QUERY_URL]];
    [client getPath:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *rss = nil;
        if ([responseObject isKindOfClass:[NSData class]]) {
            rss = (NSData*)responseObject;//[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        } else {
            rss = (NSString *)responseObject;
        }
        if ([control conformsToProtocol:@protocol(NetworkResponseProtocol)]==YES){
            //[control ]control = [self getRoutes:rss];
            NSMutableArray * array = [[NSMutableArray alloc]init];
            if (type==ROUTE_QUERY){
                array =[self  getRoutes:rss];
            }else if(type == STOP_QUERY){
                array = [self getStops:rss];
            }else if(type==STOP_TO_QUERY){
                array = [self getStopsTo:rss];
            }else if(type==STOP_TIME_TABLE_QUERY){
                array = [self getStopTimeTable:rss];
            }else if (type==TRIP_DETAILS_QUERY){
                array = [self getTripDetails:rss];
            }
            [control setResponseArray:array];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [indicatorView stopAnimating];
        [GtfsUtility ToastNotification:@"Sorry, Network Issue, Please try it again. thanks"  andView:self andLoading:NO andIsBottom:NO];
        //ShowAlerViewWithMessage( @"Sorry, Network Issue, Please try it again. thanks" );
    }];
    
}



+(void) getRoutesByType:(NSString*) routeType indicator:(UIActivityIndicatorView*) indicatorView  controller:(id<NetworkResponseProtocol>) control{
    NSDictionary * parameters = @{@"method":@"getRoutesByType",@"routeType":routeType};
    [self networkQuery:parameters indicator:indicatorView controller:control queryType:ROUTE_QUERY];
}

+(NSMutableArray *)getRoutes:(NSData*)response{
    NSMutableArray * array = [[NSMutableArray alloc]init];
    NSError *localError = nil;
    //-- JSON Parsing
    NSMutableArray *result = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:&localError];
    //NSLog(@"Result = %@",result);
    NSMutableArray * tarray = [[NSMutableArray alloc]init];
    for (NSMutableDictionary *dic in result)
    {
        NSString * routeLongName =dic[@"route_long_name"];
        if (![tarray containsObject:routeLongName]){
            Routes *routes = [[Routes alloc]init];
            [tarray addObject:routeLongName];
            NSString *route_id = dic[@"route_id"];
            routes.route_id = route_id;
            routes.route_long_name = routeLongName;
            routes.route_short_name=dic[@"route_short_name"];
            routes.route_desc=dic[@"route_desc"];
            routes.route_type=dic[@"route_type"];
            [array addObject:routes];
        }
    }
    
    return array;
}


+(NSMutableArray *)getStops:(NSData*)response{
    NSMutableArray * array = [[NSMutableArray alloc]init];
    NSError *localError = nil;
    //-- JSON Parsing
    NSMutableArray *result = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:&localError];
    //NSLog(@"Result = %@",result);
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setMaximumFractionDigits:4];
    NSMutableArray * tarray = [[NSMutableArray alloc]init];
    for (NSMutableDictionary *dic in result)
    {
        NSString * stopId =dic[@"stop_id"];
        if (![tarray containsObject:stopId]){
            [tarray addObject:stopId];
            Stops *stops = [[Stops alloc]init];
            stops.stop_id = dic[@"stop_id"];
            stops.stop_name=dic[@"stop_name"];
            stops.stop_desc=dic[@"stop_desc"];
            stops.direction_id = dic[@"direction_id"];
            stops.stop_sequence = dic[@"stop_sequence"];
            stops.stop_lat= dic[@"stop_lat"] ;
            //stops.stop_lon= [fmt stringFromNumber:[NSNumber numberWithDouble:[dic[@"stop_lon"] doubleValue]]] ;
            stops.stop_lon= dic[@"stop_lon"];
            stops.parent_station=dic[@"parent_station"];
            [array addObject:stops];
        }
    }
    
    return array;
}

+(NSMutableArray *)getStopsTo:(NSData*)response{
    NSMutableArray * array = [[NSMutableArray alloc]init];
    NSError *localError = nil;
    //-- JSON Parsing
    NSMutableArray *result = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:&localError];
    //NSLog(@"Result = %@",result);
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setMaximumFractionDigits:2];
    for (NSMutableDictionary *dic in result)
    {
        Stops *stops = [[Stops alloc]init];
        stops.stop_id = dic[@"stop_id"];
        stops.stop_name=dic[@"stop_name"];
        stops.stop_desc=dic[@"stop_desc"];
        stops.direction_id = dic[@"direction_id"];
        stops.stop_sequence = dic[@"stop_sequence"];
        stops.stop_lat= dic[@"stop_lat"];
        stops.stop_lon= dic[@"stop_lon"] ;
        stops.parent_station=dic[@"parent_station"];
        [array addObject:stops];
    }
    
    return array;
}


+(NSMutableArray *)getStopTimeTable:(NSData*)response{
    NSMutableArray * array = [[NSMutableArray alloc]init];
    NSError *localError = nil;
    //-- JSON Parsing
    NSMutableArray *result = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:&localError];
    //NSLog(@"Result = %@",result);
    
    for (NSMutableDictionary *dic in result)
    {
        StopTimeTableItem *stopTime = [[StopTimeTableItem alloc]init];
        stopTime.stopRouteName = dic[@"route_name"];
        stopTime.stopFrom1Name = dic[@"departure_stop"];
        stopTime.stopFrom1Time = dic[@"departure_time"];
        stopTime.stopTo1Name = dic[@"arrival_stop"];
        stopTime.stopTo1Time = dic[@"arrival_time"];
        stopTime.tripId = dic[@"trip_id"];
        stopTime.tripName = dic[@"trip_short_name"];
        stopTime.tripHeadSign=dic[@"trip_headsign"];
        if ([array containsObject:stopTime]==FALSE){
            [array addObject:stopTime];
        }
    }
    array = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        StopTimeTableItem * stopTime = obj1;
        StopTimeTableItem * stopTime1 = obj2;
        return [stopTime compare:stopTime1];
    }];
    return array;
}


+(NSMutableArray *)getTripDetails:(NSData*)response{
    NSMutableArray * array = [[NSMutableArray alloc]init];
    NSError *localError = nil;
    //-- JSON Parsing
    NSMutableArray *result = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:&localError];
    //NSLog(@"Result = %@",result);
    
    for (NSMutableDictionary *dic in result)
    {
        StopTimeTableDetailsItem *item = [[StopTimeTableDetailsItem alloc]init];
        item.stopId = dic[@"stop_id"];
        item.stopName = dic[@"stop_name"];
        item.arrive_time = dic[@"arrival_time"];
        item.stop_sequence = dic[@"stop_sequence"];
        item.stop_lat=dic[@"stop_lat"];
        item.stop_lon=dic[@"stop_lon"];
        [array addObject:item];
    }
    
    return array;
}

+(void) getStopsByRouteType:(NSString*) routeType indicator:(UIActivityIndicatorView*) indicatorView  controller:(id<NetworkResponseProtocol>) control{
    NSDictionary * parameters = @{@"method":@"getStopsByRouteType",@"routeType":routeType};
    [self networkQuery:parameters indicator:indicatorView controller:control queryType:STOP_QUERY];
    
    
}


+(void) getStopsByStopFrom:(NSString*) stopFromId routeType:(NSString*)routeType indicator:(UIActivityIndicatorView*) indicatorView  controller:(id<NetworkResponseProtocol>) control{
    NSString * todayString = [GtfsUtility getTodayString];
    NSDictionary * parameters;
    if (routeType==nil){
          parameters = @{@"method":@"getStopsByStopFrom",@"stopFromId":stopFromId,@"todayStr":todayString};
    }else{
      parameters = @{@"method":@"getStopsByStopFrom",@"routeType":routeType,@"stopFromId":stopFromId,@"todayStr":todayString};
    }
    [self networkQuery:parameters indicator:indicatorView controller:control queryType:STOP_QUERY];
    
    
}

+(void) getStopsByRouteType:(NSString*) routeType stopName:(NSString *)stopNameLike  indicator:(UIActivityIndicatorView*) indicatorView  controller:(id<NetworkResponseProtocol>) control{
    if(stopNameLike!=nil&&stopNameLike.length>1){
        NSDictionary * parameters = @{@"method":@"getStopsByRouteTypeAndStopName",@"routeType":routeType,@"stopNameLike":stopNameLike};
        [self networkQuery:parameters indicator:indicatorView controller:control queryType:STOP_QUERY];
    }
}


+(void) getStopsByRouteAndFrom:(NSString*) routeId stopFrom:(Stops*)stopFrom routeType:(NSString*)routeType indicator:(UIActivityIndicatorView*) indicatorView  controller:(id<NetworkResponseProtocol>) control{
    NSString * todayStr = [GtfsUtility getTodayString];
    NSDictionary * parameters = @{@"method":@"getStopsByRouteAndFrom",@"routeType":routeType,@"routeId":routeId,@"stopId":stopFrom.stop_id,@"todayStr":todayStr};
    [self networkQuery:parameters indicator:indicatorView controller:control queryType:STOP_QUERY];
    
}

+(void) getStopByStopId:(NSString*) stopId indicator:(UIActivityIndicatorView*) indicatorView  controller:(id<NetworkResponseProtocol>) control{
    NSDictionary * parameters = @{@"method":@"getStopByStopId",@"stopId":stopId};
    [self networkQuery:parameters indicator:indicatorView controller:control queryType:STOP_QUERY];
}

+(void) getStopsByRoute:(NSString*) routeId  routeType:(NSString*)routeType indicator:(UIActivityIndicatorView*) indicatorView  controller:(id<NetworkResponseProtocol>) control{
    NSDictionary * parameters = @{@"method":@"getStopsByRoute",@"routeId":routeId,@"routeType":routeType};
    [self networkQuery:parameters indicator:indicatorView controller:control queryType:STOP_QUERY];
}

+(void) getStopsByRoute:(NSString*) routeId indicator:(UIActivityIndicatorView*) indicatorView  controller:(id<NetworkResponseProtocol>) control stopFrom:(Stops*)from{
    NSDictionary * parameters = @{@"method":@"getStopsByRouteAndStopFrom",@"routeId":routeId,@"directionId":from.direction_id,@"stopSequence":from.stop_sequence};
    [self networkQuery:parameters indicator:indicatorView controller:control queryType:STOP_TO_QUERY];
    
}



+(void) getTimeTable:(NSString*) routeId indicator:(UIActivityIndicatorView*) indicatorView  controller:(id<NetworkResponseProtocol>) control stopFrom:(Stops*)from stopTo:(Stops*) to dayStr:(NSString*) day  routeType:(NSString*)routeType{
    NSString  * todayString = [GtfsUtility getTodayString];
    NSDictionary * parameters;
    if (routeType!=nil){
    parameters = @{@"method":@"getTimeTable",@"fromStopId":from.stop_id,@"toStopId":to.stop_id,@"todayStr":todayString,@"day":day,@"routeType":routeType};
    }else{
        parameters = @{@"method":@"getTimeTable",@"fromStopId":from.stop_id,@"toStopId":to.stop_id,@"todayStr":todayString,@"day":day};
    }
    [self networkQuery:parameters indicator:indicatorView controller:control queryType:STOP_TIME_TABLE_QUERY ];
    
}




+(void) getOneRoutes:stopFrom:(Stops*)from stopTo:(Stops*) to indicator:(UIActivityIndicatorView*) indicatorView  controller:(id<NetworkResponseProtocol>) control {
    NSDictionary * parameters = @{@"method":@"getOneRoutes",@"fromStopId":from.stop_id,@"toStopId":to.stop_id};
    [self networkQuery:parameters indicator:indicatorView controller:control queryType:ROUTE_QUERY];
}
+(void) getStopsByLatLot:(NSString*)nwLat nwLon:(NSString*)nwLon seLat:(NSString*)seLat seLon:(NSString*)seLon indicator:(UIActivityIndicatorView*) indicatorView controller:(id<NetworkResponseProtocol>) control{
    NSDictionary * parameters = @{@"method":@"getStopsByLatLot",@"nwLat":nwLat,@"nwLon":nwLon,@"seLat":seLat,@"seLon":seLon};
    [self networkQuery:parameters indicator:indicatorView controller:control queryType:STOP_TO_QUERY];
}

+(NSString*) getTimeString:(NSString*) originStr{
    NSString * seconds = [originStr substringWithRange:NSMakeRange(4, 2)];
    NSString * minutes = [originStr substringWithRange:NSMakeRange(2,2)];
    NSString * hours = [originStr substringWithRange:NSMakeRange(0, 2)];
    int hour = [hours integerValue];
    NSString * amPm = @"am";
    if (hour>=24){
        amPm=@"am";
        hour = hour -24;
    }else{
        if (hour>=12){
            amPm = @"pm";
        }
        if (hour > 12){
            hour = hour - 12;
        }
    }
    hours = [NSString stringWithFormat:@"%d", hour];
    NSString * time = [NSString stringWithFormat:@"%@:%@ %@",hours,minutes,amPm];
    return time;
}



+(void) getTripDetails:(NSString *) tripId indicator:(UIActivityIndicatorView*) indicatorView  controller:(id<NetworkResponseProtocol>) control{
    NSDictionary * parameters = @{@"method":@"getTripDetails",@"tripId":tripId};
    [self networkQuery:parameters indicator:indicatorView controller:control queryType:TRIP_DETAILS_QUERY];
}

+ (void)ToastNotification:(NSString *)text andView:(UIView *)view andLoading:(BOOL)isLoading andIsBottom:(BOOL)isBottom
{
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                    message:text
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    [toast show];
    
    int duration = 2; // duration in seconds
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [toast dismissWithClickedButtonIndex:0 animated:YES];
    });
}


+(void) getStopsByName:(NSString*) stopName indicator:(UIActivityIndicatorView*) indicatorView  controller:(id<NetworkResponseProtocol>) control{
    if(stopName!=nil&&stopName.length>1){
        NSDictionary * parameters = @{@"method":@"getStopsByName",@"stopName":stopName};
       
        [self networkQuery:parameters indicator:indicatorView controller:control queryType:STOP_QUERY];
    }
}


+(void) getTimeTable:(NSString*) stopId indicator:(UIActivityIndicatorView*) indicatorView  controller:(id<NetworkResponseProtocol>) control {
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HHmmss"];
    
    NSDate *now = [[NSDate alloc] init];
    
    NSString *theTime = [timeFormat stringFromDate:now];
    
    NSDictionary * parameters = @{@"method":@"getTimeTableByStopId",@"stopId":stopId,@"theTime":theTime,@"todayStr":[GtfsUtility getTodayString],@"day":[GtfsUtility getDayString]};
    
   
    [self networkQuery:parameters indicator:indicatorView controller:control queryType:STOP_TIME_TABLE_QUERY ];
    
}

+(NSString *) getDayString{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    int weekday = [comps weekday]-1;
    NSString * dayStr;
    if(weekday == 1){
        dayStr = @"monday";
    }else if (weekday==2){
        dayStr = @"tuesday";
    }else if(weekday==3){
        dayStr = @"wednesday";
    }else if(weekday==4){
        dayStr = @"thursday";
    }else if (weekday==5){
        dayStr= @"friday";
    }else if (weekday==6){
        dayStr=@"saturday";
    }else if(weekday==0){
        dayStr=@"sunday";
    }
    return dayStr;
}

+(NSString *) getTodayString{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    NSDate *now = [[NSDate alloc] init];
    
    NSString *theDate = [dateFormat stringFromDate:now];
    return theDate;
}
@end
