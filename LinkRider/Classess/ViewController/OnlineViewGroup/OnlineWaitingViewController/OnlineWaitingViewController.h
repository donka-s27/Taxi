//
//  OnlineWaitingViewController.h
//  LinkRider
//
//  Created by hieu nguyen on 7/2/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnlineWaitingViewController : UIViewController{
    NSTimer *timer;
    int time;
}

@property (weak, nonatomic) IBOutlet UILabel *lblWaiting;
@property (weak, nonatomic) IBOutlet UILabel *lblDemo;
@property (weak, nonatomic) IBOutlet UIButton *btnOffline;
- (IBAction)onOffline:(id)sender;

@end
