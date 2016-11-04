//
//  WaitingViewController.h
//  LinkRider
//
//  Created by hieu nguyen on 6/26/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBAutoScrollLabel.h"
@interface WaitingViewController : UIViewController<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblRequestLink;
@property (weak, nonatomic) IBOutlet UILabel *lblawaiting;


@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnCancelTrip;



- (IBAction)onCancelTrip:(id)sender;

@end
