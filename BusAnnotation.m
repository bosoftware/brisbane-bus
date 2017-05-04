//
//  BusAnnotation.m
//  SydneyTransit
//
//  Created by Bo Wang on 24/06/2015.
//  Copyright (c) 2015 Bo Software. All rights reserved.
//

#import "BusAnnotation.h"

@implementation BusAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location mytitle:(NSString *)mytitle{
    self = [super init];
    if (self != nil) {
        coordinate = location;
        title = mytitle;
    }
    return self;
}

-(MKAnnotationView*) annotationView{
    MKAnnotationView * annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"RunBus"];
    annotationView.enabled=YES;
    annotationView.canShowCallout=YES;
        annotationView.image = [UIImage imageNamed:@"runbus"];
    
    return annotationView;
}
/*
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    [mapView selectAnnotation:view.annotation animated:FALSE];
}
 */
@end