//
//  StopTimeTableItem.h
//  brisbane.transit
//
//  Created by Bo Wang on 17/10/2014.
//  Copyright (c) 2014 Bo Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StopTimeTableItem : NSObject
@property(nonatomic,retain) NSString * stopRouteName;
@property(nonatomic,retain) NSString * stopFrom1Name;
@property(nonatomic,retain) NSString * stopTo1Name;
@property(nonatomic,retain) NSString * stopFrom1Time;
@property(nonatomic,retain) NSString * stopTo1Time;
@property(nonatomic,retain) NSString * tripId;
@property(nonatomic,retain) NSString * tripName;
@property(nonatomic,retain) NSString * tripHeadSign;
@property(nonatomic,retain) NSString * delay;
@property(nonatomic,retain) NSString * arriveTime;
@property(nonatomic,retain) NSMutableArray * keysArray;
- (NSComparisonResult)compare:(StopTimeTableItem *)otherObject;


@end
