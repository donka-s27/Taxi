//
//  HistoryViewController.h
//  LinkRider
//
//  Created by hieu nguyen on 6/29/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentHistoryCell.h"
#import "UITableView+DragLoad.h"
@interface HistoryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITableViewDragLoadDelegate>{
    int curPage;
}
@property (weak, nonatomic) IBOutlet UINavigationItem *lblHeaderTitle;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnBack;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) NSMutableArray *historyArr;
@end
