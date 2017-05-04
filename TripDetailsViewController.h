//
//  TripDetailsViewController.h
//  SydneyTransit
//
//  Created by Bo Wang on 23/06/2015.
//  Copyright (c) 2015 Bo Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <iAd/iAd.h>
#import "NetworkResponseProtocol.h"
#import "RealTimeInfoProtocol.h"

@interface TripDetailsViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate,NetworkResponseProtocol,UIGestureRecognizerDelegate,RealTimeInfoProtocol>
@property (weak, nonatomic) IBOutlet MKMapView *myMap;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *myIndicator;
@property(nonatomic,retain) NSMutableArray * stopDetails;
@property(nonatomic,retain) NSString * tripId;
@property(nonatomic,retain) NSString * routeName;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation* currentLocation;
@property(strong,nonatomic) ADBannerView * adView;
@end
