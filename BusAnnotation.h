//
//  BusAnnotation.h
//  SydneyTransit
//
//  Created by Bo Wang on 24/06/2015.
//  Copyright (c) 2015 Bo Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BusAnnotation : NSObject<MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
    BOOL isRed;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
@property(nonatomic,retain) UIViewController* mapViewController;


- (id)initWithCoordinates:(CLLocationCoordinate2D)location mytitle:(NSString*)mytitle;

-(MKAnnotationView*) annotationView;

@end
