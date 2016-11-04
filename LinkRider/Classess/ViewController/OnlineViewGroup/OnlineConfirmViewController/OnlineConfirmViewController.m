//
//  OnlineConfirmViewController.m
//  LinkRider
//
//  Created by hieu nguyen on 7/2/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import "OnlineConfirmViewController.h"
#import "ModelManager.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "Trips.h"
#import "UIImageView+WebCache.h"
#import "UIFont+FontAwesome.h"
@interface OnlineConfirmViewController ()

@end

@implementation OnlineConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
        [self.locationManager requestWhenInUseAuthorization];
        
    }
#endif
    
    self.locationManager.distanceFilter = UPDATE_LOCATION_DISTANCE_MODE;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    [self setNeedsStatusBarAppearanceUpdate];
//    [self getTripDetail];
    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(updateDistance) userInfo:nil repeats:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelTrip) name:DRIVER_CANCEL_TRIP_KEY object:nil];
    // Do any additional setup after loading the view.
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)onCancelTrip{
    [Util showMessage:[Util localized:@"msg_trip_cancel_by_passenger"] withTitle:[Util localized:@"app_name"]];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self.navigationController setNavigationBarHidden:YES];
    [self.locationManager startUpdatingLocation];
    [self getTripDetail];
    [self setText];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [self setText];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.locationManager stopUpdatingLocation];
    [timer invalidate];
}
-(void)getTripDetail{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [ModelManager showMyTripsWithSuccess:^(NSMutableArray *arr) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            for (Trips *t in arr) {
                if ([t.status isEqualToString:TRIP_STATUS_APPROACHING]||[t.status isEqualToString:TRIP_STATUS_IN_PROGRESS]) {
                    gTrip = t;
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [ModelManager showTripDetailWithTripId:gTrip.tripId withSuccess:^(Trips *trip) {
                        gTrip = trip;
                        [Util setObject:gTrip.tripId forKey:DRIVER_CURRENT_TRIP_ID_KEY];
                        [self setData];
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    } andFailure:^(NSString *err) {
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    }];
                    return;
                }
            }
            
        } andFailure:^(NSString *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
        
//    });
}
- (void)setText{
    
    _lblRateValue.backgroundColor  = [UIColor clearColor];
    _lblRateValue.starImage = [[UIImage imageNamed:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _lblRateValue.starHighlightedImage = [[UIImage imageNamed:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_lblRateValue setMaxRating:5.0];
    [_lblRateValue setDelegate:self];
    [_lblRateValue setHorizontalMargin:1.0];
    [_lblRateValue setEditable:NO];
    [_lblRateValue setDisplayMode:EDStarRatingDisplayHalf];
    [_lblRateValue setRating:[gTrip.passenger.passenger_rating_count floatValue]];
    [_lblRateValue setNeedsDisplay];
    
    [self.btnArrived setTitle:[Util localized:@"arrived_title"] forState:UIControlStateNormal];
    
    
    
    [self.btnCancelTrip setTitle:[NSString fontAwesomeIconStringForEnum:FALongArrowLeft] forState:UIControlStateNormal];
    NSDictionary *fontDict = @{NSFontAttributeName:[UIFont fontAwesomeFontOfSize:10],NSForegroundColorAttributeName:[Util colorWithHexString:@"#e8c03a"]};
    
    
    
    
    NSMutableAttributedString *att =  [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[NSString fontAwesomeIconStringForEnum:FACircle]] attributes: fontDict];
    
    [att appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[NSString fontAwesomeIconStringForEnum:FACircle]] attributes: fontDict]];
    
    NSDictionary *arialDict = [NSDictionary dictionaryWithObject: STEP_TITLE_FONT forKey:NSFontAttributeName];
    NSMutableAttributedString *aAttrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[Util localized:@"arriving_title"]] attributes: arialDict];
    
    [att appendAttributedString:aAttrString];
    
    for(int i=0;i<3;i++){
        
        NSMutableAttributedString *aAttrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[NSString fontAwesomeIconStringForEnum:FACircleO]] attributes: fontDict];
        [att appendAttributedString:aAttrString];
    }
    self.titleLbl.attributedText =att;
    
    
    self.lblFromName.font = self.lblSeatNum.font;
    self.lblToName.font = self.lblSeatNum.font;
    self.lblFromName.textColor = [UIColor whiteColor];
    self.lblToName.textColor = [UIColor whiteColor];
    
    
    self.lblSeats.text = [Util localized:@"lbl_seats"];
    self.lblFromA.text = [Util localized:@"lbl_from_a"];
    self.lblToB.text = [Util localized:@"lbl_to_b"];
    if ([gTrip.link isEqualToString:@"I"]) {
        self.lblSeatNum.text = @"1";
    }
    if ([gTrip.link isEqualToString:@"II"]) {
        self.lblSeatNum.text = @"2";
    }
    if ([gTrip.link isEqualToString:@"III"]) {
        self.lblSeatNum.text = @"3";
    }
    
    self.lblFromName.text = gTrip.startLocation.name;
    self.lblToName.text = gTrip.endLocation.name;

    
}
-(void)setData{
    self.lblPassengerName.text = gTrip.passenger.name;
    self.lblPhoneValue.text = gTrip.passenger.phone;
    self.lblFromName.text = gTrip.startLocation.name;
    self.lblToName.text = gTrip.endLocation.name;
    self.lblDistanceValue.text = [NSString stringWithFormat:@"%@",[Util localized:@"you_are_coming_to_passenger_in"]];
    self.lblRateValue.rating = [gTrip.passenger.passenger_rating_count floatValue]/2;
    [self.imgAvatar setImageWithURL:[NSURL URLWithString:gTrip.passenger.thumb]];

}
-(void)updateDistance{
    if (self) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [ModelManager updateDistancewithSuccess:^(float distance) {
                if (distance>0) {
                    NSLog(@"nslog did update distance: %f.5", distance);
                    self.lblDistanceValue.text = [NSString stringWithFormat:@"%@ %.3f km",[Util localized:@"you_are_coming_to_passenger_in"],distance];
                    //                self.lblDistanceValue.text = [NSString stringWithFormat:@"%.3f",distance];
                }
            } failure:^(NSString *err) {
                
            }];
        });
    }

}
- (IBAction)onArrived:(id)sender {
    [self performSegueWithIdentifier:@"onArrived" sender:self];
}

