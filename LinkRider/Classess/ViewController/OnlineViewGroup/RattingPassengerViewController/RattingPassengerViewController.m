//
//  RattingPassengerViewController.m
//  LinkRider
//
//  Created by hieu nguyen on 7/2/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import "RattingPassengerViewController.h"
#import "ModelManager.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "Trips.h"
#import "UIFont+FontAwesome.h"
#import "UIImageView+WebCache.h"
@interface RattingPassengerViewController ()

@end

@implementation RattingPassengerViewController

- (void)viewDidLoad {
    [super viewDidLoad];// Do any additional setup after loading the view.
    [self setNeedsStatusBarAppearanceUpdate];
    [self getGeneralSetting];

    [self showTripDetail];
    

//    if (self.view.bounds.size.height<568) {
//        self.ratingStar.frame = [Util viewUp:self.ratingStar Up:40];
//        self.btnSend.frame = [Util viewUp:self.btnSend Up:50];
//    }

}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self.navigationController setNavigationBarHidden:YES];
    [self setText];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationItem setHidesBackButton:NO animated:YES];
    
}
-(void)getGeneralSetting{
    
}
-(void)setText{
    [self.lblHeaderTitle setTitle:[Util localized:@"header_your_trip"]];

    self.lblDistanceValue.text = [Util localized:@"lbl_trip_finished"];
    
    _lblRateValue.backgroundColor  = [UIColor clearColor];
    _lblRateValue.starImage = [[UIImage imageNamed:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _lblRateValue.starHighlightedImage = [[UIImage imageNamed:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_lblRateValue setMaxRating:5.0];
    [_lblRateValue setDelegate:self];
    [_lblRateValue setHorizontalMargin:1.0];
    [_lblRateValue setEditable:YES];
    [_lblRateValue setDisplayMode:EDStarRatingDisplayHalf];
    [_lblRateValue setRating:5];
    [_lblRateValue setNeedsDisplay];
    
    
    _lblPassengerRating.backgroundColor  = [UIColor clearColor];
    _lblPassengerRating.starImage = [[UIImage imageNamed:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _lblPassengerRating.starHighlightedImage = [[UIImage imageNamed:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_lblPassengerRating setMaxRating:5.0];
    [_lblPassengerRating setDelegate:self];
    [_lblPassengerRating setHorizontalMargin:1.0];
    [_lblPassengerRating setEditable:NO];
    [_lblPassengerRating setDisplayMode:EDStarRatingDisplayHalf];
    [_lblPassengerRating setRating:[gTrip.passenger.passenger_rating_count floatValue]/2];
    [_lblPassengerRating setNeedsDisplay];
    
    
    
    self.lblNameValue.text = gTrip.passenger.name;
    self.lblPhoneValue.text = gTrip.passenger.phone;
    self.lblPointValue.text = gTrip.actualFare;
    
    
    
    NSDictionary *fontDict = @{NSFontAttributeName:[UIFont fontAwesomeFontOfSize:10],NSForegroundColorAttributeName:[Util colorWithHexString:@"#e8c03a"]};
    
    
    
    
    NSMutableAttributedString *att =  [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[NSString fontAwesomeIconStringForEnum:FACircle]] attributes: fontDict];
    
    [att appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[NSString fontAwesomeIconStringForEnum:FACircle]] attributes: fontDict]];
    
    [att appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[NSString fontAwesomeIconStringForEnum:FACircle]] attributes: fontDict]];
    
    [att appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[NSString fontAwesomeIconStringForEnum:FACircle]] attributes: fontDict]];
    
    [att appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[NSString fontAwesomeIconStringForEnum:FACircle]] attributes: fontDict]];
    
    NSDictionary *arialDict = [NSDictionary dictionaryWithObject: STEP_TITLE_FONT forKey:NSFontAttributeName];
    NSMutableAttributedString *aAttrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[Util localized:@"finished_title"]] attributes: arialDict];
    
    [att appendAttributedString:aAttrString];
    
    
    self.lblTitle.attributedText =att;
    
    
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
    self.lblPointValue.text = gTrip.actualFare;
    self.lblFromName.text = gTrip.startLocation.name;
    self.lblToName.text = gTrip.endLocation.name;
    [self.passengerImg setImageWithURL:[NSURL URLWithString:gTrip.passenger.thumb]];
    
    self.lblDistanceValue.text = [Util localized:@"lbl_trip_finished"];
    
    self.lblPoint.text = [Util localized:@"lbl_point"];
    self.lblRate.text = [Util localized:@"lbl_rate"];
    [self.btnRate setTitle:[Util localized:@"lbl_rate"].uppercaseString forState:UIControlStateNormal];

    
}
-(void)showTripDetail{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [ModelManager showTripDetailWithTripId:gTrip.tripId withSuccess:^(Trips *trip) {
            gTrip = trip;
            [Util setObject:gTrip.tripId forKey:CURRENT_TRIP_ID_KEY];
            [self setText];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            notificationsDic = nil;
        } andFailure:^(NSString *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onSend:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [ModelManager ratePassengerWithRate:self.lblRateValue.rating*2 Success:^{
            gTrip = [[Trips alloc]init];
            [Util setObject:@"" forKey:DRIVER_CURRENT_TRIP_ID_KEY];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        } andFailure:^(NSString *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    });
    
}
@end
