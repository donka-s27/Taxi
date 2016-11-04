//
//  ShowDistanceViewController.h
//  LinkRider
//
//  Created by hieu nguyen on 9/18/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ShowDistanceViewControllerDelegate;
@interface ShowDistanceViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic) IBOutlet UIButton *btnOK;
- (IBAction)onGoToPayment:(id)sender;
@property (assign, nonatomic) id<ShowDistanceViewControllerDelegate>delegate;
@end
@protocol ShowDistanceViewControllerDelegate <NSObject>

-(void)onGotoPayment;

@end