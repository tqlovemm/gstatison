//
//  XDSegmentView.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/18.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMSegmentedControl;

@interface XDSegmentView : UIView

@property (nonatomic , strong) HMSegmentedControl *segmentControl;/**<segmentControl*/
@property (nonatomic , strong) NSArray            *arrSegment;

@end
