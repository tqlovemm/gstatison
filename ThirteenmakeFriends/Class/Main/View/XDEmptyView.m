//
//  XDEmptyView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/11.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDEmptyView.h"

@implementation XDEmptyView

+ (instancetype)diyEmptyView{
    
    return [XDEmptyView emptyViewWithImageStr:@"error_nodata" titleStr:@"暂无数据" detailStr:@"请稍后再试!"];
}

+ (instancetype)diyEmptyActionViewWithTarget:(id)target action:(SEL)action{
    return [XDEmptyView emptyActionViewWithImageStr:@"error_nonet" titleStr:@"无网络连接" detailStr:@"请检查你的网络连接是否正确!" btnTitleStr:@"重新加载" target:target action:action];
}

- (void)prepare{
    [super prepare];
    self.autoShowEmptyView = NO;
}

@end
