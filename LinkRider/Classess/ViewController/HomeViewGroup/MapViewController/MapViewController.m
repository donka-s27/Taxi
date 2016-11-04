//
//  MapViewController.m
//  RevealControllerStoryboardExample
//
//  Created by Nick Hodapp on 1/9/13.
//  Copyright (c) 2013 CoDeveloper. All rights reserved.
//

#import "MapViewController.h"
#import "MyPinAnnotationView.h"
#import "NSString+FontAwesome.h"
#import "ModelManager.h"
#import "MBProgressHUD.h"
#import "OrderConfirmViewController.h"
#import "StartTripViewController.h"
#import "RatingTripViewController.h"
#import "UIImage+FontAwesome.h"
#import "UIFont+FontAwesome.h"
#import "OnlineViewController.h"
@interface MapViewController ()
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;
@end

@implementation MapViewController
@synthesize btnLocationFrom,btnLocationTo;
- (void)viewDidLoad
{
    [super viewDidLoad];
    isEdittingTfFrom = NO;
    gTrip = [[Trips alloc]init];
    [self getUserLocation];
//    gUser = [Util loadUser];
    [self customSetup];
    [self setText];
    [self.navigationController setNavigationBarHidden:NO];
[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(loadData) userInfo:nil repeats:NO];

}
-(void)getUserLocation{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
        [self.locationManager requestWhenInUseAuthorization];
    }///////..................////////////////////////////////////////////.............
#endif
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.mapview setMapType:MKMapTypeStandard];
    [self.mapview setZoomEnabled:YES];
    [self.mapview setScrollEnabled:YES];

    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    longPressGesture.minimumPressDuration = 1.0;
    [self.mapview addGestureRecognizer:longPressGesture];
    self.txtToName.delegate=self;
    self.txtFromName.delegate = self;
    MKCoordinateRegion region = { { 0.1, 0.1 }, { 1.0, 1.0 } };
    self.mapview.showsUserLocation = YES;
    region.center.latitude = _locationManager.location.coordinate.latitude;
    region.center.longitude = _locationManager.location.coordinate.longitude;
    
    region.span.longitudeDelta = 1.0;
    region.span.longitudeDelta = 1.0;
    [_mapview setRegion:region animated:YES];
    self.mapview.delegate = self;
    [_mapview setCenterCoordinate:_locationManager.location.coordinate animated:YES];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onResetPoint) name:@"resetAllPoint" object:nil];
}

