//
//  TripHistoryCell.h
//  LinkRider
//
//  Created by hieu nguyen on 7/2/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBAutoScrollLabel.h"

@interface TripHistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTransactionId;
@property (weak, nonatomic) IBOutlet UILabel *lblLink;

@property (weak, nonatomic) IBOutlet UILabel *LblDeparture;
@property (weak, nonatomic) IBOutlet UILabel *lblDestination;

@property (weak, nonatomic) IBOutlet UILabel *lblTransactionIdValue;
@property (weak, nonatomic) IBOutlet UILabel *lblLinkValue;
@property (weak, nonatomic) IBOutlet UILabel *lblEndTimeValue;
@property (weak, nonatomic) IBOutlet CBAutoScrollLabel *LblDepartureValue;
@property (weak, nonatomic) IBOutlet CBAutoScrollLabel *lblDestinationValue;

@property (weak, nonatomic) IBOutlet UIImageView *bgImg;

@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;

@property (weak, nonatomic) IBOutlet UILabel *lblTimeValue;
@property (weak, nonatomic) IBOutlet UILabel *lblDistanceValue;
@property (weak, nonatomic) IBOutlet UILabel *lblPriceValue;
@property (weak, nonatomic) IBOutlet UILabel *lblDuration;
@property (weak, nonatomic) IBOutlet UILabel *lblDurationValue;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *icCar;

@end
