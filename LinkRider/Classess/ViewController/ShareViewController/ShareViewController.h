//
//  ShareViewController.h
//  LinkRider
//
//  Created by hieu nguyen on 7/2/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>

@interface ShareViewController : UIViewController<GPPShareDelegate,GPPSignInDelegate>{
    
    float driver_share_bonus;
    float passenger_share_bonus;
}
@property (weak, nonatomic) IBOutlet UINavigationItem *lblHeaderTitle;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButton;

@property (weak, nonatomic) IBOutlet UIImageView *imgTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnFacebook;
@property (weak, nonatomic) IBOutlet UIButton *btnGoogle;
@property (weak, nonatomic) IBOutlet UILabel *icFB;
@property (weak, nonatomic) IBOutlet UILabel *icGP;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;

- (IBAction)onFacebook:(id)sender;
- (IBAction)onGoogle:(id)sender;
- (IBAction)onExplain:(id)sender;

@end
