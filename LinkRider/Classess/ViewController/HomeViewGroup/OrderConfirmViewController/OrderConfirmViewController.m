//
//  OrderConfirmViewController.m
//  LinkRider
//
//  Created by hieu nguyen on 6/26/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import "OrderConfirmViewController.h"
#import "ModelManager.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "UIImageView+WebCache.h"
#import "UIFont+FontAwesome.h"
#import "NSString+FontAwesome.h"
@interface OrderConfirmViewController ()

@end

@implementation OrderConfirmViewController
@synthesize lblRateValue=_lblRateValue;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onCall)];
    [_lblPhoneValue setUserInteractionEnabled:YES];
    [_lblPhoneValue addGestureRecognizer:tap];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelTrip) name:CANCEL_TRIP_KEY object:nil];
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

    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(updateDistance) userInfo:nil repeats:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onStartTrip) name:START_TRIP_KEY object:nil];
    // Do any additional setup after loading the view.
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillBecomForceGround) name:WILL_ENTER_FORCE_GROUND object:nil];
}
- (void)appWillBecomForceGround{
    
    if (self) {
        [self getTripDetail];
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //    [self.navigationItem setHidesBackButton:YES animated:YES];
    _btnCancelTrip.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES];
  
    [self getTripDetail];
    //    }
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.locationManager stopUpdatingLocation];
    [timer invalidate];

}

-(void)getTripDetail{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [ModelManager showMyTripsWithSuccess:^(NSMutableArray *arr) {
            dispatch_async(dispatch_get_main_queue(), ^{
                for (Trips *trip in arr) {
                    if ([trip.status isEqualToString:TRIP_STATUS_APPROACHING]||[trip.status isEqualToString:TRIP_STATUS_IN_PROGRESS]||[trip.status isEqualToString:TRIP_STATUS_PENDING_PAYMENT]) {
                        
                        gTrip = trip;
                        if ([trip.status isEqualToString:TRIP_STATUS_APPROACHING]) {
                            [self setText];
                            return;
                        }
                        else if([trip.status isEqualToString:TRIP_STATUS_IN_PROGRESS]){
                            
                            [self onStartTrip];
                            
                            return;
                            
                        }
                        
                    }
                    
                } });
            
        } andFailure:^(NSString *err) {
            
        }];
    });

    
