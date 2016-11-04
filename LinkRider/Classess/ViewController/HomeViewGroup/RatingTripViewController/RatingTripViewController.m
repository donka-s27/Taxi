//
//  RatingTripViewController.m
//  LinkRider
//
//  Created by hieu nguyen on 6/26/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import "RatingTripViewController.h"
#import "NSString+FontAwesome.h"
#import "ModelManager.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "UIImageView+WebCache.h"
#import "NSString+FontAwesome.h"
#import "UIFont+FontAwesome.h"
@interface RatingTripViewController ()

@end

@implementation RatingTripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    // Do any additional setup after loading the view.
    isRate = NO;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillBecomForceGround) name:WILL_ENTER_FORCE_GROUND object:nil];
}
- (void)appWillBecomForceGround{
    
    if (self) {
        [self showTripDetail];
    }
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self.navigationController setNavigationBarHidden:YES];
  
}
- (void)viewDidAppear:(BOOL)animated{
    [self showTripDetail];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationItem setHidesBackButton:NO animated:YES];
    
}
-(void)viewDidLayoutSubviews{
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.btnSend.frame.origin.y+self.btnSend.frame.origin.y+20);
}

-(void)setupPaypal{
    
    _payPalConfig = [[PayPalConfiguration alloc] init];
#if HAS_CARDIO
    // You should use the PayPal-iOS-SDK+card-Sample-App target to enable this setting.
    // For your apps, you will need to link to the libCardIO and dependent libraries. Please read the README.md
    // for more details.
    _payPalConfig.acceptCreditCards = YES;
#else
    _payPalConfig.acceptCreditCards = NO;
#endif
//    _payPalConfig.acceptCreditCards = NO;
    _payPalConfig.merchantName = [NSString stringWithFormat:@"%@ %@",[Util localized:@"app_name"],[Util localized:@"lbl_payment"]];
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];

    
    _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
 
    self.environment = kPayPalEnvironment;
    
    
}
- (BOOL)acceptCreditCards {
    return self.payPalConfig.acceptCreditCards;
}

- (void)setAcceptCreditCards:(BOOL)acceptCreditCards {
    self.payPalConfig.acceptCreditCards = acceptCreditCards;
}

- (void)setPayPalEnvironment:(NSString *)environment {
    self.environment = environment;
    [PayPalMobile preconnectWithEnvironment:environment];
}


-(void)setText{
    [self.lblHeaderTitle setTitle:[Util localized:@"header_your_trip"]];
    self.lblTripNeed.text = [NSString stringWithFormat:@"%@",gTrip.actualFare];

   
    
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
    _ratingStar.backgroundColor  = [UIColor clearColor];
    _ratingStar.starImage = [[UIImage imageNamed:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _ratingStar.starHighlightedImage = [[UIImage imageNamed:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [_ratingStar setMaxRating:5.0];
    [_ratingStar setDelegate:self];
    [_ratingStar setHorizontalMargin:1.0];
    [_ratingStar setEditable:YES];
    [_ratingStar setDisplayMode:EDStarRatingDisplayHalf];
    [_ratingStar setRating:5];
    [_ratingStar setNeedsDisplay];

    self.lblNameValue.text = gTrip.driver.driverName;
    self.lblPhoneValue.text = gTrip.driver.phone;
    
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
    
    self.lblFromName.text = gTrip.startLocation.name;
    self.lblToName.text = gTrip.endLocation.name;
    self.lblCar.text = [Util localized:@"lbl_car"];
    
    self.lblDistanceValue.text = [Util localized:@"lbl_trip_finished"];
    
    self.lblPoint.text = [Util localized:@"lbl_point"];
    self.lblRate.text = [Util localized:@"lbl_rate"];
    [self.btnRate setTitle:[Util localized:@"lbl_rate"].uppercaseString forState:UIControlStateNormal];
    [self.btnSend setTitle:[Util localized:@"lbl_payment"].uppercaseString forState:UIControlStateNormal];
    self.lblCarePlateValue.text = gTrip.driver.carPlate;
    [self.carImg setImageWithURL:[NSURL URLWithString:gTrip.driver.carImage]];
    [self.driverImg setImageWithURL:[NSURL URLWithString:gTrip.driver.imageDriver] placeholderImage:HOLDER_AVATAR];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showTripDetail{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [ModelManager showTripDetailWithTripId:gTrip.tripId withSuccess:^(Trips *trip) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                gTrip = trip;
                [Util setObject:gTrip.tripId forKey:CURRENT_TRIP_ID_KEY];
                [self setText];
                
                
            });
           
            notificationsDic = nil;
        } andFailure:^(NSString *err) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
//                [self showTripDetail];
            });
            
        }];
    });
}
- (IBAction)onSend:(id)sender {
    if (isRate) {
        [self onPayment];
    }
    else{
        [self.view makeToast:[Util localized:@"msg_rate_missing"]];
    }
}

