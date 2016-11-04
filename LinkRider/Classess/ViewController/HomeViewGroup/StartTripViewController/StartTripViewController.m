//
//  StartTripViewController.m
//  LinkRider
//
//  Created by hieu nguyen on 6/26/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import "StartTripViewController.h"
#import "ModelManager.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "UIImageView+WebCache.h"
#import "NSString+FontAwesome.h"
#import "UIFont+FontAwesome.h"
@interface StartTripViewController ()

@end

@implementation StartTripViewController{
    BOOL isEnd;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isEnd = false;
    [self setNeedsStatusBarAppearanceUpdate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEndTrip) name:END_TRIP_KEY object:nil];
    // Do any additional setup after loading the view.
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillBecomForceGround) name:WILL_ENTER_FORCE_GROUND object:nil];
}
- (void)appWillBecomForceGround{
    
    if (self) {
        if (!isEnd){
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [ModelManager showTripDetailWithTripId:gTrip.tripId withSuccess:^(Trips *trip) {
                    gTrip = trip;
                    [Util setObject:gTrip.tripId forKey:CURRENT_TRIP_ID_KEY];
                    if ([gTrip.status isEqualToString:TRIP_STATUS_PENDING_PAYMENT]) {
                        [self onEndTrip];
                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    }else{
                        [self setText];
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    }
                
            } andFailure:^(NSString *err) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }];

        }
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
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self.navigationController setNavigationBarHidden:YES];
 
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    [ModelManager showTripDetailWithTripId:gTrip.tripId withSuccess:^(Trips *trip) {
        dispatch_async(dispatch_get_main_queue(), ^{
            gTrip = trip;
            [Util setObject:gTrip.tripId forKey:CURRENT_TRIP_ID_KEY];
            if ([gTrip.status isEqualToString:TRIP_STATUS_PENDING_PAYMENT]) {
                [self onEndTrip];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }else{
                [self setText];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }
        });
        
    } andFailure:^(NSString *err) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    //    });
    notificationsDic = nil;
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationItem setHidesBackButton:NO animated:YES];

}
-(void)viewDidLayoutSubviews{
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.btnCancelTrip.frame.size.height + self.btnCancelTrip.frame.origin.y + 20);
}
- (void)setText{
    [self.lblHeaderTitle setTitle:[Util localized:@"header_start_trip_now"]];
    
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
    
    self.lblNameValue.text = gTrip.driver.driverName;
    self.lblPhoneValue.text = gTrip.driver.phone;
    
    [self.btnCancelTrip setTitle:[Util localized:@"lbl_in_process"].uppercaseString forState:UIControlStateNormal];
    
    
    NSDictionary *fontDict = @{NSFontAttributeName:[UIFont fontAwesomeFontOfSize:10],NSForegroundColorAttributeName:[Util colorWithHexString:@"#e8c03a"]};
    NSMutableAttributedString *att =  [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[NSString fontAwesomeIconStringForEnum:FACircle]] attributes: fontDict];
    
    [att appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[NSString fontAwesomeIconStringForEnum:FACircle]] attributes: fontDict]];
    
    [att appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[NSString fontAwesomeIconStringForEnum:FACircle]] attributes: fontDict]];
    
    NSDictionary *arialDict = [NSDictionary dictionaryWithObject: self.lblArriving.font forKey:NSFontAttributeName];
    NSMutableAttributedString *aAttrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[Util localized:@"driving_title"]] attributes: arialDict];
    
    [att appendAttributedString:aAttrString];
    
    for(int i=0;i<2;i++){
        
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
    self.lblCar.text = [Util localized:@"lbl_car"];
    self.lblCarePlateValue.text = gTrip.driver.carPlate;
    [self.carImg setImageWithURL:[NSURL URLWithString:gTrip.driver.carImage]];
    [self.driverImg setImageWithURL:[NSURL URLWithString:gTrip.driver.imageDriver] placeholderImage:HOLDER_AVATAR];
    self.lblDistanceValue.text = [Util localized:@"lbl_driver_arrived"];
}

-(void)onEndTrip{
    if (isEnd) {
        return;
    }
    isEnd = true;
    NSDictionary *fontDict = @{NSFontAttributeName:[UIFont fontAwesomeFontOfSize:8],NSForegroundColorAttributeName:[Util colorWithHexString:@"#e8c03a"]};
    
    NSMutableAttributedString *att =  [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[NSString fontAwesomeIconStringForEnum:FACircle]] attributes: fontDict];
    
    [att appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[NSString fontAwesomeIconStringForEnum:FACircle]] attributes: fontDict]];
    
    [att appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[NSString fontAwesomeIconStringForEnum:FACircle]] attributes: fontDict]];
    
    [att appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[NSString fontAwesomeIconStringForEnum:FACircle]] attributes: fontDict]];
    
    NSDictionary *arialDict = [NSDictionary dictionaryWithObject: STEP_TITLE_FONT forKey:NSFontAttributeName];
    NSMutableAttributedString *aAttrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[Util localized:@"finished_title"]] attributes: arialDict];
    
    [att appendAttributedString:aAttrString];
    

    [att appendAttributedString: [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[NSString fontAwesomeIconStringForEnum:FACircleO]] attributes: fontDict]];

    self.lblArriving.attributedText =att;
    [self.btnCancelTrip setTitle:[Util localized:@"lbl_end"].uppercaseString forState:UIControlStateNormal];
    [self.btnCancelTrip addTarget:self action:@selector(endTrip) forControlEvents:UIControlEventTouchUpInside];
    [Util showMessage:[Util localized:@"msg_your_trip_finished"] withTitle:[Util localized:@"app_name"]];
}

- (void)endTrip{
[self performSegueWithIdentifier:@"endTrip" sender:self];
}

@end
