//
//  TripHistoryViewController.m
//  LinkRider
//
//  Created by hieu nguyen on 7/2/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import "TripHistoryViewController.h"
#import "MBProgressHUD.h"
#import "ModelManager.h"
#import "UIView+Toast.h"
#import "TripHistoryDetailViewController.h"
@interface TripHistoryViewController ()

@end

@implementation TripHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    curPage = 1;
    tripArr = [[NSMutableArray alloc]init];
    [_tblView setDragDelegate:self refreshDatePermanentKey:@"FriendList"];
    _tblView.showLoadMoreView = YES;
    _tblView.frame = self.view.bounds;
    self.tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self getData];

}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{

    [self setText];
    
}

- (void)dragTableDidTriggerRefresh:(UITableView *)tableView{
    curPage = 1;
    tripArr = [[NSMutableArray alloc]init];
    [self getData];
//    self.tblView.frame = CGRectMake(0, 55, self.tblView.frame.size.width, self.view.frame.size.height-55);
}
- (void)dragTableRefreshCanceled:(UITableView *)tableView{
    
}
- (void)dragTableDidTriggerLoadMore:(UITableView *)tableView{
    curPage++;
    [self getData];
//    self.tblView.frame = CGRectMake(0, 55, self.tblView.frame.size.width, self.view.frame.size.height-55);
    
}

- (void)dragTableLoadMoreCanceled:(UITableView *)tableView{
    
}

-(void)setText{
    [self.lblHeaderTitle setTitle:[Util localized:@"header_history"]];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    [self.navigationController.navigationBar setBarTintColor:[Util colorWithHexString:@"#333333" alpha:1]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"Raleway-Medium" size:20], NSFontAttributeName, nil]];
    [self.revealBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont fontAwesomeFontOfSize:24], NSFontAttributeName,
                                          [UIColor whiteColor], NSForegroundColorAttributeName,
                                          nil]
                                forState:UIControlStateNormal];
    
    [self.revealBtn setTitle:@"\uf0c9"];
    if ( revealViewController )
    {
        [self.revealBtn setTarget: self.revealViewController];
        [self.revealBtn setAction: @selector(revealToggle:)];
        [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }

}
-(void)getData{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [ModelManager showMyTripsWithPage:curPage Success:^(NSMutableArray *arr) {
            tripArr = [NSMutableArray arrayWithArray:[tripArr arrayByAddingObjectsFromArray:arr]];
            [self.tblView reloadData];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (arr.count==0) {
                [self.view makeToast:[Util localized:@"msg_no_trip_history"]];
            }
            [self.tblView stopLoadMore];
            [self.tblView stopRefresh];
            
        } andFailure:^(NSString *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.tblView stopLoadMore];
            [self.tblView stopRefresh];
        }];
    });
    
}
#pragma mark tableview datasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 245;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tripArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TripHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TripHistoryCell"];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"TripHistoryCell" owner:self options:nil];
        cell = (TripHistoryCell *)[nib objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
    if (indexPath.row<tripArr.count) {
        Trips *trip = [tripArr objectAtIndex:indexPath.row];
        cell.lblTransactionIdValue.text = trip.tripId;
        cell.lblLinkValue.text = trip.link;
        
        if ([trip.link isEqualToString:@"I"]) {
            cell.lblLinkValue.text = @"1";
        }
        if ([trip.link isEqualToString:@"II"]) {
            cell.lblLinkValue.text = @"2";
        }
        if ([trip.link isEqualToString:@"III"]) {
            cell.lblLinkValue.text = @"3";
        }
        
        
        cell.lblEndTimeValue.text = trip.endTime;
        cell.LblDepartureValue.text = trip.startLocation.name;
        cell.lblDestinationValue.text = trip.endLocation.name;
        int timeInterval = [trip.totalTime intValue];
        NSString *time = [NSString stringWithFormat:@"%02d:%02d",timeInterval/60,timeInterval%60];
        if (timeInterval>60) {
            time = [NSString stringWithFormat:@"%02d %@ %02d %@",timeInterval/60,[Util localized:@"lbl_hour"],timeInterval%60,[Util localized:@"lbl_minutes"]];
        }
        else{
            time = [NSString stringWithFormat:@"%02d %@", timeInterval,[Util localized:@"lbl_minutes"]];
        }
        cell.lblDurationValue.text = time;
        NSDate* created = [Util dateFromString:trip.dateCreated format:@"yyyy-MM-dd HH:mm:ss"];
        
        cell.lblDate.text = [Util stringFromDate:created format:@"MMMM dd, yyyy"];
        cell.lblTime.text = [Util stringFromDate:created format:@"HH:mm"];
        
        
        cell.lblDistanceValue.text = [NSString stringWithFormat:@"%@ km",trip.distance];
        cell.lblPriceValue.text = trip.actualFare;
        if ([trip.driverId isEqualToString:gUser.driver_id]) {
            cell.bgImg.image = [UIImage imageNamed:@"bg_history_add"];
            cell.lblPriceValue.text = [NSString stringWithFormat:@"+%@",trip.actualEarn];
        }
        else{
            cell.bgImg.image = [UIImage imageNamed:@"bg_history_minus"];
            cell.lblPriceValue.text = [NSString stringWithFormat:@"-%@",trip.actualFare];
        }
        cell.bgImg.layer.cornerRadius = 3;
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}
/*
 remove from this version
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"onDetail" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"onDetail"]) {
        
        TripHistoryDetailViewController *detail = [segue destinationViewController];
        detail.currentTrip = [tripArr objectAtIndex:selectedIndexPath.row];
        [self.navigationController pushViewController:detail animated:YES];
    }
}
 */
@end