//    
//    
//    
//    
//    
//    
//    if (gTrip.tripId.length>0) {
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
////        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//            [ModelManager showTripDetailWithTripId:gTrip.tripId withSuccess:^(Trips *trip) {
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                gTrip = trip;
//                [Util setObject:gTrip.tripId forKey:CURRENT_TRIP_ID_KEY];
//                if ([gTrip.status isEqualToString:TRIP_STATUS_IN_PROGRESS]) {
//                    [self onStartTrip];
//                    return ;
//                }
//                [self setText];
//                
//                notificationsDic = nil;
//            } andFailure:^(NSString *err) {
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            }];
////        });
//    }
//    else{
//        NSDictionary *alert = [[notificationsDic objectForKey:@"aps"] objectForKey:@"alert"];
//        if ([alert isKindOfClass:[NSDictionary class]]) {
//            NSDictionary *data = [alert objectForKey:@"data"];
//            if ([data isKindOfClass:[NSDictionary class]]) {
//                NSString *tripId = [data objectForKey:@"tripId"];
//                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
////                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//                    [ModelManager showTripDetailWithTripId:tripId withSuccess:^(Trips *trip) {
//                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                        gTrip = trip;
//                        [Util setObject:gTrip.tripId forKey:CURRENT_TRIP_ID_KEY];
//                        if ([gTrip.status isEqualToString:TRIP_STATUS_IN_PROGRESS]) {
//                            [self onStartTrip];
//                            return ;
//                        }
//                        [self setText];
//                        
//                        notificationsDic = nil;
//                    } andFailure:^(NSString *err) {
//                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                    }];
////                });
//            }
//        }
//    }
    
}
-(void)updateDistance{
    if (gTrip.tripId.length > 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [ModelManager updateDistancewithSuccess:^(float distance) {
                if (self) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (distance>0) {
                            NSLog(@"distance: %f", distance);
                            self.lblDistanceValue.text = [NSString stringWithFormat:@"%@ %.3fkm",[Util localized:@"order_confirm_title"],distance];
                        }
                    });
                }
                
            } failure:^(NSString *err) {
                
            }];
        });

    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)onCancelTrip{
    [Util showMessage:[Util localized:@"msg_trip_cancel_by_driver"] withTitle:[Util localized:@"app_name"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resetAllPoint" object:nil userInfo:notificationsDic];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)onStartTrip{

    [self performSegueWithIdentifier:@"startTrip" sender:self];

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
    [_lblRateValue setRating:[gTrip.driver.driverRateCount floatValue]/2];
    [_lblRateValue setNeedsDisplay];
    
    self.lblDistanceValue.text = [NSString stringWithFormat:@"%@",[Util localized:@"order_confirm_title"]];

    self.lblNameValue.text = gTrip.driver.driverName;
    self.lblPhoneValue.text = gTrip.driver.phone;

[self.btnCancelTrip setTitle:[NSString fontAwesomeIconStringForEnum:FALongArrowLeft] forState:UIControlStateNormal];
    NSDictionary *fontDict = @{NSFontAttributeName:[UIFont fontAwesomeFontOfSize:10],NSForegroundColorAttributeName:[Util colorWithHexString:@"#e8c03a"]};
    NSMutableAttributedString *att =  [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[NSString fontAwesomeIconStringForEnum:FACircle]] attributes: fontDict];
    
    [att appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[NSString fontAwesomeIconStringForEnum:FACircle]] attributes: fontDict]];
    
    NSDictionary *arialDict = [NSDictionary dictionaryWithObject:STEP_TITLE_FONT forKey:NSFontAttributeName];
    NSMutableAttributedString *aAttrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[Util localized:@"arriving_title"]] attributes: arialDict];
    
    [att appendAttributedString:aAttrString];
    
    for(int i=0;i<3;i++){
        
        NSMutableAttributedString *aAttrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[NSString fontAwesomeIconStringForEnum:FACircleO]] attributes: fontDict];
        [att appendAttributedString:aAttrString];
    }
    self.lblArriving.attributedText =att;


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
    self.lblCarePlateValue.text = gTrip.driver.carPlate;
    [self.carImg setImageWithURL:[NSURL URLWithString:gTrip.driver.carImage]];
    [self.driverImg setImageWithURL:[NSURL URLWithString:gTrip.driver.imageDriver] placeholderImage:HOLDER_AVATAR];
    self.lblCar.text = [Util localized:@"lbl_car"];

}
-(void)onCall{
    [Util callPhoneNumber:gUser.phone];
}
- (IBAction)onCancelTrip:(id)sender {
//    [Util showMessage:[Util localized:@"msg_confirm_cancel_request"] withTitle:[Util localized:@"app_name"]  andDelegate:self];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [ModelManager cancelTrip:gTrip withSuccess:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"resetAllPoint" object:nil userInfo:notificationsDic];
            
            [Util showMessage:[Util localized:@"msg_cancel_success"] withTitle:[Util localized:@"app_name"]];
            
            gTrip = [[Trips alloc]init];
            [Util setObject:@"" forKey:CURRENT_TRIP_ID_KEY];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } andFailure:^(NSString *err) {
            if (err.length==0) {
                [Util showMessage:[Util localized:@"msg_cancel_failed"] withTitle:[Util localized:@"app_name"]];
            }
            else{
                [Util showMessage:err withTitle:[Util localized:@"app_name"]];
            }
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
//    });
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [ModelManager cancelTrip:gTrip withSuccess:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"resetAllPoint" object:nil userInfo:notificationsDic];
                
                [Util showMessage:[Util localized:@"msg_cancel_success"] withTitle:[Util localized:@"app_name"]];
                gTrip = [[Trips alloc]init];
                [Util setObject:@"" forKey:CURRENT_TRIP_ID_KEY];
                [self.navigationController popToRootViewControllerAnimated:YES];
            } andFailure:^(NSString *err) {
                if (err.length==0) {
                    [self.view makeToast:[Util localized:@"msg_cancel_failed"]];
                }
                [self.view makeToast:err];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }];
        });
    }
    else{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }
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

@end
