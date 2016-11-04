//
//  OnlineViewController.m
//  LinkRider
//
//  Created by hieu nguyen on 7/2/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import "OnlineViewController.h"
#import "ModelManager.h"
#import "MBProgressHUD.h"
#import "OnlineStartTripViewController.h"
#import "OnlineConfirmViewController.h"
#import "UIFont+FontAwesome.h"
#import "NSString+FontAwesome.h"
#import "RattingPassengerViewController.h"
@interface OnlineViewController ()

@end

@implementation OnlineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveRequest) name:DRIVER_RECEIVE_REQUEST_KEY object:nil];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillBecomForceGround) name:WILL_ENTER_FORCE_GROUND object:nil];
    [self showMyTrip];
}
- (void)appWillBecomForceGround{
    
    if (self) {
        [self onReceiveRequest];
    }
    
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self setText];
    self.navigationController.navigationBarHidden = YES;
    [self.locationManager startUpdatingLocation];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
}
- (void)viewWillDisappear:(BOOL)animated{
    [self.locationManager stopUpdatingLocation];
}

-(void)showMyTrip{
//    
//    NSString *currentTrip = [Util objectForKey:DRIVER_CURRENT_TRIP_ID_KEY];
//    if (currentTrip.length>0) {
//        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        [ModelManager showTripDetailWithTripId:currentTrip withSuccess:^(Trips *t) {
//            gTrip = t;
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            if ([t.status isEqualToString:TRIP_STATUS_APPROACHING]) {
//                OnlineConfirmViewController *online = [self.storyboard instantiateViewControllerWithIdentifier:@"OnlineConfirmViewController"];
//                [self.navigationController pushViewController:online animated:YES];
//            }
//            else if ([t.status isEqualToString:TRIP_STATUS_IN_PROGRESS]){
//                OnlineStartTripViewController *online = [self.storyboard instantiateViewControllerWithIdentifier:@"OnlineStartTripViewController"];
//                [self.navigationController pushViewController:online animated:YES];
//            }
//            else if ([t.status isEqualToString:TRIP_STATUS_PENDING_PAYMENT]){
//                RattingPassengerViewController *rate = [self.storyboard instantiateViewControllerWithIdentifier:@"RattingPassengerViewController"];
//                [self.navigationController pushViewController:rate animated:YES];
//            }
//            
//        } andFailure:^(NSString *err) {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//        }];
//        //        });
//    }
//    else{
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [ModelManager showMyTripsWithSuccess:^(NSMutableArray *arr) {
            
            for (Trips *t in arr) {
                gTrip = t;
                if ([t.status isEqualToString:TRIP_STATUS_APPROACHING]) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    OnlineConfirmViewController *online = [self.storyboard instantiateViewControllerWithIdentifier:@"OnlineConfirmViewController"];
                    [self.navigationController pushViewController:online animated:YES];
                    
                }
                else if ([t.status isEqualToString:TRIP_STATUS_IN_PROGRESS]){
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    OnlineStartTripViewController *online = [self.storyboard instantiateViewControllerWithIdentifier:@"OnlineStartTripViewController"];
                    [self.navigationController pushViewController:online animated:YES];
                }
                else if ([t.status isEqualToString:TRIP_STATUS_PENDING_PAYMENT]){
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    RattingPassengerViewController *rate = [self.storyboard instantiateViewControllerWithIdentifier:@"RattingPassengerViewController"];
                    [self.navigationController pushViewController:rate animated:YES];
                }
                
            }
            [ModelManager showMyRequestWithSuccess:^(NSMutableArray *arr) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if (arr.count>0) {
                     gTrip = [arr objectAtIndex:0];
                    [self onReceiveRequest];
                    return;
                }
            } andFailure:^(NSString *err) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }];

        } andFailure:^(NSString *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
        //        });
//    }
}
-(void)setText{
    [self.lblHeaderTitle setTitle:[Util localized:@"header_online"]];
    
    SWRevealViewController *revealViewController = self.revealViewController;

    if ( revealViewController )
    {
        [self.btnMenu addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        //        [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
    
    [self.btnMenu setTitle:@"\uf0c9" forState:UIControlStateNormal];
    
    
    if ([gUser.is_online boolValue]) {
        self.lblDesc.text = [Util localized:@"msg_online_desc"];
        [self.btnOnline setTitle:[Util localized:@"status_offline"] forState:UIControlStateNormal];
    }
    else{
        self.lblDesc.text = [Util localized:@"msg_offline_desc"];
        [self.btnOnline setTitle:[Util localized:@"status_online"] forState:UIControlStateNormal];
        
    }
    
    self.btnMenu.hidden = [[gUser is_online] boolValue];
    
    
    [self.btnOnline.layer setBorderColor: [UIColor whiteColor].CGColor];
    [self.btnOnline.layer setBorderWidth:1.0f];
    [self setupAttributeTitleForOfflineMode];
    
}
-(void)setupAttributeTitleForOnlineMode{
    
    NSDictionary *fontDict = @{NSFontAttributeName:[UIFont fontAwesomeFontOfSize:8],NSForegroundColorAttributeName:[Util colorWithHexString:@"#e8c03a"]};
    
    NSMutableAttributedString *att =  [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[NSString fontAwesomeIconStringForEnum:FACircle]] attributes: fontDict];
    NSDictionary *arialDict = [NSDictionary dictionaryWithObject:STEP_TITLE_FONT forKey:NSFontAttributeName];
    NSMutableAttributedString *aAttrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[Util localized:@"request_link_title"]] attributes: arialDict];
    
    [att appendAttributedString:aAttrString];
    
    for(int i=0;i<4;i++){
        
        NSMutableAttributedString *aAttrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[NSString fontAwesomeIconStringForEnum:FACircleO]] attributes: fontDict];
        [att appendAttributedString:aAttrString];
    }
    self.lblRequest.attributedText =att;
}

