//
//  OnlineStartTripViewController.h
//  LinkRider
//
//  Created by hieu nguyen on 7/2/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+FontAwesome.h"
#import "EDStarRating.h"
#import "CBAutoScrollLabel.h"
#import "UIKeyboardViewController.h"
#import "PSLocationManager.h"
@interface OnlineStartTripViewController : UIViewController<EDStarRatingProtocol,UIKeyboardViewControllerDelegate,PSLocationManagerDelegate>{
    UIKeyboardViewController *keyboard;
}

@property (weak, nonatomic) IBOutlet UINavigationItem *lblHeaderTitle;

@property (weak, nonatomic) IBOutlet UIButton *btnStart;
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


- (IBAction)onBeginTrip:(id)sender;
- (IBAction)onCancelTrip:(id)sender;


@end
