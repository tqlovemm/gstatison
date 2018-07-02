//
//  ManDateSegment.h
//  ThirteenmakeFriends
//
//  Created by iOS on 14/6/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"

@interface ManDateSegment : UIView
@property (nonatomic , strong) HMSegmentedControl *segmentControl;/**<segmentControl*/
@property (nonatomic , strong) NSArray            *arrSegment;
@end
