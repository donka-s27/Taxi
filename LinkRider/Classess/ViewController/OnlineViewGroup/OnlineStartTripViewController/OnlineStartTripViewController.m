//
//  OnlineStartTripViewController.m
//  LinkRider
//
//  Created by hieu nguyen on 7/2/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import "OnlineStartTripViewController.h"
#import "ModelManager.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "Trips.h"
#import "UIImageView+WebCache.h"
#import "ShowDistanceViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "UIFont+FontAwesome.h"
@interface OnlineStartTripViewController ()<ShowDistanceViewControllerDelegate>

@end

@implementation OnlineStartTripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    if ([gTrip.status isEqualToString:TRIP_STATUS_IN_PROGRESS]) {
        [Util removeObjectForKey:[NSString stringWithFormat:@"tripDistance%@",gTrip.tripId]];
        [self startTripTracking];
    }
    NSString *status = [Util objectForKey:@"tripIsEnd"];
    if ([status isEqualToString:gTrip.tripId]) {
        [self performSegueWithIdentifier:@"endTrip" sender:self];
    }
    // Do any additional setup after loading the view.
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
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self.navigationController setNavigationBarHidden:YES];
    keyboard = [[UIKeyboardViewController alloc]initWithControllerDelegate:self];
    [keyboard addToolbarToKeyboard];
    [self setText];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationItem setHidesBackButton:NO animated:YES];
    
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
    [_lblRateValue setRating:[gTrip.passenger.passenger_rating_count floatValue]/2];
    [_lblRateValue setNeedsDisplay];
    
    [self.btnCancelTrip setTitle:[NSString fontAwesomeIconStringForEnum:FALongArrowLeft] forState:UIControlStateNormal];
    NSDictionary *fontDict = @{NSFontAttributeName:[UIFont fontAwesomeFontOfSize:10],NSForegroundColorAttributeName:[Util colorWithHexString:@"#e8c03a"]};
    
    NSMutableAttributedString *att =  [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[NSString fontAwesomeIconStringForEnum:FACircle]] attributes: fontDict];
    
    [att appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[NSString fontAwesomeIconStringForEnum:FACircle]] attributes: fontDict]];
    [att appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[NSString fontAwesomeIconStringForEnum:FACircle]] attributes: fontDict]];
    
    NSDictionary *arialDict = [NSDictionary dictionaryWithObject: STEP_TITLE_FONT forKey:NSFontAttributeName];
    NSMutableAttributedString *aAttrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[Util localized:@"arrived_title"]] attributes: arialDict];
    
    [att appendAttributedString:aAttrString];
    
    for(int i=0;i<2;i++){
        
        NSMutableAttributedString *aAttrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[NSString fontAwesomeIconStringForEnum:FACircleO]] attributes: fontDict];
        [att appendAttributedString:aAttrString];
    }
    self.titleLbl.attributedText =att;
    
    
    self.lblFromName.font = self.lblSeatNum.font;
    self.lblToName.font = self.lblSeatNum.font;
    self.lblFromName.textColor = [UIColor whiteColor];
    self.lblToName.textColor = [UIColor whiteColor];
    self.lblDistanceValue.text = [Util localized:@"lbl_you_have_arrived"];
    
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
    [self.imgAvatar setImageWithURL:[NSURL URLWithString:gTrip.passenger.thumb]];
    self.lblPassengerName.text = gTrip.passenger.name;
    self.lblPhoneValue.text = gTrip.passenger.phone;
    [self.btnStart setTitle:[Util localized:@"lbl_begin_trip"] forState:UIControlStateNormal];
    if ([gTrip.status isEqualToString:TRIP_STATUS_IN_PROGRESS]) {
        [self.btnStart setTitle:[Util localized:@"lbl_end_trip"] forState:UIControlStateNormal];
        self.lblDistanceValue.text = [Util localized:@"lbl_you_driving"];
    }
}


