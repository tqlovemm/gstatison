//
//  XDVoucherShareView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/19.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDVoucherShareView.h"
#import "XDGradientLabel.h"

@interface XDVoucherShareView ()

/** 分享描述 */
@property (nonatomic, weak) XDGradientLabel *desLabel;
/** 分享图片 */
@property (nonatomic, weak) UIImageView *shareImgView;
/** 分享按钮 */
@property (nonatomic, weak) UIButton *shareBtn;

@end

@implementation XDVoucherShareView

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
    self.backgroundColor = RGB(240, 239, 245);
    
    NSArray *gradientColors = @[(id)RGB(232, 63, 120).CGColor, (id)RGB(233, 174, 121).CGColor];
    XDGradientLabel* testLabel = [[XDGradientLabel alloc] init];
    testLabel.text = @"邀请好友获得折扣券";
    testLabel.font = kPingFangBoldFont(18);
    [testLabel sizeToFit];
    testLabel.colors = gradientColors;
    [self addSubview:testLabel];
    self.desLabel = testLabel;
    
    UIImageView *shareImgView = [[UIImageView alloc] init];
    shareImgView.image = [UIImage imageNamed:@"share_coupons"];
    
    [self addSubview:shareImgView];
    self.shareImgView = shareImgView;
    
    UIButton *shareBtn = [[UIButton alloc] init];
    shareBtn.backgroundColor = [UIColor whiteColor];
    shareBtn.layer.cornerRadius = 20;
    shareBtn.layer.shadowRadius = 2;
    shareBtn.layer.shadowOffset = CGSizeMake(0, 2);
    shareBtn.layer.shadowOpacity = 0.8;
    shareBtn.layer.shadowColor = RGBA(175, 175, 175, 0.5).CGColor;
    
    shareBtn.titleLabel.font = kPingFangBoldFont(14);
    [shareBtn setTitle:@"点击分享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:ThemeColor1 forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self addSubview:shareBtn];
    self.shareBtn = shareBtn;
    [shareBtn addTarget:self action:@selector(shareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    WEAKSELF
    [testLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(28);
        make.centerX.mas_equalTo(weakSelf);
    }];
    
    [shareImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(testLabel.mas_bottom).offset(15);
        make.centerX.mas_equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(169, 96));
    }];
    
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(shareImgView.centerX);
        make.size.mas_equalTo(CGSizeMake(188, 40));
        make.top.mas_equalTo(shareImgView.mas_bottom).offset(10);
    }];
}

- (void)shareBtnClicked:(UIButton *)btn {
    WEAKSELF
    if (weakSelf.shareButtonClicked) {
        weakSelf.shareButtonClicked(btn);
    }
}

@end
