//
//  GiftsAnimationView.m
//  ThirteenmakeFriends_myPuppet
//
//  Created by 谢超 on 2018/4/16.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "GiftsAnimationView.h"


@implementation GiftsAnimationView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"GiftsAnimationView" owner:self options:nil];
//        self.contentView.frame = self.bounds;
//        [self addSubview:self.contentView];
    }
    
    return self;
}


-(void)giftsAnimationViewShow
{
    self.frame = CGRectMake(0, 0, 200, 105);
    self.layer.position = self.center;
    self.transform = CGAffineTransformMakeScale(0.90, 0.90);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
