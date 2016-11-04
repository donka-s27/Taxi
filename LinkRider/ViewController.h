//
//  ViewController.h
//  LinkRider
//
//  Created by hieu nguyen on 6/22/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
//#import <GooglePlus/GooglePlus.h>
//#import <GoogleOpenSource/GoogleOpenSource.h>
#import <Google/SignIn.h>
@interface ViewController : UIViewController<CLLocationManagerDelegate,GIDSignInUIDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnFBLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnGoogleLogin;

@property (weak, nonatomic) IBOutlet UILabel *icFB;
@property (weak, nonatomic) IBOutlet UILabel *icGP;
@property(nonatomic, retain) CLLocationManager *locationManager;
- (IBAction)onExplain:(id)sender;

- (IBAction)onFacebook:(id)sender;
- (IBAction)onGooglePlus:(id)sender;
@end

