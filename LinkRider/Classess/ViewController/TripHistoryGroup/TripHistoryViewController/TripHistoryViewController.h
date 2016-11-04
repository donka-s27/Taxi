//
//  TripHistoryViewController.h
//  LinkRider
//
//  Created by hieu nguyen on 7/2/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripHistoryCell.h"
#import "UITableView+DragLoad.h"
@interface TripHistoryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITableViewDragLoadDelegate>{
    NSMutableArray *tripArr;
    int curPage;
    NSIndexPath *selectedIndexPath;
}
@property (weak, nonatomic) IBOutlet UINavigationItem *lblHeaderTitle;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealBtn;
@property (weak, nonatomic) IBOutlet UITableView *tblView;

@end
