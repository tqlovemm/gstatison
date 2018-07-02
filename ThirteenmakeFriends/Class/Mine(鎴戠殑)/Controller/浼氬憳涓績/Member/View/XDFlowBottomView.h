//
//  XDFlowBottomView.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/14.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDFlowBottomView : UIView

@property (nonatomic, strong) NSArray *itemsArray;

/**
 *  滚动到指定的页面
 */
- (void)scrollToPage:(NSUInteger)pageNumber;

@end
