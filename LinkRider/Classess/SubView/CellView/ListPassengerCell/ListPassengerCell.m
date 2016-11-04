//
//  ListPassengerCell.m
//  LinkRider
//
//  Created by hieu nguyen on 7/2/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import "ListPassengerCell.h"

@implementation ListPassengerCell

- (void)awakeFromNib {
    // Initialization code
    _ratingValue.backgroundColor  = [UIColor clearColor];
    _ratingValue.starImage = [[UIImage imageNamed:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _ratingValue.starHighlightedImage = [[UIImage imageNamed:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_ratingValue setMaxRating:5.0];
    [_ratingValue setDelegate:self];
    [_ratingValue setHorizontalMargin:1.0];
    [_ratingValue setEditable:NO];
    [_ratingValue setDisplayMode:EDStarRatingDisplayHalf];
    [_ratingValue setRating:5];
    [_ratingValue setNeedsDisplay];
    _ratingValue.tintColor =  [UIColor whiteColor];
    self.lblEndValue.textColor = self.lblSeatValue.textColor;
    self.lblEndValue.font = self.lblSeatValue.font;
    self.lblStartValue.textColor = self.lblSeatValue.textColor;
    self.lblStartValue.font = self.lblSeatValue.font;
    self.lblSeat.text = [Util localized:@"lbl_seats"];
    self.lblStart.text = [Util localized:@"lbl_from_a"];
    self.lblEnd.text = [Util localized:@"lbl_to_b"];
    
    self.lblStartValue.labelSpacing = 35;
    self.lblStartValue.pauseInterval = 3.7;
    self.lblStartValue.scrollSpeed = 30;
    self.lblStartValue.textAlignment = NSTextAlignmentLeft;
    self.lblStartValue.fadeLength = 12.f;
    
    self.lblEndValue.labelSpacing = 35;
    self.lblEndValue.pauseInterval = 3.7;
    self.lblEndValue.scrollSpeed = 30;
    self.lblEndValue.textAlignment = NSTextAlignmentLeft;
    self.lblEndValue.fadeLength = 12.f;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
