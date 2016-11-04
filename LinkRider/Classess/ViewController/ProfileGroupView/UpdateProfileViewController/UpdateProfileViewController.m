//
//  UpdateProfileViewController.m
//  LinkRider
//
//  Created by hieu nguyen on 6/29/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import "UpdateProfileViewController.h"
#import "UIImageView+WebCache.h"
#import "ModelManager.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "CityObj.h"
#import "StateObj.h"

@interface UpdateProfileViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation UpdateProfileViewController{
    UIPickerView *pickerState,*pickerCity;
    NSArray *arrCity;
    CityObj *cityObjThumb;
    StateObj *stateObjThumb;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.btnBack setTarget:self];
    [self.btnBack setAction:@selector(onBack)];
    [self.btnSave setTarget:self];
    [self.btnSave setAction:@selector(onSave)];
    isDocumentSelecting = NO;
    [self settingApp];
    
    // Do any additional setup after loading the view.
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)viewDidLayoutSubviews{
    if ((![[NSString stringWithFormat:@"%@",gUser.is_driver] isEqualToString:@"1"])) {
        self.scrollView.contentSize = CGSizeMake(320, self.lblDesc.frame.size.height+self.lblDesc.frame.origin.y+20);
    }
    else{
        self.scrollView.contentSize = CGSizeMake(320, self.imgProfile1.frame.size.height+self.imgProfile1.frame.origin.y+20);
    }
    
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

- (void)viewDidAppear:(BOOL)animated{
[self setText];
}
-(void)settingApp{
    arrCity = [[NSArray alloc] init];
    stateObjThumb = [[StateObj alloc] initWithDict:@{}];
    cityObjThumb = [[CityObj alloc] initWithDict:@{}];
    if (gArrState.count == 0) {
        _txtState.enabled = NO;
    }else{
        _txtState.enabled = YES;
        for (StateObj *objStateThumb in gArrState) {
            if (objStateThumb.stateId == gUser.stateId) {
                stateObjThumb = objStateThumb;
                arrCity = stateObjThumb.arrCites;
                break;
            }
        }
    }
    
//    if (arrCity.count == 0) {
//        _txtCity.enabled = NO;
//    }else{
//        _txtCity.enabled = YES;
//        for (CityObj *objCity  in arrCity) {
//            if (objCity.cityId == gUser.cityId) {
//                cityObjThumb = objCity;
//                break;
//            }
//        }
//    }
    
    
    self.txtEmail.enabled = NO;
    self.txtAccount.enabled = NO;
    self.icAvatar.text =  [NSString fontAwesomeIconStringForIconIdentifier:@"fa-user-plus"];

    self.icCarPlate.text =  [NSString fontAwesomeIconStringForIconIdentifier:@"fa-cab"];
//    self.icPhone.text =  [NSString fontAwesomeIconStringForIconIdentifier:@"fa-mobile"];
    self.icBrandOfCar.text =  [NSString fontAwesomeIconStringForIconIdentifier:@"fa-glass"];
    self.icModelOfCar.text =  [NSString fontAwesomeIconStringForIconIdentifier:@"fa-trophy"];
    self.icYear.text =  [NSString fontAwesomeIconStringForIconIdentifier:@"fa-calendar"];

    self.icDesc.text = @"\ue647";
    self.icPhone.text =  @"\ue670";
    self.icEmail.text =  @"\ue639";
    self.icAddress.text =  @"\ue638";
    self.icName.text = @"\ue605";
    
    self.icDocument.text =  [NSString fontAwesomeIconStringForIconIdentifier:@"fa-file-pdf-o"];
    self.icStatus.text =  [NSString fontAwesomeIconStringForIconIdentifier:@" fa-bar-chart"];
    self.icAccount.text =  [NSString fontAwesomeIconStringForIconIdentifier:@"fa-money"];
    
    [self.lblHeaderTitle setTitle:[Util localized:@"lbl_update_profile"]];
    yearPicker = [[UIDatePicker alloc]init];
    yearPicker.datePickerMode = UIDatePickerModeDate;
    [yearPicker addTarget:self action:@selector(incidentYearValueChanged:) forControlEvents:UIControlEventValueChanged];
    [yearPicker setValue:[Util colorWithHexString:@"#097894"] forKeyPath:@"textColor"];
    yearPicker.maximumDate = [NSDate date];
    self.txtYear.inputView = yearPicker;
    
//    pickerCity = [[UIPickerView alloc] init];
//    pickerCity.delegate =self;
//    pickerCity.dataSource = self;
//    _txtCity.inputView = pickerCity;
    
    pickerState = [[UIPickerView alloc] init];
    pickerState.delegate =self;
    pickerState.dataSource = self;
    _txtState.inputView = pickerState;
    
    self.btnSelectDocument.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnSelectDocument.layer.borderWidth = 1.0;
    
    [self configTextField:_txtCity];
    [self configTextField:_txtState];
  
    for (UITextField *text in self.mainSubView.subviews) {
        if ([text isKindOfClass:[UITextField class]]) {
            [self configTextField:text];
        }
    }

    
    [self.btnBack setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont fontAwesomeFontOfSize:20], NSFontAttributeName,
                                          [UIColor whiteColor], NSForegroundColorAttributeName,
                                          nil]
                                forState:UIControlStateNormal];
    
    [self.btnBack setTitle:[NSString fontAwesomeIconStringForEnum:FALongArrowLeft] ];
    
    
    [self.btnSave setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont fontWithName:@"Pe-icon-7-stroke" size:26], NSFontAttributeName,
                                          [UIColor whiteColor], NSForegroundColorAttributeName,
                                          nil]
                                forState:UIControlStateNormal];
    
    [self.btnSave setTitle:@"\ue65f"];
    
}

