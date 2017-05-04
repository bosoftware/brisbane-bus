//
//  RealTimeInfo.m
//  SydneyTransit
//
//  Created by Bo Wang on 20/06/2015.
//  Copyright (c) 2015 Bo Software. All rights reserved.
//

#import "RealTimeInfo.h"

@implementation RealTimeInfo

- (NSComparisonResult)compare:(RealTimeInfo*)otherObject {
    long m1 = [self.oriDeTime longLongValue];
    long m2 = [otherObject.oriDeTime longLongValue];
    if (m1<m2)
        return NSOrderedAscending;
    else if (m1>m2)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}
@end
