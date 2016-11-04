//
//  RegisterAsDriverViewController.m
//  LinkRider
//
//  Created by hieu nguyen on 7/2/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import "RegisterAsDriverViewController.h"
#import "ModelManager.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "UIView+Toast.h"

@interface RegisterAsDriverViewController ()

@end

@implementation RegisterAsDriverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.btnSave setTarget:self];
    [self.btnSave setAction:@selector(onSave)];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self getData];
    [self setText];
    isDocumentSelecting = NO;
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
   
    keyboard = [[UIKeyboardViewController alloc]initWithControllerDelegate:self];
    [keyboard addToolbarToKeyboard];
}
-(void)viewDidLayoutSubviews{
    CGRect rect = self.mainSubview.frame;
    rect.size.height = self.imgProfile1.frame.size.height+self.imgProfile1.frame.origin.y+20;
    self.mainSubview.frame = rect;
    self.scrollView.contentSize = CGSizeMake(320, self.imgProfile1.frame.size.height+self.imgProfile1.frame.origin.y+20);
}
-(void)setText{
    self.icAvatar.text =  [NSString fontAwesomeIconStringForIconIdentifier:@"fa-user-plus"];
    self.icName.text =  [NSString fontAwesomeIconStringForIconIdentifier:@"fa-user"];
    self.icCarPlate.text =  [NSString fontAwesomeIconStringForIconIdentifier:@"fa-mobile"];
    self.icBrandOfCar.text =  [NSString fontAwesomeIconStringForIconIdentifier:@"fa-glass"];
    self.icModelOfCar.text =  [NSString fontAwesomeIconStringForIconIdentifier:@"fa-trophy"];
    self.icYear.text =  [NSString fontAwesomeIconStringForIconIdentifier:@"fa-calendar"];
    self.icEmail.text =  [NSString fontAwesomeIconStringForIconIdentifier:@"fa-envelope-o"];
    self.icStatus.text =  [NSString fontAwesomeIconStringForIconIdentifier:@" fa-bar-chart"];
    self.icDocument.text =  [NSString fontAwesomeIconStringForIconIdentifier:@"fa-file-pdf-o"];
    self.icAccount.text =  [NSString fontAwesomeIconStringForIconIdentifier:@"fa-money"];
    self.icDoB.text =  [NSString fontAwesomeIconStringForIconIdentifier:@"fa-calendar"];
    
    
    self.lblAvatar.text = [Util localized:@"lbl_avatar"];
    self.lblName.text = [Util localized:@"lbl_id_driver"];
    self.lblCarPlate.text = [Util localized:@"lbl_car_plate"];
    self.lblBrandOfCar.text = [Util localized:@"lbl_brand_of_car"];
    self.lblModelOfCar.text = [Util localized:@"lbl_model_of_car"];
    self.lblYear.text = [Util localized:@"lbl_year"];
    self.lblEmail.text = [Util localized:@"lbl_email"];

    
    self.lblStatus.text = [Util localized:@"lbl_status"];
    self.lblDocument.text = [Util localized:@"lbl_document"];
    self.lblAccount.text = [Util localized:@"lbl_account"];
    [self.btnDocument setTitle:[Util localized:@"lbl_select_document"] forState:UIControlStateNormal];
    self.lblDoB.text = [Util localized:@"lbl_date_of_birth"];
    
    
    yearPicker = [[UIDatePicker alloc]init];
    yearPicker.datePickerMode = UIDatePickerModeDate;
    [yearPicker addTarget:self action:@selector(incidentDateValueChanged:) forControlEvents:UIControlEventValueChanged];
    

    self.txtYear.inputView = yearPicker;
    
    
    
    dobPicker = [[UIDatePicker alloc]init];
    dobPicker.datePickerMode = UIDatePickerModeDate;
    [dobPicker addTarget:self action:@selector(incidentDoBValueChanged:) forControlEvents:UIControlEventValueChanged];
    [dobPicker setMaximumDate:[NSDate date]];
    self.txtDoB.inputView = dobPicker;
    
    
    
    [self.btnDocument.layer setBorderWidth:1.0];
    [self.btnDocument.layer setBorderColor:[UIColor whiteColor].CGColor];
    for (UITextField *text in self.mainSubview.subviews) {
        if ([text isKindOfClass:[UITextField class]]) {
            text.layer.borderColor = [UIColor whiteColor].CGColor;
            text.layer.borderWidth = 1.0;
            [text setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
            UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 15, 0)];
            text.leftView = paddingView;
            text.leftViewMode = UITextFieldViewModeAlways;
            [text setReturnKeyType:UIReturnKeyDone];
            [text addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
        }
    }


    
    [self.lblHeaderTitle setTitle:[Util localized:@"header_register_as_driver"]];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    [self.navigationController.navigationBar setBarTintColor:[Util colorWithHexString:@"#333333" alpha:1]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"Raleway-Medium" size:20], NSFontAttributeName, nil]];
    
    if ( revealViewController )
    {
        [self.revealBtn setTarget: self.revealViewController];
        [self.revealBtn setAction: @selector(revealToggle:)];
        [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
    
    [self.revealBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                            [UIFont fontAwesomeFontOfSize:24], NSFontAttributeName,
                                            [UIColor whiteColor], NSForegroundColorAttributeName,
                                            nil]
                                  forState:UIControlStateNormal];
    
    [self.revealBtn setTitle:@"\uf0c9"];
    
    
    [self.btnSave setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont fontWithName:@"Pe-icon-7-stroke" size:26], NSFontAttributeName,
                                          [UIColor whiteColor], NSForegroundColorAttributeName,
                                          nil]
                                forState:UIControlStateNormal];
    
    [self.btnSave setTitle:@"\ue65f"];
    
    
}

