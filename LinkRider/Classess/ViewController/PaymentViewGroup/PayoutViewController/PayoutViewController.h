//
//  PayoutViewController.h
//  LinkRider
//
//  Created by hieu nguyen on 6/29/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayoutViewController : UIViewController<UITextFieldDelegate>{
    float min_redeem_amount;
}
@property (weak, nonatomic) IBOutlet UINavigationItem *lblHeaderTitle;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnBack;

@property (weak, nonatomic) IBOutlet UILabel *lblYourBalance;
@property (weak, nonatomic) IBOutlet UILabel *lblBalanceValue;
@property (weak, nonatomic) IBOutlet UILabel *lblPoint;
@property (weak, nonatomic) IBOutlet UITextField *txtPoint;
@property (weak, nonatomic) IBOutlet UIButton *btnInfo;
@property (weak, nonatomic) IBOutlet UILabel *icBalance;
@property (weak, nonatomic) IBOutlet UILabel *icPoint;

@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
- (IBAction)onSubmit:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnRedeemInformation;
- (IBAction)onReDeemInfo:(id)sender;
@end
