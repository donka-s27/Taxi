//
//  TransferViewController.h
//  LinkRider
//
//  Created by hieu nguyen on 6/29/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransferViewController : UIViewController{
    User *searchUser;
    float min_transfer;
}

@property (weak, nonatomic) IBOutlet UINavigationItem *lblHeaderTitle;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnBack;

@property (weak, nonatomic) IBOutlet UILabel *lblYourBalance;
@property (weak, nonatomic) IBOutlet UILabel *lblBlanceValue;
@property (weak, nonatomic) IBOutlet UILabel *lblBeneficiaryId;
@property (weak, nonatomic) IBOutlet UITextField *txtBId;
@property (weak, nonatomic) IBOutlet UILabel *lblPoint;
@property (weak, nonatomic) IBOutlet UITextField *txtPoint;
@property (weak, nonatomic) IBOutlet UILabel *lblConvert;
@property (weak, nonatomic) IBOutlet UIButton *btnContinue;
@property (weak, nonatomic) IBOutlet UILabel *lblNote;
@property (weak, nonatomic) IBOutlet UITextField *txtNote;
@property (weak, nonatomic) IBOutlet UILabel *icBalance;
@property (weak, nonatomic) IBOutlet UILabel *icAmount;
@property (weak, nonatomic) IBOutlet UILabel *icReceive;
@property (weak, nonatomic) IBOutlet UILabel *icNote;

- (IBAction)onContinue:(id)sender;
@end