-(void)configTextField:(UITextField*)text{
    text.layer.borderColor = [UIColor whiteColor].CGColor;
    text.layer.borderWidth = 1.0;
    [text setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 15, 0)];
    text.leftView = paddingView;
    text.leftViewMode = UITextFieldViewModeAlways;
    [text setReturnKeyType:UIReturnKeyDone];
    [text addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
}

-(void)setText{
    
    
    self.lblStatus.text = [Util localized:@"lbl_status"];
    self.lblAccount.text = [Util localized:@"lbl_account"];
    self.lblAvatar.text = [Util localized:@"lbl_avatar"];
    self.lblName.text = [Util localized:@"lbl_name"];
    self.lblCarPlate.text = [Util localized:@"lbl_car_plate"];
    self.lblPhone.text = [Util localized:@"lbl_phone"];
    self.lblBrandOfCar.text = [Util localized:@"lbl_brand_of_car"];
    self.lblModelOfCar.text = [Util localized:@"lbl_model_of_car"];
    self.lblYear.text = [Util localized:@"lbl_year"];
    self.lblEmail.text = [Util localized:@"lbl_email"];
    self.lblState.text = [Util localized:@"lbl_state"];
    self.lblCity.text = [Util localized:@"lbl_city"];
    self.lblAddress.text = [Util localized:@"lbl_address"];
    self.lblDesc.text = [Util localized:@"lbl_description"];
    self.lblDocument.text = [Util localized:@"lbl_document"];

    [self.imgAvatar setImageWithURL:[NSURL URLWithString:gUser.thumb]];
    self.imgAvatar.layer.cornerRadius=self.imgAvatar.frame.size.height /2;
    self.imgAvatar.layer.borderWidth=1;
    self.imgAvatar.layer.masksToBounds = YES;
    self.imgAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
    self.txtName.text = gUser.name;
    self.txtName.enabled = NO;
    self.txtPhone.text = gUser.phone;
    self.txtEmail.text = gUser.email;
    self.txtDescValue.text = gUser.descriptions;
    self.txtAddress.text = gUser.address;
    self.txtCity.text = gUser.city;
    self.txtState.text = gUser.state;
    
    if (![[NSString stringWithFormat:@"%@",gUser.is_driver] isEqualToString:@"1"]) {
        [self setupPassengerProfile];
    }
    else{
        [self setupDriverProfile];
    }
    
}


