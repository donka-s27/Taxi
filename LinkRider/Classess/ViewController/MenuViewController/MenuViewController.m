//
//  MenuViewController.m
//  RevealControllerStoryboardExample
//
//  Created by Nick Hodapp on 1/9/13.
//  Copyright (c) 2013 CoDeveloper. All rights reserved.
//

#import "MenuViewController.h"
#import "NSString+FontAwesome.h"
#import "FAImageView.h"
#import "UIImage+FontAwesome.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "ModelManager.h"
#import "StartTripViewController.h"
#import "RatingTripViewController.h"

@implementation MenuViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    _ratingStar.backgroundColor  = [UIColor clearColor];
    _ratingStar.starImage = [[UIImage imageNamed:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _ratingStar.starHighlightedImage = [[UIImage imageNamed:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_ratingStar setMaxRating:5.0];
    [_ratingStar setHorizontalMargin:1.0];
    [_ratingStar setEditable:NO];
    [_ratingStar setDisplayMode:EDStarRatingDisplayHalf];
    [_ratingStar setRating:5];
    [_ratingStar setNeedsDisplay];
    [_ratingStar setTintColor:[UIColor whiteColor]];
    [_tblView registerNib:[UINib nibWithNibName:@"MenuCell" bundle:nil] forCellReuseIdentifier:@"MenuCell"];
    //    [self onStartTrip];
    [self setupMainVC];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowHistory) name:SHOW_TRANSACTION_HISTORY_KEY object:nil];
    NSDictionary *alert = [[notificationsDic objectForKey:@"aps"] objectForKey:@"alert"];
    
    if ([alert isKindOfClass:[NSDictionary class]]) {
        NSString *action = [alert valueForKey:@"action"];
        if ([action isEqualToString:@"updateApproval"]||[action isEqualToString:@"redeemApproval"]||[action isEqualToString:@"transferApproval"]) {
            [self performSegueWithIdentifier:@"onPayment" sender:self];
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillBecomForceGround) name:WILL_ENTER_FORCE_GROUND object:nil];
}
- (void)appWillBecomForceGround{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [ModelManager showMyTripsWithSuccess:^(NSMutableArray *arr) {
            dispatch_async(dispatch_get_main_queue(), ^{
            for (Trips *trip in arr) {
                if ([trip.status isEqualToString:TRIP_STATUS_APPROACHING]||[trip.status isEqualToString:TRIP_STATUS_IN_PROGRESS]||[trip.status isEqualToString:TRIP_STATUS_PENDING_PAYMENT]) {
                    
                    gTrip = trip;
                    if ([trip.status isEqualToString:TRIP_STATUS_APPROACHING]) {
                        return;
                    }
                    else if([trip.status isEqualToString:TRIP_STATUS_IN_PROGRESS]){
                        
                        StartTripViewController *start = [mainStoryboard instantiateViewControllerWithIdentifier:@"StartTripViewController"];
                        [self.navigationController pushViewController:start animated:YES];
                        return;
                        
                    }
                    else if ([trip.status isEqualToString:TRIP_STATUS_PENDING_PAYMENT]){
                        RatingTripViewController *start = [self.storyboard instantiateViewControllerWithIdentifier:@"RatingTripViewController"];
                        [self.navigationController pushViewController:start animated:YES];
                        return;
                    }
                    
                }
                
            } });
            
        } andFailure:^(NSString *err) {
            
        }];
    });
            
    
}

- (void)setupMainVC{
//    [ModelManager getUserProfileWithSuccess:^{
        if ([gUser.is_driver boolValue]&&[gUser.driver.isOnline boolValue]) {
            [self onReceiveOrder];
        }else{
            [self onStartTrip];
        }

//    } failure:^(NSString *err) {
//    }];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)viewWillAppear:(BOOL)animated{
    [self.tblView reloadData];
    [self setText];
}

- (void)viewDidAppear:(BOOL)animated{
    self.thumbImg.layer.cornerRadius=self.thumbImg.frame.size.height /2;
    self.thumbImg.layer.borderWidth=0;
    self.thumbImg.layer.masksToBounds = YES;
    self.thumbImg.layer.borderColor = [UIColor whiteColor].CGColor;
    self.thumbImg.layer.borderWidth = 2;
}

