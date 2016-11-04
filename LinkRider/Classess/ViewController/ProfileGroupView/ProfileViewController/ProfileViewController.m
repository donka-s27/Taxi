//
//  ProfileViewController.m
//  LinkRider
//
//  Created by hieu nguyen on 6/23/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import "ProfileViewController.h"
#import "ModelManager.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "UIView+Toast.h"
@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];

    SWRevealViewController *revealViewController = self.revealViewController;
    [self.navigationController.navigationBar setBarTintColor:[Util colorWithHexString:@"#333333" alpha:1]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"Raleway-Medium" size:20], NSFontAttributeName, nil]];
    [self.revealButtonItem setTitle:@"\uf0c9" forState:UIControlStateNormal];
    [self.revealButtonItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if ( revealViewController )
    {
        [self.revealButtonItem addTarget:revealViewController action:@selector( revealToggle: ) forControlEvents:UIControlEventTouchUpInside];
        
        [self.navigationController.navigationBar addGestureRecognizer:revealViewController.panGestureRecognizer];
    }
    _lblRateValue.starImage = [[UIImage imageNamed:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _lblRateValue.starHighlightedImage = [[UIImage imageNamed:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [_lblRateValue setMaxRating:5.0];
    [_lblRateValue setDelegate:self];
    [_lblRateValue setHorizontalMargin:1.0];
    [_lblRateValue setEditable:NO];
    [_lblRateValue setDisplayMode:EDStarRatingDisplayHalf];
    
    [_lblRateValue setNeedsDisplay];
    _lblRateValue.tintColor =   [UIColor whiteColor];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)viewWillAppear:(BOOL)animated{
  [self setText];
    [self getData];
    [self setupScrollView];
    [self.navigationItem setHidesBackButton:YES animated:YES];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [self.imgUser setImageWithURL:[NSURL URLWithString:gUser.thumb]];
    //    _imgUser.image = [UIImage imageNamed:@"180.png"];
    self.imgUser.layer.cornerRadius=self.imgUser.frame.size.height /2;
    self.imgUser.layer.borderWidth=1;
    self.imgUser.layer.masksToBounds = YES;
    self.imgUser.layer.borderColor = [UIColor whiteColor].CGColor;
}
-(void)viewDidLayoutSubviews{
    
    if ([gUser.is_driver isEqualToString:@"1"]) {
        
        self.lblDescriptionValue.frame = CGRectMake(self.lblDescriptionValue.frame.origin.x, self.lblDescriptionValue.frame.origin.y, self.lblCarePlateValue.frame.size.width, self.lblDescriptionValue.frame.size.height);
    }
    else{
        
        self.icDescription.frame = self.icPlate.frame;
        self.lblDescriptionValue.frame = self.lblCarePlateValue.frame;
        self.lblDescription.frame = self.lblCarPlate.frame;
        
    }
    

    
    CGFloat height = [Util getLabelHight:self.lblDescriptionValue];
    CGRect rect = self.lblDescriptionValue.frame;
    rect.size.height = height;
    self.lblDescriptionValue.frame = rect;

    self.btnUpdateProfile.frame = CGRectMake(self.view.frame.size.width/2 - self.btnUpdateProfile.frame.size.width/2, self.lblDescriptionValue.frame.origin.y+height+25, self.btnUpdateProfile.frame.size.width, self.btnUpdateProfile.frame.size.height);
    self.btnUpdateProfile.hidden = NO;
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.btnUpdateProfile.frame.size.height+self.btnUpdateProfile.frame.origin.y+25);
}
-(void)getData{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [ModelManager getUserProfileWithSuccess:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setupScrollView];
            });
            
        } failure:^(NSString *err) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setupScrollView];
            });
        }];
    });

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)setText{

    [self.imgUser setImageWithURL:[NSURL URLWithString:gUser.thumb]];
//    _imgUser.image = [UIImage imageNamed:@"180.png"];
    self.imgUser.layer.cornerRadius=self.imgUser.frame.size.height /2;
    self.imgUser.layer.borderWidth=1;
    self.imgUser.layer.masksToBounds = YES;
    self.imgUser.layer.borderColor = [UIColor whiteColor].CGColor;
    
    if ([gUser.driver.isActive isEqualToString:@"1"]) {
        self.icBrandOfCar.hidden = NO;
        self.icModelOfCar.hidden = NO;
        self.icPlate.hidden = NO;
        self.icYearManufacturer.hidden = NO;
        self.lblBrandOfCar.hidden = NO;
        self.lblModelOfCar.hidden = NO;
        self.lblCarPlate.hidden = NO;
        self.lblYearManufacturer.hidden = NO;
        self.lblBrandValue.hidden = NO;
        self.lblModelValue.hidden = NO;
        self.lblCarePlateValue.hidden = NO;
        self.lblYearValue.hidden = NO;
        
    }
    else{
        self.icBrandOfCar.hidden = YES;
        self.icModelOfCar.hidden = YES;
        self.icPlate.hidden = YES;
        self.icYearManufacturer.hidden = YES;
        self.lblBrandOfCar.hidden = YES;
        self.lblModelOfCar.hidden = YES;
        self.lblCarPlate.hidden = YES;
        self.lblYearManufacturer.hidden = YES;
        self.lblBrandValue.hidden = YES;
        self.lblModelValue.hidden = YES;
        self.lblCarePlateValue.hidden = YES;
        self.lblYearValue.hidden = YES;
        
    }
    self.icPhone.text =  @"\ue670";
    self.icEmail.text =  @"\ue639";
    self.icAddress.text =  @"\ue638";
    self.icDescription.text =  @"\ue647";
    
    self.icPlate.text =  [NSString fontAwesomeIconStringForIconIdentifier:@"fa-mobile"];
    self.icBrandOfCar.text =  [NSString fontAwesomeIconStringForIconIdentifier:@"fa-glass"];
    self.icModelOfCar.text =  [NSString fontAwesomeIconStringForIconIdentifier:@"fa-trophy"];
    self.icYearManufacturer.text =  [NSString fontAwesomeIconStringForIconIdentifier:@"fa-calendar"];
    self.lblCarPlate.text = [Util localized:@"lbl_car_plate"];
    self.lblPhone.text = [Util localized:@"lbl_phone"];
    self.lblBrandOfCar.text = [Util localized:@"lbl_brand_of_car"];
    self.lblModelOfCar.text = [Util localized:@"lbl_model_of_car"];
    self.lblYearManufacturer.text = [Util localized:@"lbl_year_manufacturer"];
    self.lblEmail.text = [Util localized:@"lbl_email"];
    self.lblState.text = [Util localized:@"lbl_state"];
    self.lblCity.text = [Util localized:@"lbl_city"];
    self.lblAddress.text = [Util localized:@"lbl_address"];
    self.lblDescription.text = [Util localized:@"lbl_description"];
    
    [self.btnUpdateProfile setTitle:[Util localized:@"lbl_update_profile"].uppercaseString forState:UIControlStateNormal];
    
    
    self.lblName.text = gUser.name;
    if (![gUser.driver.isActive boolValue]) {
        //        self.lblJob.text = [Util localized:@"lbl_passenger"];
        [_lblRateValue setRating:[gUser.passenger_rating_count intValue]];
    }
    else{
        //        self.lblJob.text = [Util localized:@"lbl_driver"];
        [_lblRateValue setRating:[gUser.driver.driverRateCount intValue]];
    }
}
-(void)setupScrollView{
    self.lblEmailValue.text = gUser.email;
    self.lblCarePlateValue.text = gUser.car.carPlate;
    self.lblBrandValue.text = gUser.car.brand;
    self.lblModelValue.text = gUser.car.model;
    self.lblYearValue.text = gUser.car.year;
    self.lblPhoneValue.text = gUser.phone;
    self.lblAddressValue.text = gUser.address;
    self.lblCityValue.text = gUser.city;
    self.lblStateValue.text = gUser.state;
    self.lblDescriptionValue.text = gUser.descriptions;
}
-(void)setupPassengerScrollView{
    
}


- (IBAction)onUpdate:(id)sender {
    if([[NSString stringWithFormat:@"%@",gUser.is_driver] isEqualToString:@"1"]&&[[NSString stringWithFormat:@"%@",gUser.driver.isActive] isEqualToString:@"0"]){
        [self.view makeToast:[Util localized:@"msg_driver_approving"]];
        return;
    }
    if ([gUser.driver.update_pending isEqualToString:@"1"]) {
        [self.view makeToast:[Util localized:@"msg_pending_update"]];
        return;
    }
    if ([[NSString stringWithFormat:@"%@",gUser.is_driver] isEqualToString:@"1"]) {
        [self performSegueWithIdentifier:@"onUpdateProfile" sender:self];
    }
    else{
        [self performSegueWithIdentifier:@"onUpdatePassengerProfile" sender:self];
    }
}
@end