- (IBAction)onBeginTrip:(id)sender {
    if (![gTrip.status isEqualToString:TRIP_STATUS_IN_PROGRESS]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [ModelManager driverStartTripWithTriId:gTrip.tripId withSuccess:^{
                gTrip.status = TRIP_STATUS_IN_PROGRESS;
                [self startTripTracking];
                [self.btnStart setTitle:[Util localized:@"lbl_end_trip"] forState:UIControlStateNormal];
                self.lblDistanceValue.text = [Util localized:@"lbl_you_driving"];
                self.btnCancelTrip.hidden = YES;
            
                NSDictionary *fontDict = @{NSFontAttributeName:[UIFont fontAwesomeFontOfSize:10],NSForegroundColorAttributeName:[Util colorWithHexString:@"#e8c03a"]};
                
                NSMutableAttributedString *att =  [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[NSString fontAwesomeIconStringForEnum:FACircle]] attributes: fontDict];
                
                [att appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[NSString fontAwesomeIconStringForEnum:FACircle]] attributes: fontDict]];
                [att appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[NSString fontAwesomeIconStringForEnum:FACircle]] attributes: fontDict]];
                
                NSDictionary *arialDict = [NSDictionary dictionaryWithObject: STEP_TITLE_FONT forKey:NSFontAttributeName];
                NSMutableAttributedString *aAttrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[Util localized:@"driving_title"]] attributes: arialDict];
                
                [att appendAttributedString:aAttrString];
                
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            } failure:^(NSString *err) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }];
      
    }
    else{
        [self onAddDistance:sender];
    }
    
}
-(void)startTripTracking{
    [PSLocationManager sharedLocationManager].delegate = self;
    
    [[PSLocationManager sharedLocationManager] prepLocationUpdates];
    [[PSLocationManager sharedLocationManager] startLocationUpdates];
    
}
- (IBAction)onAddDistance:(id)sender {
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    imgView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    [self.view addSubview:imgView];
    ShowDistanceViewController *dVC = [[ShowDistanceViewController alloc]initWithNibName:@"ShowDistanceViewController" bundle:nil];
    dVC.delegate = self;
    dVC.view.center = self.view.center;
    [self.view addSubview:dVC.view];
}
-(void)onGotoPayment{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        float distance = [[Util objectForKey:[NSString stringWithFormat:@"tripDistance%@",gTrip.tripId]] floatValue];
        [ModelManager driverEndTripWithTriId:gTrip.tripId andDistance:[NSString stringWithFormat:@"%.2f",distance/1000] withSuccess:^{
            [Util setObject:gTrip.tripId forKey:@"tripIsEnd"];
            [[PSLocationManager sharedLocationManager] startLocationUpdates];
            [self performSegueWithIdentifier:@"endTrip" sender:self];
            [Util removeObjectForKey:[NSString stringWithFormat:@"tripDistance%@",gTrip.tripId]];
//            [Util removeObjectForKey:[NSString stringWithFormat:@"lastTripDistance%@",gTrip.tripId]];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        } failure:^(NSString *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.view makeToast:err];
        }];
 

}

#pragma mark PSLocationManagerDelegate

- (void)locationManager:(PSLocationManager *)locationManager signalStrengthChanged:(PSLocationManagerGPSSignalStrength)signalStrength {

    
}

- (void)locationManagerSignalConsistentlyWeak:(PSLocationManager *)locationManager {
    
}

- (void)locationManager:(PSLocationManager *)locationManager distanceUpdated:(CLLocationDistance)distance {

    [Util setObject:[NSString stringWithFormat:@"%f",distance] forKey:[NSString stringWithFormat:@"tripDistance%@",gTrip.tripId]];
    NSLog(@"distance updated: %f",distance/1000);
//    [self.view makeToast:[NSString stringWithFormat:@"%f",distance] duration:3.0 position:CSToastPositionCenter];

//    self.lblPhoneValue.text = [NSString stringWithFormat:@"%.2f", 20.0];
    
    
}

- (void)locationManager:(PSLocationManager *)locationManager error:(NSError *)error {
    
}


- (IBAction)onCancelTrip:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
@end