- (void) setText{
    
    nameArr = [NSMutableArray arrayWithArray:@[[Util localized:@"home_title"],
                                               [Util localized:@"profile_title"],
                                               [Util localized:@"payment_title"],
                                               [Util localized:@"share_title"],
                                               [Util localized:@"help_title"],
                                               [Util localized:@"trip_history_title"],
                                               [Util localized:@"online_title"],
                                               [Util localized:@"register_as_driver_title"],
                                               /*[Util localized:@"language_title"],*/
                                               ]];
    
    iconArr = [NSMutableArray arrayWithArray:@[@"\ue648",
                                               @"\ue605",
                                               @"\ue664",
                                               @"\ue616",
                                               @"\ue64a",
                                               @"\ue62b",
                                               @"\ue643",
                                               @"\ue6ae"]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveOrder) name:RECEIVE_ORDER_REQUEST_KEY object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onStartTrip) name:START_TRIP_KEY object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEndTrip) name:END_TRIP_KEY object:nil];
    [self.tblView reloadData];
    self.lblName.text = gUser.name;
    if ([[Validator getSafeString:gUser.is_driver] isEqualToString:@"1"]) {
        [_ratingStar setRating:[gUser.driver.driverRateCount floatValue]];
    }
    else{
        [_ratingStar setRating:[gUser.passenger_rating_count floatValue]];
    }
    [self.btnLogout setTitle:[Util localized:@"logout_title"] forState:UIControlStateNormal];
    [self.icLogout setTitle:@"\ue621" forState:UIControlStateNormal];
    
    [self.thumbImg setImageWithURL:[NSURL URLWithString:gUser.thumb] placeholderImage:[UIImage imageNamed:@""]];

    if ([gUser.point isEqualToString:@"1"]) {
        self.lblPoint.text = [NSString stringWithFormat:@"%@: %@",[Util localized:@"lbl_point"],gUser.point];
    }
    else{
        self.lblPoint.text = [NSString stringWithFormat:@"%@: %@",[Util localized:@"lbl_points"],gUser.point];
    }
    
}

-(void)onReceiveOrder{
    
    if ([gUser.driver.isOnline boolValue]) {
        [self performSegueWithIdentifier:@"onOnline" sender:self];
    }
}
-(void)onStartTrip{
    
    [self performSegueWithIdentifier:@"onMap" sender:self];
    
}
-(void)onEndTrip{
    
    [self performSegueWithIdentifier:@"onMap" sender:self];
    
}
- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // configure the destination view controller:
    if ( [sender isKindOfClass:[UITableViewCell class]] )
    {
        
    }
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return iconArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[Validator getSafeString:gUser.driver.isActive] isEqualToString:@"0"]&&[[Validator getSafeString:gUser.is_driver] isEqualToString:@"1"]) {
        if (indexPath.row == 6||indexPath.row == 7) {
            return 0;
        }
        
    }
    if ([[Validator getSafeString:gUser.is_driver] isEqualToString:@"0"]) {
        if (indexPath.row == 6) {
            return 0;
        }
        
    }
    if ([[Validator getSafeString:gUser.is_driver] isEqualToString:@"1"]) {
        if (indexPath.row == 7) {
            return 0;
        }
        
        
    }
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuCell";
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.lblTitle.text = @"";
    
    cell.lblIcon.text = @"";
    //    if (!cell) {
    //        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil] objectAtIndex:0];
    if ([[Validator getSafeString:gUser.driver.isActive] isEqualToString:@"0"]&&[[Validator getSafeString:gUser.is_driver] isEqualToString:@"1"]) {
        if (indexPath.row == 6||indexPath.row == 7) {
            return cell;
        }
        
    }
    if ([[Validator getSafeString:gUser.is_driver] isEqualToString:@"1"]) {
        if (indexPath.row == 7) {
            return cell;
        }
        
    }
    if ([[Validator getSafeString:gUser.is_driver] isEqualToString:@"0"]) {
        if (indexPath.row == 6) {
            return cell;
        }
        
    }
    cell.lblTitle.text = [nameArr objectAtIndex:indexPath.row];
    
    cell.lblIcon.text = [iconArr objectAtIndex:indexPath.row];
    
    
    
    //    }
    
    //    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tblView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"onMap" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"onProfile" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"onPayment" sender:self];
            break;
        case 3:
            [self performSegueWithIdentifier:@"onShare" sender:self];
            break;
        case 4:
            [self performSegueWithIdentifier:@"onHelp" sender:self];
            break;
        case 5:
            [self performSegueWithIdentifier:@"onHistory" sender:self];
            break;
        case 6:
            [self performSegueWithIdentifier:@"onOnline" sender:self];
            break;
        case 7:
            [self performSegueWithIdentifier:@"onRegisterAsDriver" sender:self];
            break;
            
            
        default:
            break;
    }
}
-(void)onShowHistory{
    [self performSegueWithIdentifier:@"onPayment" sender:self];
}
//-(void)changeLanguage{
//    NSString *lang = [Util objectForKey:LANGUAGE_KEY];
//    if ([lang isEqualToString:@"zh"]) {
//        lang = @"en";
//    }
//    else{
//        lang = @"zh";
//    }
//    [Util setObject:lang forKey:LANGUAGE_KEY];
//    [self setText];
//    [self.revealViewController.frontViewController viewWillAppear:YES];
//}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [ModelManager logoutWithSuccess:^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [Util setBool:NO forKey:IS_LOGGED_IN_KEY];
        } andFailure:^(NSString *err) {
            [Util showMessage:[Util localized:@"msg_error"] withTitle:[Util localized:@"app_name"]];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }
}
- (IBAction)onLogout:(id)sender {
    [Util showMessage:[Util localized:@"msg_logout"] withTitle:[Util localized:@"app_name"] andDelegate:self];
}
@end
