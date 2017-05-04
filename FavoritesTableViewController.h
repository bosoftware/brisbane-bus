//
//  FavoritesTableViewController.h
//  brisbane.transit
//
//  Created by Bo Wang on 12/10/2014.
//  Copyright (c) 2014 Bo Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface FavoritesTableViewController : UITableViewController
@property(nonatomic,retain) NSMutableArray * savedTripArray;

@property(strong,nonatomic) ADBannerView * adView;
@end
