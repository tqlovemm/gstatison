//
//  ManDateSegment.m
//  ThirteenmakeFriends
//
//  Created by iOS on 14/6/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "ManDateSegment.h"

@implementation ManDateSegment

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
        self.segmentControl.selectionIndicatorHeight     = 2;
        self.segmentControl.titleTextAttributes          = @{
                                                             NSFontAttributeName : [UIFont systemFontOfSize:15.0f],
                                                             NSForegroundColorAttributeName : DefaultColor_App_Gray
                                                             };
        self.segmentControl.selectedTitleTextAttributes  = @{
                                                             NSFontAttributeName : [UIFont systemFontOfSize:17.0f],
                                                             NSForegroundColorAttributeName : ThemeColor3,
                                                             };
        [self addSubview:self.segmentControl];
        
        //        UIView *view         = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height-5, frame.size.width, 5)];
        //        view.backgroundColor = [UIColor grayColor];
        //        [self addSubview:view];
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
