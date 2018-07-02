//
//  XDIsMatchHeaderView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/12/18.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDIsMatchHeaderView.h"
#import "XDIsMatchView.h"
#import "XDMatchProcessView.h"

@interface XDIsMatchHeaderView ()

@property (nonatomic, weak) XDIsMatchView * isMatchView;

@end

@implementation XDIsMatchHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    XDIsMatchView * isMatchView = [[XDIsMatchView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.width * 14 / 15.0)];
    XD_WeakSelf
    isMatchView.countdownFinished = ^(BOOL finish) {
        XD_StrongSelf
        if (self.countdownFinished) {
            self.countdownFinished(finish);
        }
    };
    
    [self addSubview:isMatchView];
    self.isMatchView = isMatchView;
    
    XDMatchProcessView *processView = [[XDMatchProcessView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(isMatchView.frame), self.width, 20)];
    [self addSubview:processView];
    
//    XD_WeakSelf
//    [isMatchView mas_makeConstraints:^(MASConstraintMaker *make) {
//        XD_StrongSelf
//        make.centerX.mas_equalTo(self.mas_centerX);
//        make.top.mas_equalTo(0);
//    }];
//
//    [processView mas_makeConstraints:^(MASConstraintMaker *make) {
//        XD_StrongSelf
//        make.centerX.mas_equalTo(self.mas_centerX);
//        make.top.mas_equalTo(isMatchView.mas_bottom);
//        make.bottom.mas_equalTo(self);
//    }];
}

- (void)setMinCount:(NSInteger)minCount {
    _minCount = minCount;
    self.isMatchView.minCount = minCount;
}

@end
