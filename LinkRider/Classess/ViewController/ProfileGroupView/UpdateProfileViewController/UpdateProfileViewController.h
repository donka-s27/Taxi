//
//  UpdateProfileViewController.h
//  LinkRider
//
//  Created by hieu nguyen on 6/29/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIKeyboardViewController.h"

@interface UpdateProfileViewController : UIViewController<UIKeyboardViewControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    UIKeyboardViewController *keyboard;
    UIDatePicker *yearPicker;
    UIImage *documentPath;
    
    BOOL isDocumentSelecting;
    BOOL isImage1Selecting;

    UIActionSheet *selectPhoto;
    UIImagePickerController *pickerCar;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UINavigationItem *lblHeaderTitle;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnBack;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnSave;
@property (weak, nonatomic) IBOutlet UIButton *btnAddMainCar;
@property (weak, nonatomic) IBOutlet UIButton *btnAddSubCar;
@property (weak, nonatomic) IBOutlet UIView *mainSubView;

@property (weak, nonatomic) IBOutlet UILabel *icAvatar;
@property (weak, nonatomic) IBOutlet UILabel *icName;
@property (weak, nonatomic) IBOutlet UILabel *icCarPlate;
@property (weak, nonatomic) IBOutlet UILabel *icBrandOfCar;
@property (weak, nonatomic) IBOutlet UILabel *icModelOfCar;
@property (weak, nonatomic) IBOutlet UILabel *icYear;
@property (weak, nonatomic) IBOutlet UILabel *icPhone;
@property (weak, nonatomic) IBOutlet UILabel *icEmail;
@property (weak, nonatomic) IBOutlet UILabel *icAddress;


@property (weak, nonatomic) IBOutlet UILabel *icDesc;
@property (weak, nonatomic) IBOutlet UILabel *icDocument;


@property (weak, nonatomic) IBOutlet UILabel *lblAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblCarPlate;
@property (weak, nonatomic) IBOutlet UILabel *lblBrandOfCar;
@property (weak, nonatomic) IBOutlet UILabel *lblModelOfCar;
@property (weak, nonatomic) IBOutlet UILabel *lblYear;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblState;
@property (weak, nonatomic) IBOutlet UILabel *lblCity;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblDocument;


@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtCarPlate;
@property (weak, nonatomic) IBOutlet UITextField *txtBrandOfCar;
@property (weak, nonatomic) IBOutlet UITextField *txtModelOfCar;
@property (weak, nonatomic) IBOutlet UITextField *txtYear;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtState;
@property (weak, nonatomic) IBOutlet UITextField *txtCity;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress;

@property (weak, nonatomic) IBOutlet UITextField *txtDescValue;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectDocument;


@property (weak, nonatomic) IBOutlet UIImageView *imgProfile1;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfile2;




@property (weak, nonatomic) IBOutlet UILabel *icStatus;
@property (weak, nonatomic) IBOutlet UILabel *icAccount;

@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblAccount;

@property (weak, nonatomic) IBOutlet UITextField *txtStatus;
@property (weak, nonatomic) IBOutlet UITextField *txtAccount;



- (IBAction)onDocument:(id)sender;

@end
