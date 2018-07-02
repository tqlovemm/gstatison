//
//  XDUpgradeBottomView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDUpgradeBottomView.h"
#import "UIButton+HQCustomIcon.h"
#import "XDCardModel.h"
#import "ProfileUser.h"
#import "XDAccountTool.h"

#if APP_Puppet  // Puppet
#define kTextColor [UIColor whiteColor]
#elif APP_myPuppet
#define kTextColor RGB(241, 196, 121)
#else // 正常
#define kTextColor [UIColor whiteColor]
#endif

@interface XDUpgradeBottomView ()

/** 咨询客服 */
@property (nonatomic, weak) UIButton *serviceBtn;
/** 升级按钮 */
@property (nonatomic, weak) UIButton *upgradeBtn;
/** 升级按钮 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 升级按钮 */
@property (nonatomic, weak) UILabel *desLabel;

@end

@implementation XDUpgradeBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        // 设置渐变背景
        [self setShadowBackgroundColor];
        // 创建cell内部子控件
        [self setupSubViews];
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        // 设置渐变背景
        [self setShadowBackgroundColor];
        
        // 创建cell内部子控件
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    self.backgroundColor = [UIColor whiteColor];
    
    UIButton *upgradeBtn = [[UIButton alloc] init];
    [upgradeBtn setImage:[UIImage imageNamed:@"upgrade_arrow"] forState:UIControlStateNormal];
    [upgradeBtn setTitle:@"升级会员" forState:UIControlStateNormal];
    [upgradeBtn setTitleColor:kTextColor forState:UIControlStateNormal];
    upgradeBtn.titleLabel.font = kPingFangRegularFont(20);
    upgradeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    upgradeBtn.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
    
    [self addSubview:upgradeBtn];
    self.upgradeBtn = upgradeBtn;
    
    [upgradeBtn addTarget:self action:@selector(upgradeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    upgradeBtn.frame = self.bounds;
    [upgradeBtn setIconInRightWithSpacing:5];
    
    UIButton *serviceBtn = [[UIButton alloc] init];
    [serviceBtn setImage:[UIImage imageNamed:@"consulting_service"] forState:UIControlStateNormal];
    [self addSubview:serviceBtn];
    self.serviceBtn = serviceBtn;
    [serviceBtn addTarget:self action:@selector(serviceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textColor = kTextColor;
    timeLabel.font = kPingFangRegularFont(12);
    [self addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    UILabel *desLabel = [[UILabel alloc] init];
    desLabel.textColor = kTextColor;
    desLabel.font = kPingFangRegularFont(20);
    [self addSubview:desLabel];
    self.desLabel = desLabel;
    
    XD_WeakSelf
    [self.upgradeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
//        make.left.right.top.bottom.mas_equalTo(self);
        make.left.right.top.mas_equalTo(self);
        make.height.mas_equalTo(52);
    }];
    
    [self.serviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
//        make.centerY.mas_equalTo(self);
        make.centerY.mas_equalTo(self.upgradeBtn);
        make.size.mas_equalTo(CGSizeMake(69, 36));
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(6);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(-2);
        make.centerX.mas_equalTo(self);
    }];
}

/**
 *  设置渐变背景
 */
- (void)setShadowBackgroundColor {
    CAGradientLayer *colorLayer = [CAGradientLayer layer];
    colorLayer.frame    = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    colorLayer.position = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
    [self.layer addSublayer:colorLayer];
    
    
#if APP_Puppet  // Puppet
    // 颜色分配
    colorLayer.colors = @[(__bridge id)[UIColor colorWithRed:233/255.0f green:174/255.0f blue:121/255.0f alpha:1].CGColor,
                          (__bridge id)[UIColor colorWithRed:232/255.0f green:63/255.0f blue:120/255.0f alpha:1].CGColor
                          ];
#elif APP_myPuppet
    // 颜色分配
    colorLayer.colors = @[(__bridge id)[UIColor colorWithRed:41/255.0f green:35/255.0f blue:54/255.0f alpha:1].CGColor,
                          (__bridge id)[UIColor colorWithRed:41/255.0f green:35/255.0f blue:54/255.0f alpha:1].CGColor
                          ];
#else // 正常
    // 颜色分配
    colorLayer.colors = @[(__bridge id)[UIColor colorWithRed:233/255.0f green:174/255.0f blue:121/255.0f alpha:1].CGColor,
                          (__bridge id)[UIColor colorWithRed:232/255.0f green:63/255.0f blue:120/255.0f alpha:1].CGColor
                          ];
#endif
    // 颜色分割线
    //    colorLayer.locations  = @[@(0.25), @(0.75)];
    
    // 起始点
    colorLayer.startPoint = CGPointMake(0, 0.5);
    
    // 结束点
    colorLayer.endPoint   = CGPointMake(1, 0.5);
}

#pragma mark - 按钮点击事件

/**
 咨询客服
 */
- (void)serviceBtnClicked:(UIButton *)btn {
    WEAKSELF
    if (weakSelf.serviceButtonClicked) {
        weakSelf.serviceButtonClicked(btn);
    }
}

/**
 会员升级
 */
- (void)upgradeBtnClicked:(UIButton *)btn {
    WEAKSELF
    if (weakSelf.upgradeButtonClicked) {
        weakSelf.upgradeButtonClicked(btn);
    }
}

- (void)setCardModel:(XDCardModel *)cardModel {
    _cardModel = cardModel;
    
    [self setNeedsLayout];
}

- (void)setVip_deadline:(NSString *)vip_deadline {
    _vip_deadline = vip_deadline;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    ProfileUser *user = [XDAccountTool account];
    if ([user.groupid integerValue] >= self.cardModel.groupid) {
        [self.upgradeBtn setImage:nil forState:UIControlStateNormal];
        [self.upgradeBtn setTitle:nil forState:UIControlStateNormal];
//        self.timeLabel.text = self.vip_deadline;
        self.desLabel.text = [NSString stringWithFormat:@"您当前为%@",[user getMemberName]];
    } else {
        [self.upgradeBtn setImage:[UIImage imageNamed:@"upgrade_arrow"] forState:UIControlStateNormal];
        [self.upgradeBtn setTitle:@"升级会员" forState:UIControlStateNormal];
//        self.timeLabel.text = nil;
        self.desLabel.text = nil;
    }
    
    if (self.vip_deadline.length > 0 && [user.groupid integerValue] >= self.cardModel.groupid) {
        self.timeLabel.text = [NSString stringWithFormat:@"有效期至%@",self.vip_deadline];
        [self.desLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(-2);
            make.centerX.mas_equalTo(self);
        }];
    } else {
        self.timeLabel.text = nil;
        [self.desLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(self);
//            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(5);
            make.centerX.mas_equalTo(self);
        }];
    }
}

@end