- (IBAction)onCancelTrip:(id)sender {
//    [Util showMessage:[Util localized:@"msg_confirm_cancel_request"] withTitle:[Util localized:@"app_name"]  andDelegate:self];
//    [Util setObject:@"" forKey:CURRENT_TRIP_ID_KEY];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self cancelTrip];

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(cancelTrip) userInfo:nil repeats:NO];
    }
    else{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }
}
-(void)cancelTrip{
    [ModelManager cancelTrip:gTrip withSuccess:^{
       [[NSNotificationCenter defaultCenter] postNotificationName:@"resetAllPoint" object:nil userInfo:notificationsDic];
        [self.view makeToast:[Util localized:@"msg_cancel_success"]];
        gTrip = [[Trips alloc]init];
        [Util setObject:@"" forKey:DRIVER_CURRENT_TRIP_ID_KEY];
         [self.navigationController popToRootViewControllerAnimated:YES];
    } andFailure:^(NSString *err) {
        [self.view makeToast:[Util localized:@"msg_cancel_failed"]];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];

}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
     NSLog(@"did update locationsssssssss");
    CLLocation *location = [locations lastObject];
    if (currentLocation != location) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [ModelManager updateCoordinatewithLat:location.coordinate.latitude andLong:location.coordinate.longitude withSuccess:^{
                currentLocation = location;
            } failure:^(NSString *err) {
                
            }];
        });
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    NSLog(@"did update location");
}


@end
