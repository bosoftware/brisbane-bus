//
//  RealTimeUtil.h
//  SydneyTransit
//
//  Created by Bo Wang on 20/06/2015.
//  Copyright (c) 2015 Bo Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RealTimeInfoProtocol.h"

@interface RealTimeUtil : NSObject


+(void) getRealTimeArray:(NSString*)stopId controller:(id<RealTimeInfoProtocol>) control;
+(void) getRealTimeVehiclePosition:(NSString*)tripId controller:(id<RealTimeInfoProtocol>) control;
@end