-(void)onResetPoint{
    [_mapview removeAnnotation:fromPoint];
    [_mapview removeAnnotation:toPoint];
    [self removeAllPolyLine];
    self.txtFromName.text = @"";
    self.txtToName.text = @"";
    fromPoint.coordinate= CLLocationCoordinate2DMake(0,0) ;
    toPoint.coordinate= CLLocationCoordinate2DMake(0,0) ;
}
-(void)loadData{
    if ([gUser.is_driver boolValue]&&[gUser.driver.isOnline boolValue]) {
        
//        OnlineViewController *waitingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OnlineViewController"];
//        [self.navigationController pushViewController:waitingVC animated:YES];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ModelManager showMyTripsWithSuccess:^(NSMutableArray *arr) {
        for (Trips *trip in arr) {
            if ([trip.status isEqualToString:TRIP_STATUS_APPROACHING]||[trip.status isEqualToString:TRIP_STATUS_IN_PROGRESS]||[trip.status isEqualToString:TRIP_STATUS_PENDING_PAYMENT]) {
                
                gTrip = trip;
                if ([trip.status isEqualToString:TRIP_STATUS_APPROACHING]) {
                    if (trip.driverId.length>0) {
                        OrderConfirmViewController *start = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderConfirmViewController"];
                        [self.navigationController pushViewController:start animated:YES];
                    }
                    else{
                        WaitingViewController *waitingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WaitingViewController"];
                        [self.navigationController pushViewController:waitingVC animated:YES];
                    }
                    return;
                }
                else if([trip.status isEqualToString:TRIP_STATUS_IN_PROGRESS]){
                    
                    StartTripViewController *start = [self.storyboard instantiateViewControllerWithIdentifier:@"StartTripViewController"];
                    [self.navigationController pushViewController:start animated:YES];
                    
                    return;
                    
                }
                else if ([trip.status isEqualToString:TRIP_STATUS_PENDING_PAYMENT]){
                    RatingTripViewController *start = [self.storyboard instantiateViewControllerWithIdentifier:@"RatingTripViewController"];
                    [self.navigationController pushViewController:start animated:YES];
                    return;
                }
                
            }
            
        }
        [ModelManager showMyRequestWithSuccess:^(NSMutableArray *arr) {
            if (arr.count>0) {
                gTrip = [arr objectAtIndex:0];
                WaitingViewController *waitingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WaitingViewController"];
                [self.navigationController pushViewController:waitingVC animated:YES];
                
            }
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        } andFailure:^(NSString *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];

    } andFailure:^(NSString *err) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    
    
}
- (void)customSetup
{
    SWRevealViewController *revealViewController = self.revealViewController;
    [self.navigationController.navigationBar setBarTintColor:[Util colorWithHexString:@"#333333" alpha:1]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"Raleway-Medium" size:20], NSFontAttributeName, nil]];
    self.navigationController.navigationBar.translucent = YES;
    
    if ( revealViewController )
    {
        [self.revealButtonItem setTarget: self.revealViewController];
        [self.revealButtonItem setAction: @selector(revealToggle:)];
        [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
    
    [self.revealButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIFont fontAwesomeFontOfSize:24], NSFontAttributeName,
                                                   [UIColor whiteColor], NSForegroundColorAttributeName,
                                                   nil]
                                         forState:UIControlStateNormal];
    
    [self.revealButtonItem setTitle:@"\uf0c9"];
    
    [self.btnRefresh setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                [UIFont fontWithName:@"Pe-icon-7-stroke" size:26], NSFontAttributeName,
                                                [UIColor whiteColor], NSForegroundColorAttributeName,
                                                nil]
                                      forState:UIControlStateNormal];
    
    [self.btnRefresh setTitle:@"\ue6c2"];
    
}
-(void)viewWillAppear:(BOOL)animated{
   
}
-(void)setText{
    [self.lblHeaderTitle setTitle:[Util localized:@"header_request_car"]];

    self.bgFrom.layer.cornerRadius = 5;
    self.bgTo.layer.cornerRadius = 5;
    
    
    self.bgFrom.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bgFrom.layer.shadowOffset = CGSizeMake(10, 5);
    self.bgFrom.layer.shadowOpacity = 0.3;
    self.bgFrom.layer.shadowRadius = 5;
    self.bgFrom.clipsToBounds = NO;
    
    
    self.bgTo.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bgTo.layer.shadowOffset = CGSizeMake(10, 5);
    self.bgTo.layer.shadowOpacity = 0.3;
    self.bgTo.layer.shadowRadius = 5;
    self.bgTo.clipsToBounds = NO;
    
    
    self.btn1seat.hidden = NO;
    self.btn2seat.hidden = NO;
    self.btn3seat.hidden = NO;
//    [self.btnBook setSelected:NO];
    self.txtFromName.enabled = YES;
    self.txtToName.enabled = YES;
    
   
}
-(void)getNumberOfCarAroundPositon:(MKPointAnnotation*)pointAnnotation{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [ModelManager getNumberOfCarsWithLatitude:pointAnnotation.coordinate.latitude Longitude:pointAnnotation.coordinate.longitude withSuccess:^(int num) {
            if (self) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.imgCarsCount setImage:[Util drawText:[NSString stringWithFormat:@"%d",num] inImage:[UIImage imageNamed:@"ic_5_car_in_3000.png"] atPoint:CGPointMake(0, 0)]];
                    self.imgCarsCount.contentMode = UIViewContentModeScaleAspectFit;
                });
            }
            
        } failure:^(NSString *err) {
            
        }];
    });
}

