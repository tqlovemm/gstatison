//
//  XDVerticalAlignmentLabel.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/28.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    myVerticalAlignmentNone = 0,
    myVerticalAlignmentCenter,
    myVerticalAlignmentTop,
    myVerticalAlignmentBottom
} myVerticalAlignment;

@interface XDVerticalAlignmentLabel : UILabel

@property (nonatomic) UIEdgeInsets edgeInsets;

/**
 *  对齐方式
 */
@property (nonatomic) myVerticalAlignment verticalAlignment;

@end
