//
//  CalloutBusView.h
//  Bus
//
//  Created by duc le on 3/21/14.
//
//

#import <UIKit/UIKit.h>
#import "Bussiness.h"

#import "CBAutoScrollLabel.h"

@protocol CalloutBusViewDelegate;
@interface CalloutBusView : UIView{
    BOOL isSelected;
}


@property (retain, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *categoryLbl;
@property (weak, nonatomic) IBOutlet CBAutoScrollLabel *commentLbl;

@property (strong, nonatomic) IBOutlet UILabel *addressLabel;


@property (weak, nonatomic) IBOutlet UILabel *rateNumLbl;

-(void)setDataWithBussiness;

@property (unsafe_unretained,nonatomic) id<CalloutBusViewDelegate> delegate;
- (IBAction)chooseThisBus:(id)sender;
@end

@protocol CalloutBusViewDelegate <NSObject>


@end