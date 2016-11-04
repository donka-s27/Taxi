//
//  HistoryViewController.m
//  LinkRider
//
//  Created by hieu nguyen on 6/29/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import "HistoryViewController.h"
#import "History.h"
#import "MBProgressHUD.h"
#import "ModelManager.h"
#import "UIView+Toast.h"
@interface HistoryViewController ()

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.btnBack setTarget:self];
    self.historyArr = [[NSMutableArray alloc]init];
    [self.btnBack setAction:@selector(onBack)];
    self.historyArr = [[NSMutableArray alloc]init];
    [_tblView setDragDelegate:self refreshDatePermanentKey:@"FriendList"];
    self.tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tblView.showLoadMoreView = YES;
    curPage = 1;
    [self getData];
    // Do any additional setup after loading the view.
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
    [self.navigationItem setHidesBackButton:NO animated:YES];
    self.navigationController.navigationBarHidden = NO;
    [self setText];

}
-(void)setText{
    [self.lblHeaderTitle setTitle:[Util localized:@"transaction_history"]];
    
    [self.btnBack setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont fontAwesomeFontOfSize:20], NSFontAttributeName,
                                          [UIColor whiteColor], NSForegroundColorAttributeName,
                                          nil]
                                forState:UIControlStateNormal];
    
    [self.btnBack setTitle:[NSString fontAwesomeIconStringForEnum:FALongArrowLeft] ];
}
- (void)dragTableDidTriggerRefresh:(UITableView *)tableView{
    curPage = 1;
    self.historyArr = [[NSMutableArray alloc]init];
    [self getData];
    self.tblView.frame = CGRectMake(0, 55, self.tblView.frame.size.width, self.view.bounds.size.height-55);
}
- (void)dragTableRefreshCanceled:(UITableView *)tableView{
    
}
- (void)dragTableDidTriggerLoadMore:(UITableView *)tableView{
    curPage++;
    [self getData];
    self.tblView.frame = CGRectMake(0, 55, self.tblView.frame.size.width, self.view.bounds.size.height-55);
}

- (void)dragTableLoadMoreCanceled:(UITableView *)tableView{
    
}

-(void)getData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [ModelManager transactionHistorywithPage:curPage Success:^(NSMutableArray *arr) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            self.historyArr = [NSMutableArray arrayWithArray:[self.historyArr arrayByAddingObjectsFromArray:arr]];
            [self.tblView reloadData];
            [self.tblView stopLoadMore];
            [self.tblView stopRefresh];
        } andFailure:^(NSString *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.tblView stopLoadMore];
            [self.tblView stopRefresh];
        }];
    });
}
-(void)onBack{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark tableview datasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PaymentHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PaymentHistoryCell"];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"PaymentHistoryCell" owner:self options:nil];
        cell = (PaymentHistoryCell *)[nib objectAtIndex:0];
        
    }
    if (indexPath.row<_historyArr.count) {
        History *his = [_historyArr objectAtIndex:indexPath.row];

        cell.lblNoteContent.text = his.action;
        float height = [Util getLabelHight:cell.lblNoteContent];
        return height+130;

    }
    
    return 150;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _historyArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PaymentHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PaymentHistoryCell"];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"PaymentHistoryCell" owner:self options:nil];
        cell = (PaymentHistoryCell *)[nib objectAtIndex:0];
        
    }
    if (indexPath.row<_historyArr.count) {
        History *his = [_historyArr objectAtIndex:indexPath.row];
        cell.lblTransactionValue.text = his.transactionId;
        NSDate* created = [Util dateFromString:his.dateCreated format:@"yyyy-MM-dd HH:mm:ss"];
        
        cell.lblDateValue.text = [Util stringFromDate:created format:@"MMMM dd, yyyy"];
        cell.lblTimeValue.text = [Util stringFromDate:created format:@"HH:mm"];
        cell.lblTypeValue.text = his.type;
        cell.lblPointValue.text = [NSString stringWithFormat:@"%@%@",his.type,his.amount];
        cell.lblNoteContent.text = his.action.uppercaseString;
        cell.lblTripIdValue.text = his.tripId;
        if ([his.type isEqualToString:@"+"]) {
//            [cell.lblPointValue setTextColor:[UIColor blackColor]];
            cell.imgBg.image = [UIImage imageNamed:@"bg_history_add"];
        }
        else{
            cell.imgBg.image = [UIImage imageNamed:@"bg_history_minus"];
        }
        cell.imgBg.layer.cornerRadius = 3;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}
@end
