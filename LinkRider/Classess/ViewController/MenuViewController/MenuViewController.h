//
//  MenuViewController.h
//  RevealControllerStoryboardExample
//
//  Created by Nick Hodapp on 1/9/13.
//  Copyright (c) 2013 CoDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuCell.h"


@interface MenuViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate>{
    NSMutableArray *nameArr;
    NSMutableArray *iconArr;
}
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbImg;
@property (weak, nonatomic) IBOutlet UILabel *lblPoint;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet EDStarRating *ratingStar;
@property (weak, nonatomic) IBOutlet UIButton *icLogout;
@property (weak, nonatomic) IBOutlet UIButton *btnLogout;
- (IBAction)onLogout:(id)sender;

@end
