//
//  MyPinAnnotationView.m
//  Bus
//
//  Created by duc le on 3/22/14.
//
//

#import "MyPinAnnotationView.h"
#import "CalloutBusView.h"

@implementation MyPinAnnotationView

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

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!self.clipsToBounds && !self.hidden && self.alpha > 0) {
        for (UIView *subview in self.subviews.reverseObjectEnumerator) {
            CGPoint subPoint = [subview convertPoint:point fromView:self];
            UIView *result = [subview hitTest:subPoint withEvent:event];
            if (result != nil) {
                if([result isKindOfClass:[UIButton class]])
                {
                   [((CalloutBusView*)[result superview]) chooseThisBus:nil];
                    return result;
                }
            }
        }
    }
    
    return nil;
}

@end
