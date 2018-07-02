//
//  DateSegment.h
//  ThirteenmakeFriends
//
//  Created by iOS on 5/5/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"

@interface DateSegment : UIView

@property (nonatomic , strong) HMSegmentedControl *segmentControl;/**<segmentControl*/
@property (nonatomic , assign) BOOL isMan;

@end
