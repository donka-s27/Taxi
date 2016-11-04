//
//  RattingPassengerViewController.h
//  LinkRider
//
//  Created by hieu nguyen on 7/2/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDStarRating.h"

@interface RattingPassengerViewController : UIViewController<EDStarRatingProtocol>{
    NSString *driver_earn;
}

@property (weak, nonatomic) IBOutlet UINavigationItem *lblHeaderTitle;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;


@property (weak, nonatomic) IBOutlet UIButton *btnRate;



@property (weak, nonatomic) IBOutlet UILabel *lblSeats;
@property (weak, nonatomic) IBOutlet UILabel *lblFromA;
@property (weak, nonatomic) IBOutlet UILabel *lblToB;
@property (weak, nonatomic) IBOutlet UILabel *lblPoint;
@property (weak, nonatomic) IBOutlet UILabel *lblRate;



@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *lblSeatNum;


@property (weak, nonatomic) IBOutlet UILabel *lblNameValue;

@property (weak, nonatomic) IBOutlet UILabel *lblPhoneValue;
@property (weak, nonatomic) IBOutlet EDStarRating *lblRateValue;

@property (weak, nonatomic) IBOutlet EDStarRating *lblPassengerRating;
@property (weak, nonatomic) IBOutlet UILabel *lblPointValue;

@property (weak, nonatomic) IBOutlet UILabel *lblDistanceValue;

@property (weak, nonatomic) IBOutlet UIImageView *passengerImg;


@property (weak, nonatomic) IBOutlet UILabel *lblFromName;
@property (weak, nonatomic) IBOutlet UILabel *lblToName;

- (IBAction)onSend:(id)sender;

@end
