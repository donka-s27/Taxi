//
//  ListPassengerViewController.m
//  LinkRider
//
//  Created by hieu nguyen on 7/2/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import "ListPassengerViewController.h"
#import "ModelManager.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "Trips.h"
#import "UIFont+FontAwesome.h"
#import "NSString+FontAwesome.h"
#import "UIImageView+WebCache.h"
@interface ListPassengerViewController ()

@end

@implementation ListPassengerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    self.tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelTrip) name:PASSENGER_CANCEL_REQUEST object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelTrip) name:DRIVER_RECEIVE_REQUEST_KEY object:nil];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillBecomForceGround) name:WILL_ENTER_FORCE_GROUND object:nil];
}
- (void)appWillBecomForceGround{
    
    if (self) {
        [self showMyTrip];
    }
    
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
    notificationsDic = nil;
   
    [self.navigationItem setHidesBackButton:NO animated:YES];
    [self.navigationController setNavigationBarHidden:YES];
    [self setText];
    [self showMyTrip];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PASSENGER_CANCEL_REQUEST object:nil];
}
-(void)setText{
    self.lblDesc.text = [Util localized:@"lbl_receive_link_by_passenger"];
    [self.btnBack setTitle:[NSString fontAwesomeIconStringForEnum:FALongArrowLeft] forState:UIControlStateNormal];
    NSDictionary *fontDict = @{NSFontAttributeName:[UIFont fontAwesomeFontOfSize:10],NSForegroundColorAttributeName:[Util colorWithHexString:@"#e8c03a"]};
    
    NSMutableAttributedString *att =  [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[NSString fontAwesomeIconStringForEnum:FACircle]] attributes: fontDict];
    
    
    
    NSDictionary *arialDict = [NSDictionary dictionaryWithObject: STEP_TITLE_FONT forKey:NSFontAttributeName];
    NSMutableAttributedString *aAttrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[Util localized:@"request_link_title"]] attributes: arialDict];
    
    [att appendAttributedString:aAttrString];
    
    for(int i=0;i<4;i++){
        
        NSMutableAttributedString *aAttrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",[NSString fontAwesomeIconStringForEnum:FACircleO]] attributes: fontDict];
        [att appendAttributedString:aAttrString];
    }
    self.lblRequest.attributedText =att;
    
    
}
-(void)onCancelTrip{
    if (self) {
        [self showMyTrip];
    }
    
}
-(void)showMyTrip{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [ModelManager showMyRequestWithSuccess:^(NSMutableArray *arr) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            self.tripArr = [arr copy];
            [self.tblView reloadData];
            
            if (self.tripArr.count==0) {
//                [Util showMessage:[Util localized:@"msg_trip_cancel_by_passenger"] withTitle:[Util localized:@"app_name"]];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        } andFailure:^(NSString *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
//    });
}
-(IBAction)onBack:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark tableview datasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 186;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tripArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ListPassengerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPassengerCell"];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ListPassengerCell" owner:self options:nil];
        cell = (ListPassengerCell *)[nib objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    Trips *t = [self.tripArr objectAtIndex:indexPath.row];
    cell.lblTitle.text = t.passenger.name;
    cell.lblPhone.text = [Util encryptPhoneNumber:t.passenger.phone];
    cell.ratingValue.rating = [t.passenger.passenger_rating_count floatValue]/2;
    cell.lblStartValue.text = t.startLocation.name;
    cell.lblEndValue.text = t.endLocation.name;
    [cell.imgProfile setImageWithURL:[NSURL URLWithString:t.passenger.thumb]];
    
    if ([t.link isEqualToString:@"I"]) {
        cell.lblSeatValue.text = @"1";
    }
    if ([t.link isEqualToString:@"II"]) {
        cell.lblSeatValue.text = @"2";
    }
    if ([t.link isEqualToString:@"III"]) {
        cell.lblSeatValue.text = @"3";
    }
    
    
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Trips *t = [self.tripArr objectAtIndex:indexPath.row];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [ModelManager driverConfirmWithTriId:t.tripId withSuccess:^{
            gTrip = t;
            [Util setObject:@"" forKey:@"tripIsEnd"];
            [Util setObject:gTrip.tripId forKey:DRIVER_CURRENT_TRIP_ID_KEY];
            [self performSegueWithIdentifier:@"selectTrip" sender:self];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        } failure:^(NSString *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    });
}


@end