-(void)setupAttributeTitleForOfflineMode{
    
    NSDictionary *fontDict = @{NSFontAttributeName:[UIFont fontAwesomeFontOfSize:8],NSForegroundColorAttributeName:[Util colorWithHexString:@"#e8c03a"]};
    NSDictionary *arialDict = [NSDictionary dictionaryWithObject:STEP_TITLE_FONT forKey:NSFontAttributeName];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[Util localized:@"request_link_title"]] attributes: arialDict];
    
    for(int i=0;i<5;i++){
        
        NSMutableAttributedString *aAttrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[NSString fontAwesomeIconStringForEnum:FACircleO]] attributes: fontDict];
        [att appendAttributedString:aAttrString];
    }
    self.lblRequest.attributedText =att;
}

- (void)onReceiveRequest {
    if (self) {
        UIViewController* actualVC = [self.navigationController.viewControllers lastObject];
        if (![actualVC isKindOfClass:[ListPassengerViewController class]]) {
            [self performSegueWithIdentifier:@"onSelect" sender:self];
        }
    }
    
    
}
- (IBAction)onSelectOnlineOrOffline:(id)sender {
    if ([gUser.is_online boolValue]) {
        [Util showMessage:[Util localized:@"msg_confirm_offline"] withTitle:[Util localized:@"app_name"] cancelButtonTitle:[Util localized:@"title_cancel"] otherButtonTitles:[Util localized:@"title_ok"] delegate:self andTag:1];
    }
    else{
        [self onChangeStatus];
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [self onChangeStatus];
    }
}

- (void)updateStatus{
    [ModelManager setDriverOnline:[gUser.is_online boolValue] withSuccess:^{
        
    } andFailure:^(NSString *err) {
        
    }];
}
-(void)onChangeStatus{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) , ^{
    [ModelManager setDriverOnline:![gUser.is_online boolValue] withSuccess:^{
        [ModelManager getUserProfileWithSuccess:^{
                self.btnMenu.hidden = [gUser.is_online boolValue];
        if ([gUser.is_online boolValue]) {
            self.lblDesc.text = [Util localized:@"msg_online_desc"];
            [self.btnOnline setTitle:[Util localized:@"status_offline"] forState:UIControlStateNormal];
            [self setupAttributeTitleForOnlineMode];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
        else{
            self.lblDesc.text = [Util localized:@"msg_offline_desc"];
            [self.btnOnline setTitle:[Util localized:@"status_online"] forState:UIControlStateNormal];
            [self setupAttributeTitleForOfflineMode];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
        
                    } failure:^(NSString *err) {
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    }];
        
        
    } andFailure:^(NSString *err) {
        if (err.length>0) {
            [Util showMessage:err withTitle:[Util localized:@"app_name"]];
        }
        else{
            [Util showMessage:[Util localized:@"msg_technical_error"] withTitle:[Util localized:@"app_name"]];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    //    });
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    NSLog(@"did update locationsssssssss");
    CLLocation *location = [locations lastObject];
    //    if (currentLocation != location) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [ModelManager updateCoordinatewithLat:location.coordinate.latitude andLong:location.coordinate.longitude withSuccess:^{
            currentLocation = location;
            gUser.lattitude = [ NSString stringWithFormat:@"%.5f", currentLocation.coordinate.latitude];
            gUser.logitude = [ NSString stringWithFormat:@"%.5f", currentLocation.coordinate.longitude];
            [Util saveUser:gUser];
        } failure:^(NSString *err) {
            
        }];
    });
    //    }
    
}

@end