- (IBAction)onRate:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  //  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        [ModelManager rateDriverWithRate:self.ratingStar.rating*2 Success:^{
            [self.view makeToast:[Util localized:@"msg_rate_trip_success"]];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            isRate = YES;
        } andFailure:^(NSString *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.view makeToast:[Util localized:@"msg_error"]];
        }];
  //  });
}
-(void)onPayment{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    
        [ModelManager tripPaymentWithSuccess:^{
            [Util removeObjectForKey:CURRENT_TRIP_ID_KEY];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"resetAllPoint" object:nil userInfo:notificationsDic];
            [self.view makeToast:[Util localized:@"msg_end_trip"]];
            gTrip = [[Trips alloc]init];
            [ModelManager getUserProfileWithSuccess:^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            } failure:^(NSString *err) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }];
        } andFailure:^(NSString *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [Util showMessage:err withTitle:[Util localized:@"app_name"] andDelegate:self];
        }];
//    });
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [self setupPaypal];
    [self setPayPalEnvironment:_environment];
    
    float price = [gTrip.actualFare floatValue] - [gUser.point floatValue];
    PayPalItem *item1 = [PayPalItem itemWithName:[NSString stringWithFormat:@"%@ %@",[Util localized:@"app_name"],[Util localized:@"lbl_payment"]]
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f",price]]
                                    withCurrency:@"USD"
                                         withSku:@"Hip-00037"];
    
    NSArray *items = @[item1];
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    
    // Optional: include payment details
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"0.00"];
    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"0.00"];
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
                                                                               withShipping:shipping
                                                                                    withTax:tax];
    
    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = total;
    payment.currencyCode = @"USD";
    payment.shortDescription = [NSString stringWithFormat:@"%@ %@",[Util localized:@"app_name"],[Util localized:@"lbl_payment"]];
    payment.items = items;
    payment.paymentDetails = paymentDetails;
    
    if (!payment.processable) {
        
    }
    
    // Update payPalConfig re accepting credit cards.
    self.payPalConfig.acceptCreditCards = self.acceptCreditCards;
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:self.payPalConfig
                                                                                                     delegate:self];
    [self presentViewController:paymentViewController animated:YES completion:nil];
    
}

#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success!");
    self.resultText = [completedPayment description];
    [self sendCompletedPaymentToServer:completedPayment];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark PayPalFuturePaymentDelegate methods

- (void)payPalFuturePaymentViewController:(PayPalFuturePaymentViewController *)futurePaymentViewController
                didAuthorizeFuturePayment:(NSDictionary *)futurePaymentAuthorization {
    NSLog(@"PayPal Future Payment Authorization Success!");
    self.resultText = [futurePaymentAuthorization description];
    
    [self sendFuturePaymentAuthorizationToServer:futurePaymentAuthorization];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalFuturePaymentDidCancel:(PayPalFuturePaymentViewController *)futurePaymentViewController {
    NSLog(@"PayPal Future Payment Authorization Canceled");
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendFuturePaymentAuthorizationToServer:(NSDictionary *)authorization {
    // TODO: Send authorization to server
    NSLog(@"Here is your authorization:\n\n%@\n\nSend this to your server to complete future payment setup.", authorization);
}


#pragma mark - Authorize Profile Sharing

- (IBAction)getUserAuthorizationForProfileSharing:(id)sender {
    
    NSSet *scopeValues = [NSSet setWithArray:@[kPayPalOAuth2ScopeOpenId, kPayPalOAuth2ScopeEmail, kPayPalOAuth2ScopeAddress, kPayPalOAuth2ScopePhone]];
    
    PayPalProfileSharingViewController *profileSharingPaymentViewController = [[PayPalProfileSharingViewController alloc] initWithScopeValues:scopeValues configuration:self.payPalConfig delegate:self];
    [self presentViewController:profileSharingPaymentViewController animated:YES completion:nil];
}


#pragma mark PayPalProfileSharingDelegate methods

- (void)payPalProfileSharingViewController:(PayPalProfileSharingViewController *)profileSharingViewController
             userDidLogInWithAuthorization:(NSDictionary *)profileSharingAuthorization {
    NSLog(@"PayPal Profile Sharing Authorization Success!");
    self.resultText = [profileSharingAuthorization description];
    
    [self sendProfileSharingAuthorizationToServer:profileSharingAuthorization];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidCancelPayPalProfileSharingViewController:(PayPalProfileSharingViewController *)profileSharingViewController {
    NSLog(@"PayPal Profile Sharing Authorization Canceled");
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendProfileSharingAuthorizationToServer:(NSDictionary *)authorization {
    // TODO: Send authorization to server
    NSLog(@"Here is your authorization:\n\n%@\n\nSend this to your server to complete profile sharing setup.", authorization);
}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    
    float price = [gTrip.actualFare floatValue] - [gUser.point floatValue];
    NSDictionary *payment = [completedPayment.confirmation objectForKey:@"response"];
    if ([payment isKindOfClass:[NSDictionary class]]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [ModelManager pointExchangewithAmount:[NSString stringWithFormat:@"%.2f",price]transactionId:[payment objectForKey:@"id"] andPaymentMethod:@"1" withSuccess:^{
                [self.view makeToast:[Util localized:@"msg_payment_success"]];
                
                [self onPayment];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            } andFailure:^(NSString *err) {
                [self.view makeToast:[Util localized:@"msg_error"]];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }];
//        });
    }
}

@end
