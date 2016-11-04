//
//  ShareViewController.m
//  LinkRider
//
//  Created by hieu nguyen on 7/2/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import "ShareViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <GooglePlus/GooglePlus.h>
#import "ModelManager.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
@import SafariServices;

@interface ShareViewController ()<FBSDKSharingDelegate, SFSafariViewControllerDelegate>

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [self getGeneralSetting];
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
}
-(void)setText{
    SWRevealViewController *revealViewController = self.revealViewController;
    [self.navigationController.navigationBar setBarTintColor:[Util colorWithHexString:@"#333333" alpha:1]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"Raleway-Medium" size:20], NSFontAttributeName, nil]];
    [self.revealButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                            [UIFont fontAwesomeFontOfSize:24], NSFontAttributeName,
                                            [UIColor whiteColor], NSForegroundColorAttributeName,
                                            nil]
                                  forState:UIControlStateNormal];
    
    [self.revealButton setTitle:@"\uf0c9"];
    if ( revealViewController )
    {
        [self.revealButton setTarget: self.revealViewController];
        [self.revealButton setAction: @selector(revealToggle:)];
        [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
    [self.lblHeaderTitle setTitle:[Util localized:@"header_share"]];
    [self.lblDesc setText:[NSString stringWithFormat:[Util localized:@"lbl_share_title"],passenger_share_bonus]];
    if ([[Validator getSafeString:gUser.is_driver] isEqualToString:@"1"]) {
        [self.lblDesc setText:[NSString stringWithFormat:[Util localized:@"lbl_share_title"],driver_share_bonus]];
    }
    [self.btnFacebook setTitle:[Util localized:@"lbl_facebook"] forState:UIControlStateNormal];
    [self.btnGoogle setTitle:[Util localized:@"lbl_google_plus"] forState:UIControlStateNormal];
    self.lblDesc.userInteractionEnabled = YES;
    
    self.icFB.text = [NSString stringWithFormat:@"%@", [NSString fontAwesomeIconStringForIconIdentifier:@"fa-facebook"]];
    self.icGP.text = [NSString stringWithFormat:@"%@", [NSString fontAwesomeIconStringForIconIdentifier:@"fa-google-plus"]];
    
    [self.icFB.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.icFB.layer setShadowOffset:CGSizeMake(self.icGP.frame.size.width, 20)];
    [self.icGP.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.icGP.layer setShadowOffset:CGSizeMake(self.icGP.frame.size.width, 20)];
    
    
}
-(void)getGeneralSetting{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
        [ModelManager generalSettingWithSuccess:^(NSDictionary *dic) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            driver_share_bonus = [Validator getSafeFloat:dic[@"driver_share_bonus"]];
            passenger_share_bonus = [Validator getSafeFloat:dic[@"passenger_share_bonus"]];
        } andFailure:^(NSString *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];

}
- (IBAction)onFacebook:(id)sender {
 
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:APP_URL_TO_SHARE];

    FBSDKShareDialog *shareDialog = [[FBSDKShareDialog alloc] init];
    shareDialog.delegate=self;
    shareDialog.fromViewController = self;
    shareDialog.shareContent = content;
    [shareDialog show];
}
-(void)sharerDidCancel:(id<FBSDKSharing>)sharer{
    NSLog(@"sharing facebook cancel!");
}
-(void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
    
}
-(void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{
    [self shareWithSocial:@"f"];
}
- (IBAction)onGoogle:(id)sender {
    
        NSURLComponents* urlComponents = [[NSURLComponents alloc]
                                          initWithString:@"https://plus.google.com/share"];
        urlComponents.queryItems = @[[[NSURLQueryItem alloc]
                                      initWithName:@"url"
                                      value:APP_URL_TO_SHARE]];
        NSURL* url = [urlComponents URL];
    
        if ([SFSafariViewController class]) {
            // Open the URL in SFSafariViewController (iOS 9+)
            SFSafariViewController* controller = [[SFSafariViewController alloc]
                                                  initWithURL:url];
            controller.delegate = self;
            [self presentViewController:controller animated:YES completion:nil];
        } else {
            // Open the URL in the device's browser
            [[UIApplication sharedApplication] openURL:url];
        }
}

#pragma mark - SafariVC delegate
- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller{
    [self shareWithSocial:@"g"];
}


-(void)shareWithSocial:(NSString *)s{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   
        [ModelManager shareWithType:s WithSuccess:^{
            [self.view makeToast:[Util localized:@"msg_share_success"]];
            [ModelManager getUserProfileWithSuccess:^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            } failure:^(NSString *err) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }];
        } andFailure:^(NSString *err) {
            [self.view makeToast:err];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
}
@end
