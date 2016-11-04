//
//  OrderConfirmViewController.h
//  LinkRider
//
//  Created by hieu nguyen on 6/26/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+FontAwesome.h"
#import "EDStarRating.h"
#import "CBAutoScrollLabel.h"
#import <CoreLocation/CoreLocation.h>
@interface OrderConfirmViewController : UIViewController<EDStarRatingProtocol, UIAlertViewDelegate, CLLocationManagerDelegate,UIAlertViewDelegate>{
    NSTimer *timer;
    CLLocation *currentLocation;
}

@property (weak, nonatomic) IBOutlet UINavigationItem *lblHeaderTitle;

@property (weak, nonatomic) IBOutlet UILabel *lblArriving;


@property (weak, nonatomic) IBOutlet UILabel *lblCarPlate;
@property (weak, nonatomic) IBOutlet UILabel *lblCar;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *lblSeats;
@property (weak, nonatomic) IBOutlet UILabel *lblFromA;
@property (weak, nonatomic) IBOutlet UILabel *lblToB;


@property (weak, nonatomic) IBOutlet UILabel *lblSeatNum;

@property (weak, nonatomic) IBOutlet UILabel *lblFromName;
@property (weak, nonatomic) IBOutlet UILabel *lblToName;

@property (weak, nonatomic) IBOutlet UILabel *lblIdDriverValue;
@property (weak, nonatomic) IBOutlet UILabel *lblNameValue;
@property (weak, nonatomic) IBOutlet UILabel *lblCarePlateValue;
@property (weak, nonatomic) IBOutlet UILabel *lblPhoneValue;
@property (weak, nonatomic) IBOutlet EDStarRating *lblRateValue;
@property (weak, nonatomic) IBOutlet UIButton *btnCancelTrip;

@property (weak, nonatomic) IBOutlet UILabel *lblDistanceValue;

@property (weak, nonatomic) IBOutlet UIImageView *driverImg;
@property (weak, nonatomic) IBOutlet UIImageView *carImg;


@property(nonatomic, retain) CLLocationManager *locationManager;
- (IBAction)onCancelTrip:(id)sender;
@end
