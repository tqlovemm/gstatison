//
//  XDOtherBottomView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/9/7.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "XDOtherBottomView.h"

@interface XDOtherBottomView ()

@property (weak, nonatomic) UIView *lineView;

@property (weak, nonatomic) UIView *verlineView;

@property (strong, nonatomic) NSMutableArray *btnsArray;

@end

@implementation XDOtherBottomView

- (NSMutableArray *)btnsArray {
    if (_btnsArray == nil) {
        _btnsArray = [NSMutableArray array];
    }
    return _btnsArray;
}

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
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.friendBtn = [self setupBtnWithIcon:nil title:@"加好友"];
    self.attitudeBtn = [self setupBtnWithIcon:nil title:@"关注"];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineView];
    self.lineView = lineView;
    
    UIView *verlineView = [[UIView alloc] init];
    verlineView.backgroundColor = HEXCOLOR(0xf0f0f2);
    [self addSubview:verlineView];
    self.verlineView = verlineView;
}


- (UIButton *)setupBtnWithIcon:(NSString *)icon title:(NSString *)title
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageWithName:icon] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:RGB(65, 65, 65) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    // 设置间距
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
//    btn.tag = tag;
//    [btn addTarget:self action:@selector(bottomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btn];
    
    [self.btnsArray addObject:btn];
    
    return btn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置按钮的frame
    NSUInteger btnCount = self.btnsArray.count;
    CGFloat margin = 10;
    CGFloat btnW = (self.width - (btnCount + 1) * margin) / btnCount;
    CGFloat btnY = 5;
//    CGFloat btnH = self.height - 2 * btnY;
    CGFloat btnH = Normal_Height - 2 * btnY;
    for (int i = 0; i<btnCount; i++) {
        UIView *btn = self.subviews[i];
        btn.width = btnW;
        btn.height = btnH;
        btn.y = btnY;
        btn.x = margin + i * (btnW + margin);
    }
    self.lineView.width = 1;
    self.lineView.height = btnH * 0.5;
    self.lineView.center = CGPointMake(self.width / 2.0, Normal_Height / 2.0);
    
    self.verlineView.width = self.width;
    self.verlineView.height = 0.5;
    self.verlineView.x = 0;
    self.verlineView.y = 0;
}

@end
