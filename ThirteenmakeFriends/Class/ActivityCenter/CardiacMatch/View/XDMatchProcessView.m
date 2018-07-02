//
//  XDMatchProcessView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/12/18.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDMatchProcessView.h"

@implementation XDMatchProcessView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    UILabel *quicklyLogin = [[UILabel alloc]init];
    quicklyLogin.text = @"匹配流程";
    quicklyLogin.font = kPingFangThinFont(14);
    quicklyLogin.textAlignment = NSTextAlignmentCenter;
    quicklyLogin.textColor = RGB(19, 19, 19);
    quicklyLogin.backgroundColor = [UIColor clearColor];
    [self addSubview:quicklyLogin];
    
    UIView *leftLineView = [[UIView alloc] init];
    leftLineView.backgroundColor = RGB(230, 230, 230);
    [self addSubview:leftLineView];
    
    UIView *rightLineView = [[UIView alloc] init];
    rightLineView.backgroundColor = RGB(230, 230, 230);
    [self addSubview:rightLineView];
    
    XD_WeakSelf
    [quicklyLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self);
    }];
    
    [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 1));
        make.centerY.mas_equalTo(quicklyLogin);
        make.right.mas_equalTo(quicklyLogin.mas_left).offset(-10);
    }];
    
    [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 1));
        make.centerY.mas_equalTo(quicklyLogin);
        make.left.mas_equalTo(quicklyLogin.mas_right).offset(10);
    }];
}

@end