- (IBAction) incidentYearValueChanged:(id)sender{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    _txtYear.text = [dateFormatter stringFromDate:[yearPicker date]];
    
}
-(void)setupPassengerProfile{

    
}
-(void)setupDriverProfile{
    self.txtCarPlate.text = gUser.car.carPlate;
    self.txtBrandOfCar.text = gUser.car.brand;
    self.txtModelOfCar.text = gUser.car.model;
    self.txtYear.text = gUser.car.year;
    
    self.txtStatus.text = gUser.car.status;
    self.txtAccount.text = gUser.driver.bankAccount;
    
//    yearPicker.date = [Util dateFromString:self.txtYear.text format:@"yyyy"];
    
    if (gUser.car.image1.length==0) {
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
        [self.imgProfile1 setImageWithURL:[NSURL URLWithString:gUser.car.image1]];
        [self.imgProfile1 setUserInteractionEnabled:YES];
        

    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onAddCar:)];
    [self.imgProfile1 addGestureRecognizer:tap];
    if (gUser.car.image2.length==0) {
        [_btnAddSubCar setTitle:[Util localized:@"lbl_add_sub_car"] forState:UIControlStateNormal];
        [_btnAddSubCar addTarget:self action:@selector(onAddCar2:) forControlEvents:UIControlEventTouchUpInside];
        _btnAddSubCar.titleLabel.font = self.lblEmail.font;
        _btnAddSubCar.layer.borderColor = [UIColor whiteColor].CGColor;
        _btnAddSubCar.layer.borderWidth = 1.0;
        _btnAddSubCar.hidden = NO;
    }
    else{
        _btnAddSubCar.hidden = YES;
        [self.imgProfile2 setImageWithURL:[NSURL URLWithString:gUser.car.image2]];
        [self.imgProfile2 setUserInteractionEnabled:YES];
        
    }

    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onAddCar2:)];
    [self.imgProfile2 addGestureRecognizer:tap2];
}
-(void)onBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)onSave{
    
    if (_txtDescValue.text.length==0) {
        [self.view makeToast:[Util localized:@"msg_missing_data"]];
        return;
    }
//    if (_txtPhone.text.length==0||_txtDescValue.text.length==0||_txtAddress.text.length==0) {
//        [self.view makeToast:[Util localized:@"msg_missing_data"]];
//        return;
//    }
    User *userThumb = [[User alloc] init];
    userThumb = gUser;
    userThumb.phone = _txtPhone.text;
    userThumb.descriptions = _txtDescValue.text;
    userThumb.address = _txtAddress.text;
//    userThumb.cityId = cityObjThumb.cityId;
    userThumb.city = _txtCity.text;
    userThumb.stateId = stateObjThumb.stateId;
    userThumb.state = stateObjThumb.stateName;
    
    if ([[NSString stringWithFormat:@"%@",gUser.is_driver] isEqualToString:@"1"]) {
        if (_txtCarPlate.text.length==0||_txtBrandOfCar.text.length==0||_txtModelOfCar.text.length==0||_txtYear.text.length==0) {
            [self.view makeToast:[Util localized:@"msg_missing_data"]];
            return;
        }
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        if (!userThumb.car){
            userThumb.car = [[DriverCar alloc]init];
        }
        userThumb.car.carPlate = _txtCarPlate.text;
        userThumb.car.brand = _txtBrandOfCar.text;
        userThumb.car.model = _txtModelOfCar.text;
        userThumb.car.year = _txtYear.text;
        userThumb.manufacture_year = _txtYear.text;
        userThumb.car.status =self.txtStatus.text;
        
            [ModelManager updateProfileWithDriver:userThumb andDocument:documentPath withSuccess:^(NSDictionary *dic) {
                gUser = userThumb;
                gUser.driver.update_pending = @"1";
                [ModelManager updateProfileWithUser:userThumb withSuccess:^(NSString *str) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    [self.view makeToast:[Util localized:@"msg_update_profile_success"]];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                } failure:^(NSString *err) {
                    [self.view makeToast:err];
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                }];
            } failure:^(NSString *err) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [self.view makeToast:err];
                
            }];

    }
    else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [ModelManager updateProfileWithUser:userThumb withSuccess:^(NSString *str) {
                gUser = userThumb;
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [Util showMessage:[Util localized:@"msg_update_profile_success"] withTitle:[Util localized:@"app_name"]];
                [self.navigationController popViewControllerAnimated:YES];
                
            } failure:^(NSString *err) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [self.view makeToast:err];
            }];
    }
   
   
    
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
    isImage1Selecting = NO;
    [selectPhoto showInView:self.view];
}


-(IBAction)onAddCar:(id)sender{
    selectPhoto = [[UIActionSheet alloc]initWithTitle:[Util localized:@"app_name"]
                                             delegate:self
                                    cancelButtonTitle:[Util localized:@"title_cancel"] destructiveButtonTitle:nil
                                    otherButtonTitles: [Util localized:@"lbl_take_photo"],
                   [Util localized:@"lbl_select_from_galery"], nil];
    isImage1Selecting = YES;
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
    [self presentViewController:pickerCar animated:YES completion:nil];
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
    if (isImage1Selecting) {

        [self.imgProfile1 setImage:chosenImage];
        _btnAddMainCar.hidden = YES;
        gUser.main_car = [NSString stringWithFormat:@"%@",(NSURL *)[info valueForKey:UIImagePickerControllerReferenceURL]];
        gUser.main_car_image = chosenImage;
    }
    else{

        [self.imgProfile2 setImage:chosenImage];
        _btnAddSubCar.hidden = YES;
        gUser.sub_car = [NSString stringWithFormat:@"%@",(NSURL *)[info valueForKey:UIImagePickerControllerReferenceURL]];
        gUser.sub_car_image = chosenImage;
    }
    
    
}
- (IBAction)onDocument:(id)sender {
    isDocumentSelecting = YES;
    [self showImagePickerWithSelection:1];
}

#pragma mark- Uipickerview Datasource (state, city)
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView == pickerCity) {
        return arrCity.count;
    }else if (pickerView == pickerState){
        return gArrState.count;
    }else{
        return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView == pickerCity) {
        CityObj *objCity = arrCity[row];
        return objCity.cityName;
    }else if (pickerView == pickerState){
        StateObj* objState = gArrState[row];
        return objState.stateName;
    }else{
        return @"";
    }

}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView == pickerCity) {
        cityObjThumb = arrCity[row];
        _txtCity.text = cityObjThumb.cityName;
    }else if (pickerView == pickerState){
        stateObjThumb = gArrState[row];
        _txtState.text = stateObjThumb.stateName;
//        arrCity = stateObjThumb.arrCites;
//        if (arrCity.count == 0) {
//            _txtCity.enabled = NO;
//        }else{
//            _txtCity.enabled = YES;
//        }
//        cityObjThumb = [[CityObj alloc] initWithDict:[[NSDictionary alloc] init]];
//        _txtCity.text = @"";
    }
}

@end
