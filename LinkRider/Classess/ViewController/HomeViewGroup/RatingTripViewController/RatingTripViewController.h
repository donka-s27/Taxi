//
//  RatingTripViewController.h
//  LinkRider
//
//  Created by hieu nguyen on 6/26/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDStarRating.h"
#import "PayPalMobile.h"
#import "CBAutoScrollLabel.h"
@interface RatingTripViewController : UIViewController<EDStarRatingProtocol,UIAlertViewDelegate,PayPalPaymentDelegate, PayPalFuturePaymentDelegate, PayPalProfileSharingDelegate>{
    BOOL isRate;
}

@property (weak, nonatomic) IBOutlet UINavigationItem *lblHeaderTitle;
@property (weak, nonatomic) IBOutlet EDStarRating *ratingStar;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTripNeed;

@property (weak, nonatomic) IBOutlet UILabel *lblRating;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet UIButton *btnRate;



@property (weak, nonatomic) IBOutlet UILabel *lblSeats;
@property (weak, nonatomic) IBOutlet UILabel *lblFromA;
@property (weak, nonatomic) IBOutlet UILabel *lblToB;
@property (weak, nonatomic) IBOutlet UILabel *lblPoint;
@property (weak, nonatomic) IBOutlet UILabel *lblRate;


@property (weak, nonatomic) IBOutlet UILabel *lblCarPlate;
@property (weak, nonatomic) IBOutlet UILabel *lblCar;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *lblSeatNum;


@property (weak, nonatomic) IBOutlet UILabel *lblNameValue;
@property (weak, nonatomic) IBOutlet UILabel *lblCarePlateValue;
@property (weak, nonatomic) IBOutlet UILabel *lblPhoneValue;
@property (weak, nonatomic) IBOutlet EDStarRating *lblRateValue;


@property (weak, nonatomic) IBOutlet UILabel *lblDistanceValue;

@property (weak, nonatomic) IBOutlet UIImageView *driverImg;
@property (weak, nonatomic) IBOutlet UIImageView *carImg;


@property (weak, nonatomic) IBOutlet UILabel *lblFromName;
@property (weak, nonatomic) IBOutlet UILabel *lblToName;









@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) NSString *resultText;
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;







- (IBAction)onSend:(id)sender;
- (IBAction)onRate:(id)sender;
@end
