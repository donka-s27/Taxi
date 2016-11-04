//
//  ShowDistanceViewController.m
//  LinkRider
//
//  Created by hieu nguyen on 9/18/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import "ShowDistanceViewController.h"

@interface ShowDistanceViewController ()

@end

@implementation ShowDistanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    self.lblTitle.text = [Util localized:@"lbl_real_distance"];
    [self onUpdate];
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(onUpdate) userInfo:nil repeats:YES];
    [self.btnOK setTitle:[Util localized:@"title_ok"]forState:UIControlStateNormal];

}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)onUpdate{
    float distance = [[Util objectForKey:[NSString stringWithFormat:@"tripDistance%@",gTrip.tripId]] floatValue];
//    float lastDistance = [[Util objectForKey:[NSString stringWithFormat:@"lastTripDistance%@",gTrip.tripId]] floatValue];
//    distance+=lastDistance;

    self.lblDistance.text =[NSString stringWithFormat:@"%@ %.2f km",[Util localized:@"lbl_distance_calculated"],distance/1000] ;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



- (IBAction)onGoToPayment:(id)sender {
    if ([self.delegate respondsToSelector:@selector(onGotoPayment)]) {
        [self.delegate onGotoPayment];
    }
}
@end
