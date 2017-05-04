//
//  MapPinButton.h
//  SydneyTransit
//
//  Created by Bo Wang on 11/07/2015.
//  Copyright (c) 2015 Bo Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stops.h"

@interface MapPinButton : UIButton
@property(nonatomic,retain) NSString * stopId;
@property(nonatomic,retain) NSString * stopName;
@end
