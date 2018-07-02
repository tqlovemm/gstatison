//
//  XDSeekLevelView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/11/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDSeekLevelView.h"

@interface XDSeekLevelView ()

/** 分割线 */
@property (nonatomic, strong) UIView *lineView;

/** 是否认证 */
@property (nonatomic, strong) UIImageView *levelView;

@end

@implementation XDSeekLevelView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB(230, 230, 230);
    [self addSubview:lineView];
    self.lineView = lineView;
    
    UIImageView *levelView = [[UIImageView alloc] init];
    [self addSubview:levelView];
    self.levelView = levelView;
    
    XD_WeakSelf
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(1);
    }];
    
    [self.levelView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-10);
    }];
}

- (void)setLevel:(NSInteger)level {
    _level = level;
    
    if (level == 1) {// 会员等级判断
//        self.levelView.image = [UIImage imageNamed:@"longImg_baoyue"];
        self.levelView.image = [UIImage imageNamed:@"longImg_vips"];
    } else if (level == 2) {
//        self.levelView.image = [UIImage imageNamed:@"longImg_chuji"];
        self.levelView.image = [UIImage imageNamed:@"longImg_vips"];
    } else if (level == 3) {
//        self.levelView.image = [UIImage imageNamed:@"longImg_gaoduan"];
        self.levelView.image = [UIImage imageNamed:@"longImg_vips"];
    } else if (level == 4) {
//        self.levelView.image = [UIImage imageNamed:@"longImg_zhizun"];
        self.levelView.image = [UIImage imageNamed:@"longImg_vips"];
    } else if (level == 5) {
//        self.levelView.image = [UIImage imageNamed:@"longImg_siren"];
        self.levelView.image = [UIImage imageNamed:@"longImg_vips"];
    } else {
        self.levelView.image = nil;
    }
    
}

@end