#pragma mark MAPVIEW DELEGATE
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if([annotation isKindOfClass:[MKUserLocation class]])
        return Nil;
    NSString* annotationIdentifier = @"BusViewAnnotation";
    MyPinAnnotationView* pinView = (MyPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
    if(!pinView)
    {
        pinView = [[MyPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier] ;
        
    }else
    {
        pinView.annotation = annotation;
    }
    MKPointAnnotation *an = annotation;
    if (toPoint.coordinate.latitude==an.coordinate.latitude&&toPoint.coordinate.longitude==an.coordinate.longitude) {
        pinView.image = [UIImage imageNamed:@"location_b.png"];
        
    }
    if (fromPoint.coordinate.latitude==an.coordinate.latitude&&fromPoint.coordinate.longitude==an.coordinate.longitude){
        pinView.image = [UIImage imageNamed:@"location_a.png"];
        
    }
    return pinView;
}


- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 2.0;
    return renderer;
}
-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    for (UIView *subview in view.subviews ){
        [subview removeFromSuperview];
        
    }
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (userLocation!=currentLocation) {
        if (currentLocation.location.coordinate.latitude == 0 && currentLocation.location.coordinate.longitude == 0) {
            [_mapview setCenterCoordinate:userLocation.location.coordinate animated:YES];
        }
        if (fromPoint.coordinate.latitude > 0) {
            
        }else{
            MKPointAnnotation *pointCurrentLocation = [[MKPointAnnotation alloc]init];
            pointCurrentLocation.coordinate = userLocation.coordinate;
            [self getNumberOfCarAroundPositon:pointCurrentLocation];
        }
        currentLocation = userLocation;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [ModelManager updateCoordinatewithLat:userLocation.coordinate.latitude andLong:userLocation.coordinate.longitude withSuccess:^{
                currentLocation = userLocation;
            } failure:^(NSString *err) {
                
            }];
        });
    }
//    if (onFirstTime) {
//        MKCoordinateRegion mapRegion;
//        mapRegion.center = _mapview.userLocation.coordinate;
//        mapRegion.span.latitudeDelta = 0.01;
//        mapRegion.span.longitudeDelta = 0.01;
//        
//        [_mapview setRegion:mapRegion animated: YES];
//        onFirstTime = NO;
//    }
}

-(void)handleLongPressGesture:(UIGestureRecognizer*)sender {
//    
//    [_txtToName resignFirstResponder];
//    
//    [_txtFromName resignFirstResponder];
    
    MKPointAnnotation *pa = [[MKPointAnnotation alloc] init];
    
    [self.mapview removeGestureRecognizer:sender];
    if (sender.state != UIGestureRecognizerStateEnded)
        
    {
        
        CGPoint point = [sender locationInView:self.mapview];
        CLLocationCoordinate2D locCoord = [self.mapview convertPoint:point toCoordinateFromView:self.mapview];
        // Then all you have to do is create the annotation and add it to the map
        
        pa.coordinate = locCoord;
        if (isEdittingTfFrom == YES) {
            [_mapview removeAnnotation:fromPoint];
            fromPoint = pa;
        }else if (fromPoint.coordinate.latitude==0&&fromPoint.coordinate.longitude==0) {
            [_mapview removeAnnotation:fromPoint];
            fromPoint = pa;
            
        }
        else{
            [_mapview removeAnnotation:toPoint];
            toPoint = pa;
            
        }
        MKPointAnnotation *pa1 = [[MKPointAnnotation alloc] init];
        pa1 = pa;
        [_mapview addAnnotation:pa1];
        [self removeAllPolyLine];
        [self getLocationNameWithAnnotation:pa1];
        
    }
    else{
        
    }
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    longPressGesture.minimumPressDuration = 1.0;
    [self.mapview addGestureRecognizer:longPressGesture];
}

