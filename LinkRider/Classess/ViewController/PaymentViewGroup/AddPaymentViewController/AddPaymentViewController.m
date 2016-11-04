//
//  AddPaymentViewController.m
//  LinkRider
//
//  Created by hieu nguyen on 6/29/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import "AddPaymentViewController.h"
#import "NSString+FontAwesome.h"
#import "UIView+Toast.h"
#import "ModelManager.h"
#import "MBProgressHUD.h"

@interface AddPaymentViewController ()

@end

@implementation AddPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.btnBack setTarget:self];
    [self.btnBack setAction:@selector(onBack)];
    [self setupPaypal];
    // Do any additional setup after loading the view.
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationItem setHidesBackButton:NO animated:YES];
    self.navigationController.navigationBarHidden = NO;
    
     [self setPayPalEnvironment:self.environment];
    [self setText];
}
-(void)setText{
    [self.lblHeaderTitle setTitle:[Util localized:@"header_payment"]];

    [self.btnBack setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                [UIFont fontAwesomeFontOfSize:20], NSFontAttributeName,
                                                [UIColor whiteColor], NSForegroundColorAttributeName,
                                                nil]
                                      forState:UIControlStateNormal];
    
    [self.btnBack setTitle:[NSString fontAwesomeIconStringForEnum:FALongArrowLeft] ];

    

    [self.lblYourBalance setText:[Util localized:@"lbl_your_balance"]];
    [self.icBalance setText:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-university"]];
    

    [self.lblAmount setText:[Util localized:@"lbl_amount"]];
    [self.icAmount setText:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-money"]];
    
    self.txtAmount.layer.borderColor= [UIColor whiteColor].CGColor;
    self.txtAmount.layer.borderWidth = 1.0f;
    self.lblBalanceValue.text = gUser.point;
    

    for (UITextField *text in self.view.subviews) {
        if ([text isKindOfClass:[UITextField class]]) {
            [text setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
            UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 15, 0)];
            text.leftView = paddingView;
            text.leftViewMode = UITextFieldViewModeAlways;
            [text setReturnKeyType:UIReturnKeyDone];
            [text addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
        }
    }
    
}
-(void)setupPaypal{

    _payPalConfig = [[PayPalConfiguration alloc] init];
#if HAS_CARDIO
    // You should use the PayPal-iOS-SDK+card-Sample-App target to enable this setting.
    // For your apps, you will need to link to the libCardIO and dependent libraries. Please read the README.md
    // for more details.
    _payPalConfig.acceptCreditCards = YES;
#else
    _payPalConfig.acceptCreditCards = NO;
#endif
//    _payPalConfig.acceptCreditCards = NO;
    _payPalConfig.merchantName = [NSString stringWithFormat:@"%@ %@",[Util localized:@"app_name"],[Util localized:@"lbl_payment"]];
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    
    
    // Setting the payPalShippingAddressOption property is optional.
    //
    // See PayPalConfiguration.h for details.
    
    _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    
    // Do any additional setup after loading the view, typically from a nib.
    
    // use default environment, should be Production in real life
    self.environment = kPayPalEnvironment;
    

}
- (BOOL)acceptCreditCards {
    return self.payPalConfig.acceptCreditCards;
}

- (void)setAcceptCreditCards:(BOOL)acceptCreditCards {
    self.payPalConfig.acceptCreditCards = acceptCreditCards;
}

- (void)setPayPalEnvironment:(NSString *)environment {
    self.environment = environment;
    [PayPalMobile preconnectWithEnvironment:environment];
}

-(void)onBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.txtAmount resignFirstResponder];
    return YES;
}
- (IBAction)onPay:(id)sender {
    [self.view endEditing:YES];
     if (self.txtAmount.text.length==0) {
        [self.view makeToast:[Util localized:@"msg_missing_amount"]];
        return;
    }
    self.resultText = nil;
    

    PayPalItem *item1 = [PayPalItem itemWithName:[NSString stringWithFormat:@"%@ %@",[Util localized:@"app_name"],[Util localized:@"lbl_payment"]]
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:self.txtAmount.text]
                                    withCurrency:@"USD"
                                         withSku:@"Hip-00037"];
   
    NSArray *items = @[item1];
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    
    // Optional: include payment details
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"0.00"];
    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"0.00"];
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
                                                                               withShipping:shipping
                                                                                    withTax:tax];
    
    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = total;
    payment.currencyCode = @"USD";
    payment.shortDescription = [NSString stringWithFormat:@"%@ %@",[Util localized:@"app_name"],[Util localized:@"lbl_payment"]];
    payment.items = items;
    payment.paymentDetails = paymentDetails;
    
    if (!payment.processable) {

    }
    
    // Update payPalConfig re accepting credit cards.
    self.payPalConfig.acceptCreditCards = self.acceptCreditCards;
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:self.payPalConfig
                                                                                                     delegate:self];
    [self presentViewController:paymentViewController animated:YES completion:nil];
}

#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success!");
    self.resultText = [completedPayment description];

    
    [self sendCompletedPaymentToServer:completedPayment];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {

    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
    NSDictionary *payment = [completedPayment.confirmation objectForKey:@"response"];
    if ([payment isKindOfClass:[NSDictionary class]]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [ModelManager pointExchangewithAmount:self.txtAmount.text transactionId:[payment objectForKey:@"id"] andPaymentMethod:@"1" withSuccess:^{
                [self.view makeToast:[Util localized:@"msg_payment_success"]];
                self.lblBalanceValue.text = gUser.point;
                self.txtAmount.text = @"";
                [ModelManager getUserProfileWithSuccess:^{
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    self.lblBalanceValue.text = gUser.point;
                } failure:^(NSString *err) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                }];
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            } andFailure:^(NSString *err) {
                [self.view makeToast:[Util localized:@"msg_error"]];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }];
//        });
    }
}

@end
