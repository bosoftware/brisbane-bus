//
//  RealTimeInfo.h
//  SydneyTransit
//
//  Created by Bo Wang on 20/06/2015.
//  Copyright (c) 2015 Bo Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RealTimeInfo : NSObject





@property(nonatomic,retain) NSString * tripId;
@property(nonatomic,retain) NSString * tripName;
@property(nonatomic,retain) NSString * routeName;
@property(nonatomic,retain) NSString * stopName;
@property(nonatomic,retain) NSString * departureTime;
@property(nonatomic,retain) NSString * delay;
@property(nonatomic,retain) NSString * lat;
@property(nonatomic,retain) NSString * lon;

@property(nonatomic,retain) NSString * oriDeTime;
@end
