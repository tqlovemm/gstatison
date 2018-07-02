//
//  XDGetCouponView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/25.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDGetCouponView.h"
#import "Masonry.h"
#import "MJExtension.h"

#define cornerRadiusView(View, Radius) \
\
[View.layer setCornerRadius:(Radius)];           \
[View.layer setMasksToBounds:YES]

@interface XDGetCouponView ()

@property (nonatomic,weak) UIView * bgView;

@property (nonatomic,weak) UIView * popView;

@property (strong, nonatomic) UIImageView *headImg;

@end

@implementation XDGetCouponView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 创建内部子控件
        [self setupSubViews];
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        // 创建内部子控件
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    
    //背景灰色
    UIView * bgView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    bgView.backgroundColor = RGBA(65, 65, 65, 0.81);
    bgView.layer.opacity = 0.64;
    //    [self addSubview:bgView];
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    self.bgView = bgView;
    
    self.frame = [[UIScreen mainScreen] bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self bringSubviewToFront:bgView];
    
    //中间弹框的view
    UIView *popView = [[UIView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH - 36,360)];
    popView.backgroundColor = [UIColor whiteColor];
    cornerRadiusView(popView, 10);
    popView.center = self.center;
    [self addSubview:popView];
    self.popView = popView;
    
    UIButton *exitBtn = [UIButton new];
    [popView addSubview:exitBtn];
    [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.mas_equalTo(18);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    [exitBtn setImage:[UIImage imageNamed:@"exitButton"] forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(exitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *downImgView =[[UIImageView alloc] init];
    downImgView.image = [UIImage imageNamed:@"reg_giving_coupou"];
    [popView addSubview:downImgView];
    [downImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(152, 134));
        make.centerX.equalTo(popView);
        make.top.mas_equalTo(50);
    }];
    
    UILabel *desTitlelab = [[UILabel alloc] init];
    desTitlelab.text = @"恭喜！获得新人现金券！";
    desTitlelab.textColor = RGB(68, 63, 77);
    desTitlelab.font = kPingFangBoldFont(22);
    desTitlelab.textAlignment = NSTextAlignmentCenter;
    [popView addSubview:desTitlelab ];
    [desTitlelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(popView);
        make.top.mas_equalTo(downImgView.mas_bottom).offset(15);
    }];
    
    UILabel *desLab = [[UILabel alloc] init];
    desLab.text = @"入会升级直接抵扣";
    desLab.textColor = RGB(65, 65, 65);
    desLab.font = kPingFangRegularFont(18);
    desLab.textAlignment = NSTextAlignmentCenter;
    [popView addSubview:desLab];
    [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(desTitlelab);
        make.top.mas_equalTo(desTitlelab.mas_bottom);
    }];
    
    UIButton *couponBtn = [UIButton new];
    [popView addSubview:couponBtn];
    [couponBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(desLab.mas_bottom).offset(40);
        make.centerX.mas_equalTo(desLab);
        make.size.mas_equalTo(CGSizeMake(188, 40));
    }];
    
    couponBtn.backgroundColor = [UIColor whiteColor];
    couponBtn.layer.cornerRadius = 20;
    couponBtn.layer.shadowRadius = 6;
    couponBtn.layer.shadowOffset = CGSizeMake(0, 5);
    couponBtn.layer.shadowOpacity = 0.8;
    couponBtn.layer.shadowColor = RGBA(175, 175, 175, 0.5).CGColor;
    
    couponBtn.titleLabel.font = kPingFangBoldFont(14);
    [couponBtn setTitle:@"查看我的钱包" forState:UIControlStateNormal];
    [couponBtn setTitleColor:RGB(226, 99, 142) forState:UIControlStateNormal];
    [couponBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    [couponBtn addTarget:self action:@selector(couponButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    popView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewViewClicked:)];
    [popView addGestureRecognizer:tap];
    
}

- (void)exitButtonClick:(UIButton *)btn {
    [self hide:YES];
}

- (void)couponButtonClick:(UIButton *)btn {
    [self hide:NO];
    if (self.couponButtonClicked) {
        self.couponButtonClicked(btn);
    }
}

- (void)bgViewViewClicked:(UITapGestureRecognizer *)tap {
    [self hide:YES];
}

- (void)show:(BOOL)animated
{
    if (animated)
    {
        self.transform = CGAffineTransformScale(self.transform,0,0);
        __weak XDGetCouponView *weakSelf = self;
        [UIView animateWithDuration:.3 animations:^{
            weakSelf.transform = CGAffineTransformScale(weakSelf.transform,1.2,1.2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.3 animations:^{
                weakSelf.transform = CGAffineTransformIdentity;
            }];
        }];
    }
}

- (void)hide:(BOOL)animated
{
    [self endEditing:YES];
    if (self.bgView != nil) {
        __weak XDGetCouponView *weakSelf = self;
        
        [UIView animateWithDuration:animated ?0.3: 0 animations:^{
            weakSelf.transform = CGAffineTransformScale(weakSelf.transform,1,1);
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration: animated ?0.3: 0 animations:^{
                weakSelf.transform = CGAffineTransformScale(weakSelf.transform,0.2,0.2);
            } completion:^(BOOL finished) {
                [weakSelf.bgView removeFromSuperview];
                [weakSelf removeFromSuperview];
                weakSelf.bgView = nil;
            }];
        }];
    }
    
}

@end
