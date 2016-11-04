//
//  PayoutViewController.m
//  LinkRider
//
//  Created by hieu nguyen on 6/29/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import "PayoutViewController.h"
#import "NSString+FontAwesome.h"
#import "MBProgressHUD.h"
#import "ModelManager.h"
#import "UIView+Toast.h"
@interface PayoutViewController ()

@end

@implementation PayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.btnBack setTarget:self];
    [self.btnBack setAction:@selector(onBack)];
    [self getGeneralSetting];
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
    [self setText];
}
-(void)getGeneralSetting{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [ModelManager generalSettingWithSuccess:^(NSDictionary *dic) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            min_redeem_amount = [Validator getSafeFloat:dic[@"min_redeem_amount"]];
        } andFailure:^(NSString *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    });
}
-(void)setText{
    [self.lblHeaderTitle setTitle:[Util localized:@"header_payout"]];
    
    [self.btnBack setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont fontAwesomeFontOfSize:20], NSFontAttributeName,
                                          [UIColor whiteColor], NSForegroundColorAttributeName,
                                          nil]
                                forState:UIControlStateNormal];
    
    [self.btnBack setTitle:[NSString fontAwesomeIconStringForEnum:FALongArrowLeft] ];
    
    [self.btnSubmit setTitle:[Util localized:@"lbl_submit"].uppercaseString forState:UIControlStateNormal];

    [self.lblYourBalance setText:[Util localized:@"lbl_your_balance"]];
    [self.icBalance setText:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-university"]];
    
    

    [self.lblPoint setText:[Util localized:@"lbl_points"]];
    [self.icPoint setText:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-money"]];
    
    

    
    
    
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    

    
    
    [self.btnRedeemInformation setTitle:[Util localized:@"lbl_redeem_information"] forState:UIControlStateNormal];
    [self.btnInfo setTitle:@"\ue647"forState:UIControlStateNormal];
    
    
    
    

    self.txtPoint.layer.borderColor= [UIColor whiteColor].CGColor;
    self.txtPoint.layer.borderWidth = 1.0f;
    self.lblBalanceValue.text = gUser.point;
//    self.txtPoint.layer.cornerRadius = 5.0;
    
//    self.lblConvert.text = [Util localized:@"lbl_convert"];
    
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
-(void)onBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.txtPoint resignFirstResponder];
    return YES;
}

- (IBAction)onSubmit:(id)sender {
    [self.txtPoint resignFirstResponder];
    if ([self.txtPoint.text floatValue]>[gUser.point floatValue]) {
        [self.view makeToast:[Util localized:@"msg_not_enough_point"]];
        return;
    }
    if ([self.txtPoint.text floatValue]<min_redeem_amount) {
        [self.view makeToast:[NSString stringWithFormat:[Util localized:@"msg_min_redeem"],min_redeem_amount]];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
       [ModelManager pointRedeemwithAmount:self.txtPoint.text withSuccess:^{
           [self.view makeToast:[Util localized:@"msg_payment_success"]];
          
           self.txtPoint.text = @"";
           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
       } andFailure:^(NSString *err) {
           [self.view makeToast:err];
           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
       }];
    });
}
- (IBAction)onReDeemInfo:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:REDEEM_URL]];
}
@end
