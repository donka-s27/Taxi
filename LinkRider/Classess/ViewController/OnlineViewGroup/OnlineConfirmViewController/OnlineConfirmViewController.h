//
//  OnlineConfirmViewController.h
//  LinkRider
//
//  Created by hieu nguyen on 7/2/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDStarRating.h"
#import "CBAutoScrollLabel.h"
#import <CoreLocation/CoreLocation.h>
@interface OnlineConfirmViewController : UIViewController<EDStarRatingProtocol,UIAlertViewDelegate, CLLocationManagerDelegate,UIAlertViewDelegate>{
     NSTimer *timer;
     CLLocation *currentLocation;
}



@property (weak, nonatomic) IBOutlet UINavigationItem *lblHeaderTitle;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;


@property (weak, nonatomic) IBOutlet UILabel *lblDistanceValue;
@property (weak, nonatomic) IBOutlet UILabel *lblSeats;
@property (weak, nonatomic) IBOutlet UILabel *lblFromA;
@property (weak, nonatomic) IBOutlet UILabel *lblToB;


@property (weak, nonatomic) IBOutlet UILabel *lblSeatNum;

@property (weak, nonatomic) IBOutlet UILabel *lblFromName;
@property (weak, nonatomic) IBOutlet UILabel *lblToName;

@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;

@property (weak, nonatomic) IBOutlet UILabel *lblPassengerName;
@property (weak, nonatomic) IBOutlet UILabel *lblPhoneValue;
@property (weak, nonatomic) IBOutlet EDStarRating *lblRateValue;
@property (weak, nonatomic) IBOutlet UIButton *btnCancelTrip;
@property (weak, nonatomic) IBOutlet UIButton *btnArrived;

@property(nonatomic, retain) CLLocationManager *locationManager;

- (IBAction)onArrived:(id)sender;
- (IBAction)onCancelTrip:(id)sender;

@end
