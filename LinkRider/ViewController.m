//
//  ViewController.m
//  LinkRider
//
//  Created by hieu nguyen on 6/22/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import "ViewController.h"
#import "NSString+FontAwesome.h"
#import "MBProgressHUD.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "ModelManager.h"

@interface ViewController ()<GIDSignInDelegate>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;
    [self setNeedsStatusBarAppearanceUpdate];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        [self.locationManager requestWhenInUseAuthorization];
        
    }
#endif
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)viewWillAppear:(BOOL)animated{
    if ([Util getBoolForKey:IS_LOGGED_IN_KEY]) {
        gUser = [Util loadUser];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [ModelManager getUserProfileWithSuccess:^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self performSegueWithIdentifier:@"loginFacebook" sender:self];
            if (deviceTokenString.length==0) {
                deviceTokenString = [Util objectForKey:@"Token"];
            }
            
        } failure:^(NSString *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
        //        });
    }
    else{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }

    [self setText];
}
-(void)setText{
    
    self.lblLogin.text = [Util localized:@"login_via_title"];
    
    if (IS_DEMO) {
        [self.btnFBLogin setTitle:[Util localized:@"login_as_driver"] forState:UIControlStateNormal];
        [self.btnGoogleLogin setTitle:[Util localized:@"login_as_passenger"] forState:UIControlStateNormal];
        self.icFB.hidden = TRUE;
        self.icGP.hidden = TRUE;
        
    }
    else{
        [self.btnFBLogin setTitle:[Util localized:@"lbl_facebook"] forState:UIControlStateNormal];
        [self.btnGoogleLogin setTitle:[Util localized:@"lbl_google_plus"] forState:UIControlStateNormal];
        self.icFB.text = [NSString stringWithFormat:@"%@", [NSString fontAwesomeIconStringForIconIdentifier:@"fa-facebook"]];
        self.icGP.text = [NSString stringWithFormat:@"%@", [NSString fontAwesomeIconStringForIconIdentifier:@"fa-google-plus"]];
        
    }
    
    self.lblLogin.userInteractionEnabled = YES;
    [self.icFB.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.icFB.layer setShadowOffset:CGSizeMake(self.icGP.frame.size.width, 20)];
    [self.icGP.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.icGP.layer setShadowOffset:CGSizeMake(self.icGP.frame.size.width, 20)];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [_locationManager stopUpdatingLocation];
}

- (IBAction)onExplain:(id)sender {
    [Util showMessage:[Util localized:@"msg_login_explain"] withTitle:[Util localized:@"app_name"]];
}

- (IBAction)onFacebook:(id)sender {
    
    if (IS_DEMO) {
        [self loginAsDriver];
    }else{
        [self onLoginWithFacebookAccount];
    }
    
}
-(void)onLoginWithFacebookAccount{

    NSArray *permissions = @[@"public_profile",@"email"];
    // if the session is closed, then we open it here, and establish a handler for state changes
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    //    login.loginBehavior = FBSDKLoginBehaviorNative;
    //    [login logOut];
    [login logInWithReadPermissions:permissions fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        } else if (result.isCancelled) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        } else {
            
            if ([FBSDKAccessToken currentAccessToken])
            {
                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, email, gender, picture"}] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
                 {
                     if (!error)
                     {
                         NSLog(@"%@",result);
                         
                         User *u = [[User alloc]init];
//                         u.client_id = [result objectForKey:@"id"];
                         u.email = [result objectForKey:@"email"];
                         u.name = [result objectForKey:@"name"];
                         u.gender = [result objectForKey:@"gender"];
                         u.login_type = @"facebook";
                         u.date_of_birth = [result objectForKey:@"birthday"];
                         u.thumb = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",u.client_id];
                         u.lattitude = [NSString stringWithFormat:@"%f",_locationManager.location.coordinate.latitude];
                         u.logitude = [NSString stringWithFormat:@"%f",_locationManager.location.coordinate.longitude];
                         if (u.email.length>0) {
                             [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                             [ModelManager loginWithUser:u andToken:deviceTokenString Status:YES withSuccess:^(NSString *u) {
                                 [ModelManager getUserProfileWithSuccess:^{
                                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                     [self performSegueWithIdentifier:@"loginFacebook" sender:self];
                                     [Util setBool:YES forKey:IS_LOGGED_IN_KEY];
                                 } failure:^(NSString *err) {
                                     [Util showMessage:err withTitle:nil];
                                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                 }];
                                 
                                 
                             } failure:^(NSString *err) {
                                 [Util showMessage:err withTitle:nil];
                                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                             }];
                         }
                         else{
                             [Util showMessage:[Util localized:@"msg_fb_don't_have_email"] withTitle:[Util localized:@"app_name"]];
                             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                         }
                     }
                     else{
                         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                     }
                 }];
            }
            else
            {
                NSLog(@"Access denied");
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }
        }
        
    }];
}
- (IBAction)onGooglePlus:(id)sender {
    if (IS_DEMO) {
        [self loginAsPassenger];
    }else{
        [self onLoginAsGoogleAccount];
    }
}

