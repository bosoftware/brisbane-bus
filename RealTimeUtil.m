//
//  RealTimeUtil.m
//  SydneyTransit
//
//  Created by Bo Wang on 20/06/2015.
//  Copyright (c) 2015 Bo Software. All rights reserved.
//

#import "RealTimeUtil.h"
#import "RealTimeInfo.h"
#import  "RealTimeInfoProtocol.h"
#import "AFHTTPClient.h"
#import "GtfsUtility.h"

@implementation RealTimeUtil
+(void) getRealTimeArray:(NSString*)stopId controller:(id<RealTimeInfoProtocol>) control{
    [self networkQueryRealTimeArray:control stopId:stopId];
}
+(void) getRealTimeVehiclePosition:(NSString*)tripId controller:(id<RealTimeInfoProtocol>) control{
    [self networkQueryRealTimeVehiclePosition:control tripId:tripId];
}


+(void) networkQueryRealTimeArray:(id<RealTimeInfoProtocol>) control  stopId:(NSString *) stopId{
    NSString * url =[NSString stringWithFormat:@"http://108.61.184.69/brisbanerealtime/gtfs-realtime/realtime.php?method=getStopInfo&stopId=%@",stopId];
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:url]];
    [client getPath:@"" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *rss = nil;
        if ([responseObject isKindOfClass:[NSData class]]) {
            rss = (NSData*)responseObject;//[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        } else {
            rss = (NSString *)responseObject;
        }
        if ([control conformsToProtocol:@protocol(RealTimeInfoProtocol)]==YES){
            //[control ]control = [self getRoutes:rss];
            NSMutableArray * array = [[NSMutableArray alloc]init];
            NSError *localError = nil;
            //-- JSON Parsing
            NSMutableArray *result = [NSJSONSerialization JSONObjectWithData:rss options:NSJSONReadingMutableContainers error:&localError];
            //NSLog(@"Result = %@",result);
            
            for (NSMutableDictionary *dic in result)
            {
                RealTimeInfo * info = [[RealTimeInfo alloc]init];
                info.tripId = dic[@"tripId"];
                info.delay=[NSString stringWithFormat:@"%@",dic[@"delay"]];
                info.departureTime=[NSString stringWithFormat:@"%@",dic[@"time"]];
                [array addObject:info];
            }

            [control setRealTimeInfoArray:array];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [GtfsUtility ToastNotification:@"Sorry, Network Issue, Please try it again. thanks"  andView:self andLoading:NO andIsBottom:NO];
        //ShowAlerViewWithMessage( @"Sorry, Network Issue, Please try it again. thanks" );
    }];
    
}


+(void) networkQueryRealTimeVehiclePosition:(id<RealTimeInfoProtocol>) control  tripId:(NSString *) tripId{
    NSString * url =[NSString stringWithFormat:@"http://108.61.184.69/brisbanerealtime/gtfs-realtime/realtime.php?method=getVechilePosition&tripId=%@",tripId];
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:url]];
    [client getPath:@"" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *rss = nil;
        if ([responseObject isKindOfClass:[NSData class]]) {
            rss = (NSData*)responseObject;//[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        } else {
            rss = (NSString *)responseObject;
        }
        if ([control conformsToProtocol:@protocol(RealTimeInfoProtocol)]==YES){
            //[control ]control = [self getRoutes:rss];
            NSMutableArray * array = [[NSMutableArray alloc]init];
            NSError *localError = nil;
            //-- JSON Parsing
            NSMutableArray *result = [NSJSONSerialization JSONObjectWithData:rss options:NSJSONReadingMutableContainers error:&localError];
            //NSLog(@"Result = %@",result);
            
            for (NSMutableDictionary *dic in result)
            {
                RealTimeInfo * info = [[RealTimeInfo alloc]init];
                info.tripId = tripId;
                info.lat = dic[@"lat"];
                info.lon = dic[@"lon"];
                [array addObject:info];
            }
            
            [control setRealTimeInfoArray:array];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [GtfsUtility ToastNotification:@"Sorry, Network Issue, Please try it again. thanks"  andView:self andLoading:NO andIsBottom:NO];
        //ShowAlerViewWithMessage( @"Sorry, Network Issue, Please try it again. thanks" );
    }];
    
}
@end
