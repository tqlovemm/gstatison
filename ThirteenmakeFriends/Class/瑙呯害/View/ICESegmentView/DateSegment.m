//
//  DateSegment.m
//  ThirteenmakeFriends
//
//  Created by iOS on 5/5/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "DateSegment.h"

@implementation DateSegment

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor                 = [UIColor clearColor];
        self.segmentControl                  = [[HMSegmentedControl alloc] init];
        self.isMan = YES;
        self.segmentControl.backgroundColor  = [UIColor clearColor];
        self.segmentControl.frame            = frame;
        self.segmentControl.segmentEdgeInset = UIEdgeInsetsMake(0, 0, 0,0);
        self.segmentControl.selectionStyle   = HMSegmentedControlSelectionStyleTextWidthStripe;
        
        self.segmentControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 0, 0,0);
        self.segmentControl.selectedSegmentIndex         = 0;
        self.segmentControl.selectionIndicatorLocation   = HMSegmentedControlSelectionIndicatorLocationDown;

        self.segmentControl.selectionIndicatorColor      = ThemeColor1;

        self.segmentControl.selectionIndicatorHeight     = 2;
        
        

        self.segmentControl.titleTextAttributes = @{
                                                    NSFontAttributeName : kPingFangBoldFont(12),
                                                    NSForegroundColorAttributeName : RGB(205, 205, 205),
                                                    };

        self.segmentControl.titleTextAttributes = @{
                                                    NSFontAttributeName : kPingFangBoldFont(12),
                                                    NSForegroundColorAttributeName : RGB(119, 119, 119),};

        self.segmentControl.selectedTitleTextAttributes = @{
                                                            NSFontAttributeName : kPingFangBoldFont(14),
                                                            NSForegroundColorAttributeName : kNav_Text_color,
                                                            };
        [self addSubview:self.segmentControl];
        
    }
    return self;
}

- (void)setIsMan:(BOOL)isMan {
    if (isMan) {
        self.segmentControl.sectionTitles = @[@"觅约",@"救我",@"专属"];
    }
    else {
        self.segmentControl.sectionTitles = @[@"觅约",@"救我"];
    }

    _isMan = isMan;
}
@end
