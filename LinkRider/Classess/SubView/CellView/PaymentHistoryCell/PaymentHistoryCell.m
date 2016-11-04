//
//  PaymentHistoryCell.m
//  LinkRider
//
//  Created by hieu nguyen on 6/29/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import "PaymentHistoryCell.h"
#import "NSString+FontAwesome.h"
@implementation PaymentHistoryCell

- (void)awakeFromNib {
    // Initialization code
    
    _lblTransactionId.text = [Util localized:@"lbl_transaction_id"];
    _lblTripId.text = [Util localized:@"lbl_trip_id"];
    _lblDatetime.text = [Util localized:@"lbl_datetime"];
    _lblType.text = [Util localized:@"lbl_type"];
    _lblPoint.text = [Util localized:@"lbl_point"];
    _lblNote.text = [Util localized:@"lbl_note"];
    _lblNoteContent.font = _lblDateValue.font;
    _lblNoteContent.textAlignment = NSTextAlignmentLeft;
    _lblNoteContent.textColor = [UIColor whiteColor];
    _icTransfer.text = @"\ue68c";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
