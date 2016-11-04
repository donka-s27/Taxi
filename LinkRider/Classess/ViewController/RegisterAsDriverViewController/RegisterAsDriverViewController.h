//
//  RegisterAsDriverViewController.h
//  LinkRider
//
//  Created by hieu nguyen on 7/2/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIKeyboardViewController.h"
@interface RegisterAsDriverViewController : UIViewController<UIKeyboardViewControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    UIKeyboardViewController *keyboard;
    
    UIActionSheet *selectPhoto;
    UIImagePickerController *pickerCar;
    UIImage *mainImage;
    UIImage *subImage;
    UIImage *documentPath;
    UIDatePicker *yearPicker;
    UIDatePicker *dobPicker;
    BOOL isDocumentSelecting;
    BOOL isImgProfile1Selecting;
}
@property (retain)UIDocumentInteractionController *documentController;
@property (weak, nonatomic) IBOutlet UINavigationItem *lblHeaderTitle;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnSave;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *mainSubview;

@property (weak, nonatomic) IBOutlet UIButton *btnAddMainCar;
@property (weak, nonatomic) IBOutlet UIButton *btnAddSubCar;
@property (weak, nonatomic) IBOutlet UILabel *icAvatar;
@property (weak, nonatomic) IBOutlet UILabel *icName;
@property (weak, nonatomic) IBOutlet UILabel *icCarPlate;
@property (weak, nonatomic) IBOutlet UILabel *icBrandOfCar;
@property (weak, nonatomic) IBOutlet UILabel *icModelOfCar;
@property (weak, nonatomic) IBOutlet UILabel *icYear;
@property (weak, nonatomic) IBOutlet UILabel *icEmail;
@property (weak, nonatomic) IBOutlet UILabel *icStatus;
@property (weak, nonatomic) IBOutlet UILabel *icAccount;
@property (weak, nonatomic) IBOutlet UILabel *icDocument;
@property (weak, nonatomic) IBOutlet UILabel *icDoB;



@property (weak, nonatomic) IBOutlet UILabel *lblAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblCarPlate;
@property (weak, nonatomic) IBOutlet UILabel *lblBrandOfCar;
@property (weak, nonatomic) IBOutlet UILabel *lblModelOfCar;
@property (weak, nonatomic) IBOutlet UILabel *lblYear;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblAccount;
@property (weak, nonatomic) IBOutlet UILabel *lblDocument;
@property (weak, nonatomic) IBOutlet UILabel *lblDoB;


@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtCarPlate;
@property (weak, nonatomic) IBOutlet UITextField *txtBrandOfCar;
@property (weak, nonatomic) IBOutlet UITextField *txtModelOfCar;
@property (weak, nonatomic) IBOutlet UITextField *txtYear;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtStatus;
@property (weak, nonatomic) IBOutlet UITextField *txtDoB;
@property (weak, nonatomic) IBOutlet UIButton *btnDocument;


@property (weak, nonatomic) IBOutlet UITextField *txtAccount;

@property (weak, nonatomic) IBOutlet UIImageView *imgProfile1;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfile2;


@end