-(void)onLoginAsGoogleAccount{
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[GIDSignIn sharedInstance] signIn];
}

#pragma mark -GoogleSignin Delegate
- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    if (error) {
        [Util showMessage:[Util localized:@"msg_login_again"] withTitle:nil];
        
    } else {
        User *userResult = [[User alloc]init];
        userResult.name =  user.profile.name;
        userResult.gender = @"";
        userResult.email = user.profile.email;
        if (user.profile.hasImage) {
            userResult.thumb = [user.profile imageURLWithDimension:150].absoluteString;
        }else{
        userResult.thumb = @"";
        }
        userResult.lattitude = [NSString stringWithFormat:@"%f",_locationManager.location.coordinate.latitude];
        userResult.logitude = [NSString stringWithFormat:@"%f",_locationManager.location.coordinate.longitude];
      
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [ModelManager loginWithUser:userResult andToken:deviceTokenString Status:YES withSuccess:^(NSString *u) {
                [ModelManager getUserProfileWithSuccess:^{
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    [self performSegueWithIdentifier:@"loginGoogle" sender:self];
                    [Util setBool:YES forKey:IS_LOGGED_IN_KEY];
                } failure:^(NSString *err) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    [Util showMessage:err withTitle:nil];
                    
                }];
                
                
                //                            [self signOut];
            } failure:^(NSString *err) {
                [Util showMessage:err withTitle:err];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }];
    }
    
}

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signOut {
    [[GIDSignIn sharedInstance] signOut];
}
-(void)loginAsDriver{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    User *user = [[User alloc]init];
    user.name = @"Vin Diesel";
    user.gender = @"male";
    user.email = @"nxhars@gmail.com";
    user.thumb = @"https://lh6.googleusercontent.com/-TGQ6hweCZpk/AAAAAAAAAAI/AAAAAAAAAJ0/8IbXpKGLcUg/photo.jpg";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [ModelManager loginWithUser:user andToken:deviceTokenString Status:YES withSuccess:^(NSString *u) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self performSegueWithIdentifier:@"loginGoogle" sender:self];
            [Util setBool:YES forKey:IS_LOGGED_IN_KEY];
            [self signOut];
        } failure:^(NSString *err) {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    });
}
-(void)loginAsPassenger{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    User *u = [[User alloc]init];
    
    u.client_id = @"162035877492930";
    
    u.email = @"fruity.hieunx@gmail.com";
    u.name = @"Christ Ho";
    u.gender = @"male";
    u.login_type = @"facebook";
    
    u.thumb = @"https://graph.facebook.com/162035877492930/picture?type=large";
    u.lattitude = [NSString stringWithFormat:@"%f",_locationManager.location.coordinate.latitude];
    u.logitude = [NSString stringWithFormat:@"%f",_locationManager.location.coordinate.longitude];
    if (u.email.length>0) {
        [ModelManager loginWithUser:u andToken:deviceTokenString Status:YES withSuccess:^(NSString *u) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self performSegueWithIdentifier:@"loginFacebook" sender:self];
            [Util setBool:YES forKey:IS_LOGGED_IN_KEY];
        } failure:^(NSString *err) {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
        
    }
    
}


@end
