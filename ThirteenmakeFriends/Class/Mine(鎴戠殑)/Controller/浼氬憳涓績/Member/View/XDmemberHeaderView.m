//
//  XDmemberHeaderView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDmemberHeaderView.h"

@interface XDmemberHeaderView ()

@property (nonatomic ,strong) UILabel *titleLabel;

@end

@implementation XDmemberHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        // 创建cell内部子控件
        [self setupSubViews];

    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        // 创建cell内部子控件
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = kPingFangRegularFont(11);
    titleLabel.textColor = RGB(119, 119, 119);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"升级会员享有以下特权";
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB(230, 230, 230);
    [self addSubview:lineView];
    
    WEAKSELF
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(weakSelf);
        make.height.mas_equalTo(0.5);
    }];
    
}

@end
