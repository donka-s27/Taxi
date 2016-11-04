//
//  PaymentHistoryCell.h
//  LinkRider
//
//  Created by hieu nguyen on 6/29/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBAutoScrollLabel.h"
@interface PaymentHistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTransactionId;
@property (weak, nonatomic) IBOutlet UILabel *lblDatetime;
@property (weak, nonatomic) IBOutlet UILabel *lblType;
@property (weak, nonatomic) IBOutlet UILabel *lblPoint;
@property (weak, nonatomic) IBOutlet UILabel *lblNote;
@property (weak, nonatomic) IBOutlet UILabel *lblTripId;

@property (weak, nonatomic) IBOutlet UILabel *lblTransactionValue;
@property (weak, nonatomic) IBOutlet UILabel *lblDateValue;
@property (weak, nonatomic) IBOutlet UILabel *lblTypeValue;
@property (weak, nonatomic) IBOutlet UILabel *lblPointValue;
@property (weak, nonatomic) IBOutlet UILabel *lblNoteContent;
@property (weak, nonatomic) IBOutlet UILabel *lblTripIdValue;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeValue;
@property (weak, nonatomic) IBOutlet UILabel *icTransfer;
@property (weak, nonatomic) IBOutlet UIImageView *imgBg;




@end