-(void)getLocationNameWithAnnotation:(MKPointAnnotation *)point{
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:point.coordinate.latitude longitude:point.coordinate.longitude]; //insert your coordinates
    MKPlacemark *placemarkFrom = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(point.coordinate.latitude, point.coordinate.longitude) addressDictionary:nil] ;
    MKMapItem *fromItem = [[MKMapItem alloc] initWithPlacemark:placemarkFrom];
    
    [ceo reverseGeocodeLocation:loc
              completionHandler:^(NSArray *placemarks, NSError *error) {
                  CLPlacemark *placemark = [placemarks objectAtIndex:0];
                  
                  NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                  
                  if (point.coordinate.longitude == toPoint.coordinate.longitude && point.coordinate.latitude == toPoint.coordinate.latitude) {
                      self.txtToName.text = locatedAt;
                      
                      [fromItem setName:locatedAt];
                      
                      gTrip.endLocation = fromItem;
                      
                  }
                  if (point.coordinate.longitude == fromPoint.coordinate.longitude && point.coordinate.latitude == fromPoint.coordinate.latitude) {
                      self.txtFromName.text = locatedAt;
                      
                      [fromItem setName:locatedAt];
                      
                      gTrip.startLocation = fromItem;
                      
                      
                  }
                  
                  [self showDirections];
              }];
}


#pragma mark TEXTFIELD DELEGATE
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if (_txtFromName.text.length == 1) {
//        [_mapview removeAnnotation:fromPoint];
//        fromPoint.coordinate= CLLocationCoordinate2DMake(0,0) ;
//        
//    }
//    if (_txtToName.text.length == 1) {
//        [_mapview removeAnnotation:toPoint];
//        toPoint.coordinate= CLLocationCoordinate2DMake(0,0) ;
//    }
//    else{
        [self generateDataWithKey:textField.text];
//    }
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == _txtFromName) {
        isEdittingTfFrom = YES;
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField == _txtFromName) {
        isEdittingTfFrom = NO;
    }
        if (_txtFromName.text.length == 0) {
            [_mapview removeAnnotation:fromPoint];
            fromPoint.coordinate= CLLocationCoordinate2DMake(0,0) ;
    
        }
        if (_txtToName.text.length == 0) {
            [_mapview removeAnnotation:toPoint];
            toPoint.coordinate= CLLocationCoordinate2DMake(0,0) ;
        }
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark BUTTON ACTION
- (IBAction)onFromLocation:(id)sender {
    [self.view endEditing:YES];
    [_mapview setCenterCoordinate:currentLocation.location.coordinate animated:YES];
    [_mapview removeAnnotation:fromPoint];
    fromPoint = [[MKPointAnnotation alloc] init];
//    fromPoint.coordinate = CLLocationCoordinate2DMake([DEFAULT_LAT floatValue],[DEFAULT_LONG floatValue]);
    fromPoint.coordinate = CLLocationCoordinate2DMake(currentLocation.location.coordinate.latitude,currentLocation.location.coordinate.longitude);
    [_mapview addAnnotation:fromPoint];
    [self getLocationNameWithAnnotation:fromPoint];
}

- (IBAction)onToLocation:(id)sender {
    [self.view endEditing:YES];
    [_mapview setCenterCoordinate:currentLocation.location.coordinate animated:YES];
    [_mapview removeAnnotation:toPoint];
    toPoint = [[MKPointAnnotation alloc] init];
//    toPoint.coordinate = CLLocationCoordinate2DMake([DEFAULT_LAT floatValue],[DEFAULT_LONG floatValue]);
    toPoint.coordinate = CLLocationCoordinate2DMake(currentLocation.location.coordinate.latitude,currentLocation.location.coordinate.longitude);
    [_mapview addAnnotation:toPoint];
    [self getLocationNameWithAnnotation:toPoint];
}



- (IBAction)onSelectSeat:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    gTrip.link = @"";
    for (int i=0; i<button.tag; i++) {
        gTrip.link = [NSString stringWithFormat:@"%@I",gTrip.link];
    }
    
    switch (button.tag) {
        case 1:
            self.btn1seat.layer.borderColor = [[UIColor whiteColor] CGColor];
            self.btn1seat.layer.borderWidth = 1.0;
            self.btn2seat.layer.borderColor = [[UIColor clearColor] CGColor];
            self.btn3seat.layer.borderColor = [[UIColor clearColor] CGColor];
            
            break;
        case 2:
            self.btn2seat.layer.borderColor = [[UIColor whiteColor] CGColor];
            self.btn2seat.layer.borderWidth = 1.0;
            self.btn1seat.layer.borderColor = [[UIColor clearColor] CGColor];
            self.btn3seat.layer.borderColor = [[UIColor clearColor] CGColor];
            break;
        case 3:
            self.btn3seat.layer.borderColor = [[UIColor whiteColor] CGColor];
            self.btn3seat.layer.borderWidth = 1.0;
            self.btn2seat.layer.borderColor = [[UIColor clearColor] CGColor];
            self.btn1seat.layer.borderColor = [[UIColor clearColor] CGColor];
            break;
        default:
            break;
    }
}

