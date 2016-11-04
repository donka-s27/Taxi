//
//  PaymentViewController.m
//  LinkRider
//
//  Created by hieu nguyen on 6/24/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import "PaymentViewController.h"
#import "UIImageView+WebCache.h"
#import "ModelManager.h"
#import "MBProgressHUD.h"
@interface PaymentViewController ()

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    SWRevealViewController *revealViewController = self.revealViewController;
    [self.navigationController.navigationBar setBarTintColor:[Util colorWithHexString:@"#333333" alpha:1]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"Raleway-Medium" size:20], NSFontAttributeName, nil]];
    
    if ( revealViewController )
    {
        [self.revealButtonItem addTarget:revealViewController action:@selector( revealToggle: ) forControlEvents:UIControlEventTouchUpInside];
        
        [self.navigationController.navigationBar addGestureRecognizer:revealViewController.panGestureRecognizer];
    }
     self.scrollView.contentSize = CGSizeMake(320, self.btnHistory.frame.size.height+self.btnHistory.frame.origin.y+20);
    NSDictionary *alert = [[notificationsDic objectForKey:@"aps"] objectForKey:@"alert"];
    
    if ([alert isKindOfClass:[NSDictionary class]]) {
        NSString *action = [alert valueForKey:@"action"];
        if ([action isEqualToString:@"updateApproval"]||[action isEqualToString:@"redeemApproval"]||[action isEqualToString:@"transferApproval"]) {
            [self performSegueWithIdentifier:@"onHistory" sender:self];
        }
    }
    _ratingStar.starImage = [[UIImage imageNamed:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _ratingStar.starHighlightedImage = [[UIImage imageNamed:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [_ratingStar setMaxRating:5.0];

    [_ratingStar setHorizontalMargin:1.0];
    [_ratingStar setEditable:NO];
    [_ratingStar setDisplayMode:EDStarRatingDisplayHalf];
    [_ratingStar setNeedsDisplay];
    _ratingStar.tintColor =   [UIColor whiteColor];
    if (![gUser.driver.isActive boolValue]) {
        //        self.lblJob.text = [Util localized:@"lbl_passenger"];
        [_ratingStar setRating:[gUser.passenger_rating_count intValue]];
    }
    else{
        //        self.lblJob.text = [Util localized:@"lbl_driver"];
        [_ratingStar setRating:[gUser.driver.driverRateCount intValue]];
    }
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
    [self setText];

    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidAppear:(BOOL)animated{
    [self.imgUser setImageWithURL:[NSURL URLWithString:gUser.thumb]];
    
    self.imgUser.layer.cornerRadius=self.imgUser.frame.size.height /2;
    self.imgUser.layer.borderWidth=2;
    
    self.imgUser.layer.masksToBounds = YES;
    self.imgUser.layer.borderColor = [UIColor whiteColor].CGColor;

}

-(void)setText{


    [self.revealButtonItem setTitle:@"\uf0c9" forState:UIControlStateNormal];
    [self.revealButtonItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnPayment setTitle:[Util localized:@"lbl_payment"] forState:UIControlStateNormal];
    [self.btnPayout setTitle:[Util localized:@"lbl_payout"] forState:UIControlStateNormal];
    [self.btnTransfer setTitle:[Util localized:@"lbl_transfer"] forState:UIControlStateNormal];
    [self.btnHistory setTitle:[Util localized:@"lbl_history"] forState:UIControlStateNormal];
       self.lblName.text = gUser.name;
    
    self.lblJob.text = [NSString stringWithFormat:@"%@: %@",[Util localized:@"lbl_your_balance"],gUser.point];
}


- (IBAction)onPayment:(id)sender {

}

- (IBAction)onPayout:(id)sender {
}

- (IBAction)onTransfer:(id)sender {
}

- (IBAction)onHistory:(id)sender {
}
@end
