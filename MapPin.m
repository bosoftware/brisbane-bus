//
//  MapPin.m
//  Arrived
//
//  Created by Bo Wang on 28/01/2015.
//  Copyright (c) 2015 Bo Wang. All rights reserved.
//

#import "MapPin.h"
#import "prefix.h"
#import "Utilities.h"
#import "MapPinButton.h"

#import "RealTimeTableViewController.h"
#define kHeight 40
#define kWidth  37
#define kBorder 2

@implementation MapPin{
    Stops *stop;
}

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
//@synthesize stop;
- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:placeName description:description isRed:(BOOL)_isRed myStops:(Stops *)myStops{
    self = [super init];
    if (self != nil) {
        coordinate = location;
        title = placeName;
        
        subtitle = description;
        isRed = _isRed;
        stop=[myStops clone];
    }
    return self;
}

-(MKAnnotationView*) annotationView{
    MKAnnotationView * annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:title];
    annotationView.enabled=YES;
    annotationView.canShowCallout=YES;
    if (isRed==NO){
        annotationView.layer.zPosition=100;
        annotationView.image = [UIImage imageNamed:@"bus"];
    }else{
        annotationView.layer.zPosition=200;
        annotationView.image = [UIImage imageNamed:@"redbus"];
    }
    /*
    UIButton *pinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pinButton.frame = CGRectMake(2, 2, 50, 50);
    [pinButton setImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
    pinButton.tag = title;
    [pinButton addTarget:self action:@selector(saveAddress:) forControlEvents:UIControlEventTouchUpInside];
    */
    //UIView *viewLeftAccessory = [[UIView alloc] initWithFrame:CGRectMake(0, 0, annotationView.frame.size.height, annotationView.frame.size.height)];
    
    MapPinButton *temp=[MapPinButton buttonWithType:UIButtonTypeDetailDisclosure];
    //[temp setImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
    //temp.contentMode = UIViewContentModeScaleAspectFit;
    //temp.tag = title;
    temp.stopId = stop.stop_id;
    temp.stopName =stop.stop_name;
    [temp addTarget:self action:@selector(saveAddress:) forControlEvents:UIControlEventTouchUpInside];
    //[viewLeftAccessory addSubview:temp];
    
    //annotationView.leftCalloutAccessoryView=viewLeftAccessory;
    //[temp setTitle:title forState:UIControlStateNormal];
    annotationView.rightCalloutAccessoryView=temp;
    //annotationView.frame=CGRectMake(0, 0, kWidth, kHeight);
    return annotationView;
}

-(void) saveAddress:(id)sender  {
    //_mapViewController.selectLocation.latitude = [NSNumber numberWithFloat:coordinate.latitude];
    //_mapViewController.selectLocation.longitude = [NSNumber numberWithFloat:coordinate.longitude];
    // [_mapViewController.navigationController popViewControllerAnimated:TRUE];
    MapPinButton * btn = (MapPinButton*)sender;
    RealTimeTableViewController *toStopController = ViewControllerFromStoryboard(@"realTimeInformation");
    Stops * stop = [[Stops alloc]init];
    stop.stop_id = btn.stopId;
    stop.stop_name =btn.stopName;
    toStopController.stop=stop;
    // Present the log in view controller
    [_mapViewController.navigationController.visibleViewController.navigationController pushViewController:toStopController animated:YES];
    //[Utilities ToastNotification:@"Address has been selected and will be monitored" andView:self andLoading:YES andIsBottom:YES];
    
}

@end
