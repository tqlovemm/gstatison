//
//  XDPrivatePriceView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/21.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDPrivatePriceView.h"

@implementation XDPrivatePriceView

// Placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect rect = [super textRectForBounds:bounds];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0,10, 0,10);
    return UIEdgeInsetsInsetRect(rect, insets);
}

// Text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect rect = [super editingRectForBounds:bounds];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0,10, 0,10);
    return UIEdgeInsetsInsetRect(rect, insets);
}

// Clear button
- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
    CGRect rect = [super clearButtonRectForBounds:bounds];
    
    return CGRectOffset(rect, 0, -5);
}

@end