- (IBAction)onRefresh:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        if (fromPoint.coordinate.latitude !=0 && fromPoint.coordinate.longitude !=0) {
            [ModelManager getNumberOfCarsWithLatitude:fromPoint.coordinate.latitude Longitude:fromPoint.coordinate.longitude withSuccess:^(int num) {
                [self.imgCarsCount setImage:[Util drawText:[NSString stringWithFormat:@"%d",num] inImage:[UIImage imageNamed:@"ic_5_car_in_3000.png"] atPoint:CGPointMake(0, 0)]];
                self.imgCarsCount.contentMode = UIViewContentModeScaleAspectFit;
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            } failure:^(NSString *err) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }];
 
        }else{
            [ModelManager getNumberOfCarsWithLatitude:_locationManager.location.coordinate.latitude Longitude:_locationManager.location.coordinate.longitude withSuccess:^(int num) {
                [self.imgCarsCount setImage:[Util drawText:[NSString stringWithFormat:@"%d",num] inImage:[UIImage imageNamed:@"ic_5_car_in_3000.png"] atPoint:CGPointMake(0, 0)]];
                self.imgCarsCount.contentMode = UIViewContentModeScaleAspectFit;
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            } failure:^(NSString *err) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }];

        
        }
}




- (void)generateDataWithKey:(NSString *)key
{
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        data = [[NSMutableArray alloc]init];
        MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
        request.naturalLanguageQuery = key;
        request.region = _mapview.region;
        
        MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
        
        [search startWithCompletionHandler:^(MKLocalSearchResponse
                                             *response, NSError *error) {
            if (response.mapItems.count == 0){
                
            }
            else
                for (MKMapItem *item in response.mapItems)
                {
                    [data addObject:item];
                    if (_txtFromName.isEditing) {
                        [_txtFromName provideSuggestions];
                    }
                    else{
                        [_txtToName provideSuggestions];
                    }
                }
        }];
        
    });
}


#pragma mark MPGTextField Delegate Methods

- (NSArray *)dataForPopoverInTextField:(MPGTextField *)textField
{
    
    return data;
    
}

- (BOOL)textFieldShouldSelect:(MPGTextField *)textField
{
    return YES;
}

