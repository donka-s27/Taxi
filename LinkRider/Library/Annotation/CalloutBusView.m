
//
//  CalloutBusView.m
//  Bus
//
//  Created by duc le on 3/21/14.
//
//

#import "CalloutBusView.h"
#import "Common.h"
#import "AsyncImageView.h"
#import "MKAnnotationView+WebCache.h"
#import "UIImageView+WebCache.h"
@implementation CalloutBusView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)awakeFromNib{
    [super awakeFromNib];
    self.clipsToBounds = NO;
    isSelected = NO;
    [_bgImgView setImage:[[UIImage imageNamed:@"bg_callout"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 40, 10)]];
}

- (IBAction)chooseThisBus:(id)sender
{
    if (!isSelected) {
        NSLog(@"Choose this bus");
        isSelected = YES;
        [self getDirection:nil];
    }
   
}

-(void)setDataWithBussiness
{
//    _nameLbl.text = _bussiness.title;
//    
   // _imgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_bussiness.image stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]]];
    //_imgView.imageURL =  [NSURL URLWithString:[_bussiness.image stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
   // _imgView.image = [UIImage imageNamed:@"icon1.png"];
   //[_imgView setImageWithURL:[NSURL URLWithString:_bussiness.image]];

    
//    _addressLabel.text = _bussiness.address;
    
//    NSString *str = [_bussiness.price stringByReplacingOccurrencesOfString:@".00" withString:@""];
//    NSNumberFormatter *formatter = [NSNumberFormatter new];
//    [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
//    NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[str integerValue]]];
//    
//    _categoryLbl.text = [NSString stringWithFormat:@"$%@  ",formatted];
    [_addressLabel sizeToFit];
    [_categoryLbl sizeToFit];
    [_nameLbl sizeToFit];
    [_categoryLbl setFrame:CGRectMake(_categoryLbl.frame.origin.x,_categoryLbl.frame.origin.y + (_nameLbl.frame.size.height-17)/2, _categoryLbl.frame.size.width, _categoryLbl.frame.size.height)];
    
}

- (IBAction)getDirection:(id)sender
{
//    NSLog(@"on find way %@",sender);
//    NSString* versionNum = [[UIDevice currentDevice] systemVersion];
//    NSString *nativeMapScheme = @"maps.apple.com";
//    if ([versionNum compare:@"6.0" options:NSNumericSearch] == NSOrderedAscending)
//        nativeMapScheme = @"maps.google.com";
//    
//    NSString* url = [NSString stringWithFormat: @"http://%@/maps?q=%@,%@", nativeMapScheme, _bussiness.latitude, _bussiness.longitude];
//    
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
//     [self.delegate chooseThisRestaurant:_bussiness];
    [self removeFromSuperview];
}


@end
