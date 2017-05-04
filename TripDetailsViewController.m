//
//  TripDetailsViewController.m
//  SydneyTransit
//
//  Created by Bo Wang on 23/06/2015.
//  Copyright (c) 2015 Bo Software. All rights reserved.
//

#import "TripDetailsViewController.h"
#import "GtfsUtility.h"
#import "Helper.h"
#import "StopTimeTableDetailsItem.h"
#import "MapPin.h"
#import "RealTimeUtil.h"
#import "RealTimeInfo.h"
#import "BusAnnotation.h"

@interface TripDetailsViewController (){
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    bool isMoved ;
    NSTimer * timer;
    BusAnnotation * currentPosition;
}

@end

@implementation TripDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = _routeName;
    _adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    _adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.myMap.delegate=self;
    UIPanGestureRecognizer* panRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragMap:)];
    [panRec setDelegate:self];
    [self.myMap addGestureRecognizer:panRec];
    [GtfsUtility getTripDetails:_tripId indicator:_myIndicator controller:self];
    isMoved=false;
    if ([CLLocationManager locationServicesEnabled] )
    {
        
        if (self.locationManager == nil )
        {
            self.locationManager = [[CLLocationManager alloc] init];
            
            self.locationManager.delegate = self;
            self.locationManager.distanceFilter = kCLDistanceFilterNone;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [self.locationManager requestWhenInUseAuthorization];
                
                
            }
            
            
            CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
            
            if (authorizationStatus == kCLAuthorizationStatusAuthorized ||
                authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
                authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse
                ||authorizationStatus == kCLAuthorizationStatusNotDetermined) {
                
                [self.locationManager startUpdatingLocation];
                self.myMap.showsUserLocation = YES;
                
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You have to enable local service" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }else{
            [self.locationManager startUpdatingLocation];
        }
        
        
        
        
    }
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [timer invalidate];
    //timer = nil;
}
-(void)refresh:(NSTimer *)timer{
    
    [RealTimeUtil getRealTimeVehiclePosition:_tripId controller:self];
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.myIndicator stopAnimating];
    timer = [NSTimer scheduledTimerWithTimeInterval: 10.0
                                             target: self
                                           selector:@selector(refresh:)
                                           userInfo: nil repeats:YES];
    [self refresh:timer];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    int count = _stopDetails.count;
    if (![Helper isBought]){
        count = count+1;
        
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==_stopDetails.count){
        UITableViewCell *tempcell;
        NSString *identifier = @"AdTableItem";
        tempcell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (tempcell == nil) {
            tempcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        } else {
            [[tempcell.contentView subviews] //clear the cell view
             makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
        
        [tempcell.contentView addSubview:self.adView];
        return tempcell;
        
    }else{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tripDetails" forIndexPath:indexPath];
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor orangeColor];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        // Configure the cell...
        StopTimeTableDetailsItem * item = [_stopDetails objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",item.stopName,[GtfsUtility getTimeString:item.arrive_time]];
        return cell;
    }
    
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
    _stopDetails = [[NSMutableArray alloc]init];
    if (responseArray!=nil){
        [_stopDetails addObjectsFromArray:responseArray];
        [self.tableView reloadData];
        [self drawAllStops];
    }
    
    [_myIndicator stopAnimating];
    
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
        annotationView.layer.zPosition = 0;
        return annotationView;
    }else if ([annotation isKindOfClass:[BusAnnotation class]]){
        if (currentPosition==nil){
            return nil;
        }
        BusAnnotation * mapPin = (BusAnnotation *)annotation;
        MKAnnotationView * annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"RunBus"];
        if (annotationView==nil){
            annotationView = mapPin.annotationView;
        }else{
            annotationView.annotation=annotation;
        }
        annotationView.layer.zPosition = 80;
        [mapView selectAnnotation:annotationView animated:FALSE];
        return annotationView;
    }
    return nil;
    
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = [locations lastObject];
    // here we get the current location
    
    if (!isMoved){
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.currentLocation.coordinate, 10000, 10000);
        //                         MKCoordinateRegion region = self.mapView.region;
        //                         region.center = placemark.region.center;
        //                         region.span.longitudeDelta /= 8.0;
        //                         region.span.latitudeDelta /= 8.0;
        
        
        [self.myMap setRegion:region animated:YES];
        //[self drawNearbyStops];
        isMoved=true;
    }
    //MapPin * pin = [[MapPin alloc] initWithCoordinates:self.currentLocation.coordinate placeName:@"Select this address" description:@""];
    //pin.mapViewController = self;
    //[self.mapView addAnnotation:pin];
    
    
    
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)didDragMap:(UIGestureRecognizer*)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded){
        NSLog(@"drag ended");
        //[self drawNearbyStops];
    }
}

- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered
{
    // Image creation code here
    //[self drawNearbyStops];
    if (currentPosition!=nil){
        for (id<MKAnnotation> currentAnnotation in mapView.annotations) {
            if ([currentAnnotation isEqual:currentPosition]) {
                [mapView selectAnnotation:currentAnnotation animated:FALSE];
            }
        }
    }
}

-(void) drawAllStops{
    //[self removeAllPinsButUserLocation];
    
    for (StopTimeTableDetailsItem * stop in _stopDetails){
        CLLocationCoordinate2D location;
        location.latitude = [stop.stop_lat doubleValue];
        location.longitude = [stop.stop_lon doubleValue];
        MapPin * pin;
        Stops * s = [[Stops alloc]init];
        s.stop_id = stop.stopId;
        s.stop_name = stop.stopName;
        
        pin = [[MapPin alloc] initWithCoordinates:location placeName:stop.stopName description:stop.stopId isRed:NO myStops:[s clone]];
        
        pin.mapViewController = self;
        
        [self.myMap addAnnotation:pin];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self removeAllPinsButUserLocation];
    
    StopTimeTableDetailsItem * stopnow = [_stopDetails objectAtIndex:indexPath.row];
    //[self.myMap removeAnnotations:self.myMap.annotations];
    /*
     if (currentPosition!=nil){
     [self.myMap addAnnotation:currentPosition];
     }
     */
    for (StopTimeTableDetailsItem * stop in _stopDetails){
        CLLocationCoordinate2D location;
        
        location.latitude = [stop.stop_lat doubleValue];
        location.longitude = [stop.stop_lon doubleValue];
        /*
         NSString * des = stop.stopId;
         if (des==nil){
         des = @"";
         }
         MapPin * pin;
         Stops * s = [[Stops alloc]init];
         s.stop_id = stop.stopId;
         s.stop_name=stop.stopName;
         */
        if ([stopnow.stopId isEqualToString:stop.stopId]){
            //pin = [[MapPin alloc] initWithCoordinates:location placeName:stop.stopName description:des isRed:YES myStops:[s clone]];
            
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 2000, 2000);
            
            [self.myMap setRegion:region animated:YES];
        }
        /*
         else{
         pin = [[MapPin alloc] initWithCoordinates:location placeName:stop.stopName description:des isRed:NO myStops:[s clone]];
         }
         pin.mapViewController = self;
         pin.annotationView.layer.zPosition = 1000;
         
         
         [self.myMap addAnnotation:pin];
         */
        
        
    }
    
    
}

-(void) setRealTimeInfoArray:(id)newArray{
    //[self removeAllPinsButUserLocation];
    
    for (RealTimeInfo * r in newArray){
        CLLocationCoordinate2D location;
        
        location.latitude = [r.lat doubleValue];
        location.longitude = [r.lon doubleValue];
        if (currentPosition!=nil){
            
            [self.myMap removeAnnotation:currentPosition];
        }
        
        
            currentPosition = [[BusAnnotation alloc] initWithCoordinates:location mytitle:_routeName];
            currentPosition.mapViewController=self;
            
        
        //currentPosition.coordinate = location;
        
        
        [self.myMap addAnnotation:currentPosition];
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 2000, 2000);
        
        
        [self.myMap selectAnnotation:currentPosition.annotationView animated:FALSE];
        [self.myMap setRegion:region animated:YES];
        
        
        
    }
    
}


- (void)removeAllPinsButUserLocation
{
    id userLocation = [self.myMap userLocation];
    NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:[self.myMap annotations]];
    if (pins!=nil&&pins.count>0){
        /*
         if ( userLocation != nil ) {
         if ([pins containsObject:userLocation]){
         [pins removeObject:userLocation]; // avoid removing user location off the map
         }
         }
         
         if (currentPosition!=nil){
         if ([pins containsObject:currentPosition]){
         [pins removeObject:currentPosition];
         }
         }
         */
        //[self.myMap removeAnnotations:pins];
    }
}

@end
