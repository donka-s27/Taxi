//
//  OnlineViewController.h
//  LinkRider
//
//  Created by hieu nguyen on 7/2/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ListPassengerViewController.h"
@interface OnlineViewController : UIViewController<CLLocationManagerDelegate,UIAlertViewDelegate>{

    CLLocation *currentLocation;
}
@property (weak, nonatomic) IBOutlet UINavigationItem *lblHeaderTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblRequest;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealBtn;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;
@property (weak, nonatomic) IBOutlet UIButton *btnOnline;
@property(nonatomic, retain) CLLocationManager *locationManager;

- (IBAction)onSelectOnlineOrOffline:(id)sender;

@end
