//
//  ProfileViewController.h
//  LinkRider
//
//  Created by hieu nguyen on 6/23/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+FontAwesome.h"
#import "EDStarRating.h"
#import "UpdateProfileViewController.h"
@interface ProfileViewController : UIViewController<EDStarRatingProtocol>
@property (nonatomic) IBOutlet UIButton* revealButtonItem;
@property (weak, nonatomic) IBOutlet UIImageView *imgUser;

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet EDStarRating *lblRateValue;



#pragma mark driver data

@property (weak, nonatomic) IBOutlet UILabel *icPlate;
@property (weak, nonatomic) IBOutlet UILabel *icPhone;
//
@property (weak, nonatomic) IBOutlet UILabel *icBrandOfCar;
@property (weak, nonatomic) IBOutlet UILabel *icModelOfCar;
@property (weak, nonatomic) IBOutlet UILabel *icYearManufacturer;
@property (weak, nonatomic) IBOutlet UILabel *icEmail;
@property (weak, nonatomic) IBOutlet UILabel *icAddress;

//@property (weak, nonatomic) IBOutlet UILabel *icAccount;
//@property (weak, nonatomic) IBOutlet UILabel *icStatus;
@property (weak, nonatomic) IBOutlet UILabel *icDescription;





//@property (weak, nonatomic) IBOutlet UILabel *lblIdDriver;
@property (weak, nonatomic) IBOutlet UILabel *lblCarPlate;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;

@property (weak, nonatomic) IBOutlet UILabel *lblBrandOfCar;
@property (weak, nonatomic) IBOutlet UILabel *lblModelOfCar;
@property (weak, nonatomic) IBOutlet UILabel *lblYearManufacturer;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblState;
@property (weak, nonatomic) IBOutlet UILabel *lblCity;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
//
//@property (weak, nonatomic) IBOutlet UILabel *lblAccount;
//@property (weak, nonatomic) IBOutlet UILabel *lblStatus;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//@property (weak, nonatomic) IBOutlet UILabel *lblIdDriverValue;
@property (weak, nonatomic) IBOutlet UILabel *lblCarePlateValue;
@property (weak, nonatomic) IBOutlet UILabel *lblPhoneValue;

@property (weak, nonatomic) IBOutlet UIButton *btnUpdateProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblBrandValue;
@property (weak, nonatomic) IBOutlet UILabel *lblModelValue;
@property (weak, nonatomic) IBOutlet UILabel *lblYearValue;
@property (weak, nonatomic) IBOutlet UILabel *lblEmailValue;
@property (weak, nonatomic) IBOutlet UILabel *lblStateValue;
@property (weak, nonatomic) IBOutlet UILabel *lblCityValue;
@property (weak, nonatomic) IBOutlet UILabel *lblAddressValue;
@property (weak, nonatomic) IBOutlet UILabel *lblDescriptionValue;
//
//@property (weak, nonatomic) IBOutlet UILabel *lblAccountValue;
//@property (weak, nonatomic) IBOutlet UILabel *lblStatusValue;



#pragma mark Passenger data



#pragma mark Action

- (IBAction)onUpdate:(id)sender;

@end
