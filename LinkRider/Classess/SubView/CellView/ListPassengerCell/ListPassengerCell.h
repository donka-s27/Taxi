//
//  ListPassengerCell.h
//  LinkRider
//
//  Created by hieu nguyen on 7/2/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDStarRating.h"
#import "CBAutoScrollLabel.h"
@interface ListPassengerCell : UITableViewCell<EDStarRatingProtocol>
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblRating;
@property (weak, nonatomic) IBOutlet EDStarRating *ratingValue;
@property (weak, nonatomic) IBOutlet UILabel *lblStart;
@property (weak, nonatomic) IBOutlet UILabel *lblEnd;

@property (weak, nonatomic) IBOutlet CBAutoScrollLabel *lblStartValue;
@property (weak, nonatomic) IBOutlet CBAutoScrollLabel *lblEndValue;
@property (weak, nonatomic) IBOutlet UILabel *lblSeat;
@property (weak, nonatomic) IBOutlet UILabel *lblSeatValue;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;

@end
