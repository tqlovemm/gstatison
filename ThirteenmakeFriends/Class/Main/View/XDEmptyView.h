//
//  XDEmptyView.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/11.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "LYEmptyView.h"

@interface XDEmptyView : LYEmptyView

+ (instancetype)diyEmptyView;

+ (instancetype)diyEmptyActionViewWithTarget:(id)target action:(SEL)action;

@end
