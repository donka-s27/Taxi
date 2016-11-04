//
//  TransferViewController.m
//  LinkRider
//
//  Created by hieu nguyen on 6/29/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import "TransferViewController.h"
#import "NSString+FontAwesome.h"
#import "ModelManager.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"

@interface TransferViewController ()

@end

@implementation TransferViewController

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
-(void)setText{
    [self.lblHeaderTitle setTitle:[Util localized:@"header_transfer"]];
    
    [self.btnBack setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont fontAwesomeFontOfSize:20], NSFontAttributeName,
                                          [UIColor whiteColor], NSForegroundColorAttributeName,
                                          nil]
                                forState:UIControlStateNormal];
    
    [self.btnBack setTitle:[NSString fontAwesomeIconStringForEnum:FALongArrowLeft] ];
    
    [self.btnContinue setTitle:[Util localized:@"lbl_submit"] forState:UIControlStateNormal];


    self.icBalance.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-university"];
    self.lblYourBalance.text = [Util localized:@"lbl_your_balance"];
    
    

    self.icAmount.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-money"];
    [self.lblPoint setText:[Util localized:@"lbl_amount"]];
    
    
    [self.icReceive setText:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-envelope-o"]];
    [self.lblBeneficiaryId setText:[Util localized:@"lbl_receiver"]];
    
    self.txtPoint.layer.borderColor= [UIColor whiteColor].CGColor;
    self.txtPoint.layer.borderWidth = 1.0f;
//    self.txtPoint.layer.cornerRadius = 5.0;
    
    self.txtBId.layer.borderColor= [UIColor whiteColor].CGColor;
    self.txtBId.layer.borderWidth = 1.0f;
//    self.txtBId.layer.cornerRadius = 5.0;
    
    
    self.txtNote.layer.borderColor= [UIColor whiteColor].CGColor;
    self.txtNote.layer.borderWidth = 1.0f;
    [self.icNote setText:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-file-text-o"]];
    
    self.txtBId.placeholder = [Util localized:@"lbl_email"];
    self.txtNote.placeholder = [Util localized:@"lbl_note_content"];
    self.lblBlanceValue.text = gUser.point;
    self.lblConvert.text = [Util localized:@"lbl_convert"];
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
    [self.txtBId resignFirstResponder];
    [self.txtPoint resignFirstResponder];
    return YES;
}
-(void)getGeneralSetting{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [ModelManager generalSettingWithSuccess:^(NSDictionary *dic) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            min_transfer = [Validator getSafeFloat:dic[@"min_transfer_amount"]];
            [self.txtPoint setText:[Validator getSafeString:dic[@"min_transfer_amount"]]];
        } andFailure:^(NSString *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    });
}

- (IBAction)onContinue:(id)sender {
    [self.txtBId resignFirstResponder];
    [self.txtPoint resignFirstResponder];
    if ([self.txtPoint.text floatValue]<min_transfer) {
        [self.view makeToast:[NSString stringWithFormat:[Util localized:@"msg_min_transfer"],min_transfer]];

        return;
    }
    if (self.txtNote.text.length==0) {
        [self.view makeToast:[Util localized:@"msg_missing_note"]];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [ModelManager searchUserWithEmail:self.txtBId.text withSuccess:^(User *u) {
            searchUser = u;
            [ModelManager transferWithAmount:self.self.txtPoint.text email:self.txtBId.text andNote:self.txtNote.text withSuccess:^{
                [self.view makeToast:[Util localized:@"msg_payment_success"]];
                
                [self.navigationController popToRootViewControllerAnimated:YES];

            } andFailure:^(NSString *err) {
                [self.view makeToast:err];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }];
            
        } andFailure:^(NSString *str) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.view makeToast:str];
        }];
    });
    
}


@end
