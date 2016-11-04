//
//  WaitingViewController.m
//  LinkRider
//
//  Created by hieu nguyen on 6/26/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import "WaitingViewController.h"
#import "MapviewController.h"
#import "ModelManager.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "Appdelegate.h"
#import "NSString+FontAwesome.h"
#import "UIImageView+WebCache.h"
#import "UIFont+FontAwesome.h"
#import "ListPassengerCell.h"
#import "StartTripViewController.h"
#import "RatingTripViewController.h"
@interface WaitingViewController ()

@end

@implementation WaitingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    if (notificationsDic||(gTrip.tripId>0)) {
        if (gTrip.startTime.length>0) {
            [self onStartTrip];
        }
    }
    else{
        [self sendRequest];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onStartTrip) name:DRIVER_CONFIRM_KEY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillBecomForceGround) name:WILL_ENTER_FORCE_GROUND object:nil];
}
- (void)appWillBecomForceGround{
    
    if (self) {
        [self reloadStatus];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self.navigationController setNavigationBarHidden:YES];
    [self setText];
    //    if (notificationsDic) {
    //        [self onStartTrip];
    //    }
}

- (void)reloadStatus{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ModelManager showMyTripsWithSuccess:^(NSMutableArray *arr) {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        for (Trips *trip in arr) {
            if ([trip.status isEqualToString:TRIP_STATUS_APPROACHING]||[trip.status isEqualToString:TRIP_STATUS_IN_PROGRESS]||[trip.status isEqualToString:TRIP_STATUS_PENDING_PAYMENT]) {
                
                gTrip = trip;
                if ([trip.status isEqualToString:TRIP_STATUS_APPROACHING]) {
                    if (trip.driverId.length>0) {
                        [self onStartTrip];
                    }
                    else{
                      
                    }
                    return;
                }
                else if([trip.status isEqualToString:TRIP_STATUS_IN_PROGRESS]){
                    
                    StartTripViewController *start = [self.storyboard instantiateViewControllerWithIdentifier:@"StartTripViewController"];
                    [self.navigationController pushViewController:start animated:YES];
                    
                    return;
                    
                }
                else if ([trip.status isEqualToString:TRIP_STATUS_PENDING_PAYMENT]){
                    RatingTripViewController *start = [self.storyboard instantiateViewControllerWithIdentifier:@"RatingTripViewController"];
                    [self.navigationController pushViewController:start animated:YES];
                    return;
                }
                
            }
            
        }
        
       
    } andFailure:^(NSString *err) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];

  }

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationItem setHidesBackButton:NO animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
}
-(void)sendRequest{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ModelManager sendRequestWithSuccess:^(NSDictionary *dic) {
        NSLog(@"response dic :%@",dic);
        if ([[dic objectForKey:@"status"] isEqualToString:@"ERROR"]) {
            [Util showMessage:[dic objectForKey:@"message"] withTitle:[Util localized:@"app_name"]];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [ModelManager showMyRequestWithSuccess:^(NSMutableArray *arr) {
                if (arr.count>0) {
                    gTrip = [arr objectAtIndex:0];
                }
                
            } andFailure:^(NSString *err) {
                
            }];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } andFailure:^(NSString *err) {
        [Util showMessage:err withTitle:[Util localized:@"app_name"]];
        //        [self.navigationController popViewControllerAnimated:YES];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}
-(void)getTripDetail{
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setText{
    
    NSDictionary *fontDict = @{NSFontAttributeName:[UIFont fontAwesomeFontOfSize:10],NSForegroundColorAttributeName:[Util colorWithHexString:@"#e8c03a"]};
    
    self.lblRequestLink.text = [Util localized:@"request_link_title"];
    
    NSMutableAttributedString *att =  [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[NSString fontAwesomeIconStringForEnum:FACircle]] attributes: fontDict];
    NSDictionary *arialDict = [NSDictionary dictionaryWithObject: STEP_TITLE_FONT forKey:NSFontAttributeName];
    NSMutableAttributedString *aAttrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[Util localized:@"request_link_title"]] attributes: arialDict];
    
    [att appendAttributedString:aAttrString];
    
    for(int i=0;i<4;i++){
        
        NSMutableAttributedString *aAttrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[NSString fontAwesomeIconStringForEnum:FACircleO]] attributes: fontDict];
        [att appendAttributedString:aAttrString];
    }
    self.lblRequestLink.attributedText =att;
 
    self.lblawaiting.text = [Util localized:@"awaiting_title"];
    
    [self.btnCancel setTitle:[NSString fontAwesomeIconStringForEnum:FALongArrowLeft] forState:UIControlStateNormal];
    [self.btnCancelTrip setTitle:[Util localized:@"lbl_cancel_trip"].uppercaseString forState:UIControlStateNormal];
    //    [_ratingStar setTintColor:[UIColor whiteColor]];
    
}

-(void)onStartTrip{
    
    [self performSegueWithIdentifier:@"orderConfirm" sender:self];
    
    
}
- (IBAction)onCancelTrip:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self cancelTrip];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(cancelTrip) userInfo:nil repeats:NO];
    }
    else{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }
}
-(void)cancelTrip{
    if (gTrip.tripId.length > 0) {
        [ModelManager cancelRequest:gTrip withSuccess:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"resetAllPoint" object:nil userInfo:notificationsDic];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.view makeToast:[Util localized:@"msg_cancel_success"]];
            gTrip = [[Trips alloc]init];
            [self.navigationController popViewControllerAnimated:YES];
            
        } andFailure:^(NSString *err) {
            if (err.length==0) {
                [self.view makeToast:[Util localized:@"msg_cancel_failed"]];
            }
            [self.view makeToast:err];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }else{
        [ModelManager showMyRequestWithSuccess:^(NSMutableArray *arr) {
            if (arr.count>0) {
                gTrip = [arr objectAtIndex:0];
                [self cancelTrip];
            }else{
                gTrip = [[Trips alloc]init];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            
        } andFailure:^(NSString *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [Util showMessage:err withTitle:nil];
            
        }];
    }
    
}

#pragma mark tableview datasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 186;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ListPassengerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPassengerCell"];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ListPassengerCell" owner:self options:nil];
        cell = (ListPassengerCell *)[nib objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    
    cell.lblTitle.text = gUser.name;
    cell.lblPhone.text = gUser.phone;
    cell.ratingValue.rating = [gUser.passenger_rating_count floatValue]/2;
    cell.lblStartValue.text = gTrip.startLocation.name;
    cell.lblEndValue.text = gTrip.endLocation.name;
    [cell.imgProfile setImageWithURL:[NSURL URLWithString:gUser.thumb]];
    
    if ([gTrip.link isEqualToString:@"I"]) {
        cell.lblSeatValue.text = @"1";
    }
    if ([gTrip.link isEqualToString:@"II"]) {
        cell.lblSeatValue.text = @"2";
    }
    if ([gTrip.link isEqualToString:@"III"]) {
        cell.lblSeatValue.text = @"3";
    }
    
    
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}
@end
