//
//  StopPointMapViewController.m
//  SydneyTransit
//
//  Created by Bo Wang on 19/04/2015.
//  Copyright (c) 2015 Bo Software. All rights reserved.
//

#import "StopPointMapViewController.h"
#import "GtfsUtility.h"
#import "Stops.h"
#import "MapPin.h"

@interface StopPointMapViewController ()

@end

@implementation StopPointMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_indicator startAnimating];
     _mapView.delegate = self;
    //[GtfsUtility getStopByStopId:_stopItem.stopId indicator:_indicator controller:self];
    
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    for (StopTimeTableDetailsItem * stop in _stopDetails){
        CLLocationCoordinate2D location;
        location.latitude = [stop.stop_lat doubleValue];
        location.longitude = [stop.stop_lon doubleValue];
        MapPin * pin;
        Stops * s = [[Stops alloc]init];
        s.stop_id = stop.stopId;
        
        if (stop == _stopItem){
            pin = [[MapPin alloc] initWithCoordinates:location placeName:stop.stopName description:stop.stopId isRed:YES myStops:s];
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 200, 200);
            //                             MKCoordinateRegion region = self.mapView.region;
            //                             region.center = placemark.region.center;
            //                             region.span.longitudeDelta /= 8.0;
            //                             region.span.latitudeDelta /= 8.0;
            
            
            [self.mapView setRegion:region animated:YES];
        }else{
            pin = [[MapPin alloc] initWithCoordinates:location placeName:stop.stopName description:stop.stopId isRed:NO myStops:s];
        }
        pin.mapViewController = self;
        
        
        [self.mapView addAnnotation:pin];
    }
    [_indicator stopAnimating];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void) setResponseArray:(id)responseArray{
    _stopDetails = responseArray;
    
    [_indicator stopAnimating];
    
    Stops * stop = [_stopDetails objectAtIndex:0];
    
    CLLocationCoordinate2D location;
    location.latitude = [stop.stop_lat doubleValue];
    location.longitude = [stop.stop_lon doubleValue];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 200, 200);
//                             MKCoordinateRegion region = self.mapView.region;
//                             region.center = placemark.region.center;
//                             region.span.longitudeDelta /= 8.0;
//                             region.span.latitudeDelta /= 8.0;
    
    
    [self.mapView setRegion:region animated:YES];
    
    MapPin * pin = [[MapPin alloc] initWithCoordinates:location placeName:stop.stop_name description:stop.stop_desc isRed:NO myStops:[stop clone]];
    pin.mapViewController = self;
    
    [self.mapView addAnnotation:pin];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MapPin class]]){
        MapPin * mapPin = (MapPin *)annotation;
        MKAnnotationView * annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:mapPin.title];
        if (annotationView==nil){
            annotationView = mapPin.annotationView;
        }else{
            annotationView.annotation=annotation;
        }
        return annotationView;
    }
    return nil;
    
    
}
@end