- (IBAction) incidentDateValueChanged:(id)sender{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    _txtYear.text = [dateFormatter stringFromDate:[yearPicker date]];
    
}
- (IBAction) incidentDoBValueChanged:(id)sender{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    _txtDoB.text = [dateFormatter stringFromDate:[dobPicker date]];

}

-(void)getData{
    if (gUser.descriptions.length==0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [ModelManager getUserProfileWithSuccess:^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [self setUserData];
            } failure:^(NSString *err) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [self.view makeToast:[Util localized:@"msg_network_error"] duration:2.0 position:CSToastPositionCenter];
                sleep(2.0);
                [self.revealViewController revealToggleAnimated:YES];
            }];
        });
    }
    else{
        [self setUserData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }
    
}
-(void)setUserData{
    [self.imgAvatar setImageWithURL:[NSURL URLWithString:gUser.thumb]];
    self.imgAvatar.layer.cornerRadius=self.imgAvatar.frame.size.height /2;
    self.imgAvatar.layer.borderWidth=2;
    self.imgAvatar.layer.masksToBounds = YES;
    self.imgAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
    self.txtName.text = gUser.name;
    self.txtCarPlate.text  = gUser.car.carPlate;
    self.txtBrandOfCar.text = gUser.car.brand;
    self.txtModelOfCar.text = gUser.car.model;
    self.txtYear.text = gUser.manufacture_year;
    self.txtEmail.text = gUser.email;
    self.txtStatus.text = gUser.car_status;
    self.txtAccount.text = gUser.cart_value;
    self.txtDoB.text = gUser.date_of_birth;
    if (gUser.main_car.length==0) {
        CGRect rect = self.imgProfile1.frame;
        rect.size.height = rect.size.height/2;

        [_btnAddMainCar setTitle:[Util localized:@"lbl_add_main_car"] forState:UIControlStateNormal];
        [_btnAddMainCar addTarget:self action:@selector(onAddCar:) forControlEvents:UIControlEventTouchUpInside];
        _btnAddMainCar.titleLabel.font = self.lblEmail.font;
        _btnAddMainCar.layer.borderColor = [UIColor whiteColor].CGColor;
        _btnAddMainCar.layer.borderWidth = 1.0;
        _btnAddMainCar.hidden = NO;
    }
    else{
        _btnAddMainCar.hidden = YES;
        [self.imgProfile1 setImageWithURL:[NSURL URLWithString:gUser.main_car]];
        [self.imgProfile1 setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onAddCar:)];
        [self.imgProfile1 addGestureRecognizer:tap];
        
    }
    if (gUser.sub_car.length==0) {
        CGRect rect = self.imgProfile2.frame;
        rect.size.height = rect.size.height/2;

        [_btnAddSubCar setTitle:[Util localized:@"lbl_add_sub_car"] forState:UIControlStateNormal];
        [_btnAddSubCar addTarget:self action:@selector(onAddCar2:) forControlEvents:UIControlEventTouchUpInside];
        _btnAddSubCar.titleLabel.font = self.lblEmail.font;
        _btnAddSubCar.layer.borderColor = [UIColor whiteColor].CGColor;
        _btnAddSubCar.layer.borderWidth = 1.0;
        _btnAddSubCar.hidden = NO;
    }
    else{
        [self.imgProfile2 setImageWithURL:[NSURL URLWithString:gUser.sub_car]];
        [self.imgProfile2 setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onAddCar2:)];
        [self.imgProfile2 addGestureRecognizer:tap];
        _btnAddSubCar.hidden = YES;
    }
    
    
}
-(void)onBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)onSave{
    for (UITextField *text in self.mainSubview.subviews) {
        if ([text isKindOfClass:[UITextField class]]&&text.text.length==0) {
            [self.view makeToast:[Util localized:@"msg_missing_data"]];
            return;
        }
    }
    if (!documentPath) {
        [self.view makeToast:[Util localized:@"msg_missing_data"]];
        return;
    }
    if (gUser.main_car.length==0||gUser.sub_car.length==0){
        [self.view makeToast:[Util localized:@"msg_missing_image"]];
        return;
    }
    gUser.car = [[DriverCar alloc]init];
    gUser.name = self.txtName.text;
    gUser.car.carPlate =self.txtCarPlate.text;
    gUser.car.brand = self.txtBrandOfCar.text;
    gUser.car.model =self.txtModelOfCar.text ;
    gUser.manufacture_year = self.txtYear.text;
    gUser.email = self.txtEmail.text ;
    gUser.car_status = self.txtStatus.text;
    gUser.cart_value = self.txtAccount.text;
    gUser.date_of_birth = self.txtDoB.text;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [ModelManager registerAsDriver:gUser documentPath:documentPath withSuccess:^(NSDictionary *dic) {

            [ModelManager getUserProfileWithSuccess:^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                NSString *status = [dic objectForKey:@"status"];
                if ([status.lowercaseString isEqualToString:@"success"]) {
//                    [self.view makeToast:[Util localized:@"msg_register_driver_success"]];
                    [Util showMessage:[Util localized:@"msg_register_driver_success"] withTitle:[Util localized:@"app_name"]];
                    gUser.is_driver = @"1";
                    gUser.driver.isActive = @"0";
                    [Util saveUser:gUser];
                }
                else{
                    [self.view makeToast:[dic objectForKey:@"message"]];
                }
                
            } failure:^(NSString *err) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                NSString *status = [dic objectForKey:@"status"];
                if ([status.lowercaseString isEqualToString:@"success"]) {
                    [self.view makeToast:[Util localized:@"msg_register_driver_success"]];
                }
            }];
            
            
        } failure:^(NSString *arr) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.view makeToast:arr];
        }];

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(IBAction)onAddCar2:(id)sender{
    selectPhoto = [[UIActionSheet alloc]initWithTitle:[Util localized:@"app_name"]
                                             delegate:self
                                    cancelButtonTitle:[Util localized:@"title_cancel"] destructiveButtonTitle:nil
                                    otherButtonTitles: [Util localized:@"lbl_take_photo"],
                   [Util localized:@"lbl_select_from_galery"], nil];
    isImgProfile1Selecting = NO;
    [selectPhoto showInView:self.view];
}
-(IBAction)onAddCar:(id)sender{
    selectPhoto = [[UIActionSheet alloc]initWithTitle:[Util localized:@"app_name"]
                                             delegate:self
                                    cancelButtonTitle:[Util localized:@"title_cancel"] destructiveButtonTitle:nil
                                    otherButtonTitles: [Util localized:@"lbl_take_photo"],
                   [Util localized:@"lbl_select_from_galery"], nil];
    isImgProfile1Selecting = YES;
    [selectPhoto showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex<2) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self showImagePickerWithSelection:buttonIndex];
        }];
    }
    
}
-(void)showImagePickerWithSelection:(NSInteger)selection{
    pickerCar = [[UIImagePickerController alloc]init];
    pickerCar.delegate = self;
    pickerCar.allowsEditing = YES;
    switch (selection) {
        case 1:
            pickerCar.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            break;
        case 0:
            pickerCar.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            break;
        default:
            break;
    }
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:pickerCar animated:YES completion:nil];
    });
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    if (isDocumentSelecting) {
        isDocumentSelecting = NO;
        
        documentPath = chosenImage;
        return;
    }
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    [imageCache clearDisk];
    if (isImgProfile1Selecting) {
        mainImage = chosenImage;


        [self.imgProfile1 setImage:mainImage];
        _btnAddMainCar.hidden = YES;
        gUser.main_car = [NSString stringWithFormat:@"%@",(NSURL *)[info valueForKey:UIImagePickerControllerReferenceURL]];
        gUser.main_car_image = chosenImage;
    }
    else{
        subImage = chosenImage;
        [self.imgProfile2 setImage:subImage];
        _btnAddSubCar.hidden = YES;
        gUser.sub_car = [NSString stringWithFormat:@"%@",(NSURL *)[info valueForKey:UIImagePickerControllerReferenceURL]];
        gUser.sub_car_image = chosenImage;
    }
    
    
}
- (IBAction)openDocument:(id)sender {
    isDocumentSelecting = YES;
    [self showImagePickerWithSelection:1];
}



@end
