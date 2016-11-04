//
//  AddPaymentViewController.h
//  LinkRider
//
//  Created by hieu nguyen on 6/29/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"
@interface AddPaymentViewController : UIViewController<UITextFieldDelegate,PayPalPaymentDelegate>
@property (weak, nonatomic) IBOutlet UINavigationItem *lblHeaderTitle;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnBack;


@property (weak, nonatomic) IBOutlet UILabel *lblYourBalance;
@property (weak, nonatomic) IBOutlet UILabel *lblBalanceValue;
@property (weak, nonatomic) IBOutlet UILabel *lblAmount;
@property (weak, nonatomic) IBOutlet UITextField *txtAmount;
@property (weak, nonatomic) IBOutlet UILabel *icBalance;
@property (weak, nonatomic) IBOutlet UILabel *icAmount;

@property (weak, nonatomic) IBOutlet UIButton *btnPaypal;

@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) NSString *resultText;
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;

- (IBAction)onPay:(id)sender;

@end
