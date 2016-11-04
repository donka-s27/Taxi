//
//  PaymentViewController.h
//  LinkRider
//
//  Created by hieu nguyen on 6/24/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentViewController : UIViewController{
    float driver_share_bonus;
    float passenger_share_bonus;
    float min_redeem_amount;
}
@property (nonatomic) IBOutlet UIButton* revealButtonItem;
@property (weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (weak, nonatomic) IBOutlet UIImageView *imgThumb;
@property (weak, nonatomic) IBOutlet EDStarRating *ratingStar;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblJob;

@property (weak, nonatomic) IBOutlet UIButton *btnPayment;
@property (weak, nonatomic) IBOutlet UIButton *btnPayout;
@property (weak, nonatomic) IBOutlet UIButton *btnTransfer;
@property (weak, nonatomic) IBOutlet UIButton *btnHistory;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)onPayment:(id)sender;
- (IBAction)onPayout:(id)sender;
- (IBAction)onTransfer:(id)sender;
- (IBAction)onHistory:(id)sender;

@end
