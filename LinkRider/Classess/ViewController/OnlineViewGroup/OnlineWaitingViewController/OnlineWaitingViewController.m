//
//  OnlineWaitingViewController.m
//  LinkRider
//
//  Created by hieu nguyen on 7/2/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import "OnlineWaitingViewController.h"

@interface OnlineWaitingViewController ()

@end

@implementation OnlineWaitingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    time = 2;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onStartTrip) userInfo:nil repeats:YES];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self.navigationController setNavigationBarHidden:YES];
    [self setText];
}

-(void)onStartTrip{
    if (time>0) {
        time--;
        self.lblDemo.text = [NSString stringWithFormat:[Util localized:@"demo_title"],time];
    }
    else{
        [self performSegueWithIdentifier:@"startTrip" sender:self];
        [timer invalidate];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [timer invalidate];
    [self.navigationItem setHidesBackButton:NO animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)setText{

    self.lblWaiting.text = [Util localized:@"waiting_title"];
    
    self.lblDemo.text = [NSString stringWithFormat:[Util localized:@"demo_title"],time];
    self.btnOffline.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnOffline.layer.borderWidth = 1.0f;
    
    [self.btnOffline setTitle:[Util localized:@"lbl_offline"] forState:UIControlStateNormal];
    

}
- (IBAction)onOffline:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
