//
//  SearchStopViewController.h
//  SydneyTransit
//
//  Created by Bo Wang on 20/06/2015.
//  Copyright (c) 2015 Bo Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GtfsUtility.h"

@interface SearchStopViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NetworkResponseProtocol>
@property (weak, nonatomic) IBOutlet UITextField *stopNameTextField;
@property (weak, nonatomic) IBOutlet UITableView *stopTableView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *myIndicator;

@property(nonatomic,retain) NSMutableArray * stopsArray;
@end
