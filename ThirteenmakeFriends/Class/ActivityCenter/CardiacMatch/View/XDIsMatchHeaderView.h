//
//  XDIsMatchHeaderView.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/12/18.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDIsMatchHeaderView : UIView

@property (nonatomic, assign) NSInteger minCount;

/** 得到匹配结果 */
@property (copy, nonatomic) void (^countdownFinished)(BOOL finish);

@end