- (void)textField:(MPGTextField *)textField didEndEditingWithSelection:(MKMapItem *)result
{
    //A selection was made - either by the user or by the textfield. Check if its a selection from the data provided or a NEW entry.
    if ([textField isEqual:self.txtFromName]&&(result.placemark.coordinate.latitude!=0||result.placemark.coordinate.longitude!=0)) {
        [_mapview removeAnnotation:fromPoint];
        [self.txtFromName setText:result.name];
        
        fromPoint = [[MKPointAnnotation alloc] init];
        fromPoint.coordinate = CLLocationCoordinate2DMake(result.placemark.coordinate.latitude,result.placemark.coordinate.longitude);
        [_mapview addAnnotation:fromPoint];
        gTrip.startLocation = result;
        [self getLocationNameWithAnnotation:fromPoint];
        
    }
    else{
        
        if ([textField isEqual:self.txtToName]&&(result.placemark.coordinate.latitude!=0||result.placemark.coordinate.longitude!=0)) {
            [_mapview removeAnnotation:toPoint];
            [self.txtToName setText:result.name];
            toPoint = [[MKPointAnnotation alloc] init];
            toPoint.coordinate = CLLocationCoordinate2DMake(result.placemark.coordinate.latitude,result.placemark.coordinate.longitude);
            [_mapview addAnnotation:toPoint];
            gTrip.endLocation = result;
            [self getLocationNameWithAnnotation:toPoint];
        }
        
    }
    [self showDirections];
}
-(void)showDirections{
    if (fromPoint.coordinate.latitude > 0) {
        [self getNumberOfCarAroundPositon:fromPoint];
    }
    
    if (self.txtFromName.text.length>0&&self.txtToName.text.length>0) {
    
        [self zoomToDirections];
        
        MKPlacemark *placemarkFrom = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(fromPoint.coordinate.latitude, fromPoint.coordinate.longitude) addressDictionary:nil] ;
        MKMapItem *fromItem = [[MKMapItem alloc] initWithPlacemark:placemarkFrom];
        
        [fromItem setName:self.txtFromName.text];
        
        
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(toPoint.coordinate.latitude, toPoint.coordinate.longitude) addressDictionary:nil] ;
        MKMapItem *toItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [toItem setName:self.txtToName.text];
        
        
        MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
        [request setSource:fromItem];
        [request setDestination:toItem];
        [request setTransportType:MKDirectionsTransportTypeAny]; // This can be limited to automobile and walking directions.
        [request setRequestsAlternateRoutes:YES]; // Gives you several route options.
        
        MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
        [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
            if (!error) {
                if (response.routes.count > 0) {
                    MKRoute *route = [response.routes objectAtIndex:0];
                    [self removeAllPolyLine];
                    [self.mapview addOverlay:[route polyline] level:MKOverlayLevelAboveRoads];
                }
            }
        }];
    }
    else{
        if (self.txtFromName.text.length>0) {
            [self zoomStartPlace];
        }
        else if (self.txtToName.text.length>0){
            [self zoomEndPlace];
        }
    }
}
-(void)zoomToDirections{
    CLLocationCoordinate2D coord1 = {fromPoint.coordinate.latitude,fromPoint.coordinate.longitude};
    CLLocationCoordinate2D coord = {(fromPoint.coordinate.latitude+toPoint.coordinate.latitude)/2,(fromPoint.coordinate.longitude+toPoint.coordinate.longitude)/2};
    
    MKCoordinateRegion region = MKCoordinateRegionMake(coord, MKCoordinateSpanMake(fabs(coord.latitude-coord1.latitude)*6, fabs(coord.longitude-coord1.longitude)*6));
    [self.mapview setRegion:region animated:YES];
}
-(void)zoomStartPlace{
    MKCoordinateRegion mapRegion;
    mapRegion.center = fromPoint.coordinate;
    mapRegion.span.latitudeDelta = 0.01;
    mapRegion.span.longitudeDelta = 0.01;
    
    [_mapview setRegion:mapRegion animated: YES];
}
-(void)zoomEndPlace{
    MKCoordinateRegion mapRegion;
    mapRegion.center = toPoint.coordinate;
    mapRegion.span.latitudeDelta = 0.01;
    mapRegion.span.longitudeDelta = 0.01;
    
    [_mapview setRegion:mapRegion animated: YES];
}
-(void)removeAllPolyLine{
    NSArray *pointsArray = [_mapview overlays];
    
    [_mapview removeOverlays:pointsArray];
    self.btn1seat.layer.borderColor = [[UIColor clearColor] CGColor];
    self.btn2seat.layer.borderColor = [[UIColor clearColor] CGColor];
    self.btn3seat.layer.borderColor = [[UIColor clearColor] CGColor];
}
-(IBAction)onDone:(id)sender{
    if (_txtFromName.text.length==0||_txtToName.text.length==0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[Util localized:@"missing_from_point_or_endpoint_title"] delegate:nil cancelButtonTitle:[Util localized:@"title_ok"] otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if (gUser.phone.length==0) {
        [Util showMessage:[Util localized:@"msg_update_phone_number"] withTitle:[Util localized:@"app_name"]];
        return;
    }
    else if (gTrip.link.length==0) {
        [Util showMessage:[Util localized:@"msg_update_trip_link"] withTitle:[Util localized:@"app_name"]];
        return;
    }
    else {
        WaitingViewController *waitingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WaitingViewController"];
        [self.navigationController pushViewController:waitingVC animated:YES];
    }

}

@end
