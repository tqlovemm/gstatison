//
//  XDSegmentView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/18.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDSegmentView.h"
#import "HMSegmentedControl.h"

@implementation XDSegmentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor                = [UIColor clearColor];
        self.segmentControl                 = [[HMSegmentedControl alloc] init];
        self.segmentControl.backgroundColor = [UIColor clearColor];
        self.segmentControl.frame                        = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
        self.segmentControl.segmentEdgeInset             = UIEdgeInsetsMake(0, 0, 0, 0);
        self.segmentControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        self.segmentControl.selectedSegmentIndex         = 0;
        self.segmentControl.selectionStyle               = HMSegmentedControlSelectionStyleTextWidthStripe;
        self.segmentControl.selectionIndicatorLocation   = HMSegmentedControlSelectionIndicatorLocationDown;
        self.segmentControl.selectionIndicatorColor      = ThemeColor3;
        self.segmentControl.selectionIndicatorHeight     = 0;
        self.segmentControl.titleTextAttributes          = @{
                                                             NSFontAttributeName : kPingFangBoldFont(14),
                                                             NSForegroundColorAttributeName : RGB(170, 170, 170)
                                                             };
        self.segmentControl.selectedTitleTextAttributes  = @{
                                                             NSFontAttributeName : kPingFangBoldFont(14),
                                                             NSForegroundColorAttributeName : ThemeColor3,
                                                             };
        [self addSubview:self.segmentControl];
    }
    return self;
}

- (void)setArrSegment:(NSArray *)arrSegment {
    if (arrSegment.count>0) {
        _arrSegment = arrSegment;
        self.segmentControl.sectionTitles = _arrSegment;
    }
}

@end
