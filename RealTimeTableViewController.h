//
//  RealTimeTableViewController.h
//  SydneyTransit
//
//  Created by Bo Wang on 20/06/2015.
//  Copyright (c) 2015 Bo Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GtfsUtility.h"
#import "RealTimeInfoProtocol.h"


@interface RealTimeTableViewController : UITableViewController<NetworkResponseProtocol,UIAlertViewDelegate,RealTimeInfoProtocol>
@property(nonatomic,retain) NSMutableArray * realTimeInfoArray;
@property(nonatomic,retain) NSMutableArray * timetableResponseArray;

@property(nonatomic,retain) Stops * stop;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *myIndicator;

@end
