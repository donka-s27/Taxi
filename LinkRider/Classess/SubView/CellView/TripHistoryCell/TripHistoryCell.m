//
//  TripHistoryCell.m
//  LinkRider
//
//  Created by hieu nguyen on 7/2/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import "TripHistoryCell.h"

@implementation TripHistoryCell

- (void)awakeFromNib {
    // Initialization code
    self.LblDepartureValue.textColor = self.lblEndTimeValue.textColor;
    self.LblDepartureValue.font = self.lblEndTimeValue.font;
    self.lblDestinationValue.textColor = self.lblEndTimeValue.textColor;
    self.lblDestinationValue.font = self.lblEndTimeValue.font;
    self.lblTransactionId.text = [Util localized:@"lbl_trip_id"];
    self.lblLink.text = [Util localized:@"lbl_seats"];
    self.LblDeparture.text = [Util localized:@"lbl_from_a"];
    self.lblDestination.text = [Util localized:@"lbl_to_b"];
    self.lblDuration.text = [Util localized:@"lbl_duration"];
    self.icCar.text = @"\ue6ae";
     _LblDepartureValue.textColor = [UIColor whiteColor];
    _lblDestinationValue.textColor = [UIColor whiteColor];
    _LblDepartureValue.font = _lblTransactionIdValue.font;
    _lblDestinationValue.font = _lblTransactionIdValue.font;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
