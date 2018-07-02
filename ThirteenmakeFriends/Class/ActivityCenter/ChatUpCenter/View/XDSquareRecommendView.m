//
//  XDSquareRecommendView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/11.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDSquareRecommendView.h"
#import "HJCornerRadius.h"
#import "XDSquareUserModel.h"
//#import "XDOtherViewController.h"
#import "XDShadowImgView.h"

#define userCount 4

@interface XDSquareRecommendView ()

@property (weak, nonatomic) UIImageView * tipView;

@property (weak, nonatomic) UILabel * tipLabel;

@property (nonatomic, strong) NSMutableArray *userViewsArray;

@end

@implementation XDSquareRecommendView

- (NSMutableArray *)userViewsArray {
    if (!_userViewsArray) {
        _userViewsArray = [NSMutableArray array];
    }
    return _userViewsArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setShadowBackgroundColor];
        [self xdd_setupSubViews];
    }
    return self;
}

- (void)xdd_setupSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView *tipView = [[UIImageView alloc] init];
    tipView.image = [UIImage imageNamed:@"member_meili"];
    [self addSubview:tipView];
    self.tipView = tipView;
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.font = kPingFangBoldFont(10);
    [self addSubview:tipLabel];
    self.tipLabel = tipLabel;
    tipLabel.text = @"推荐用户";
    
    self.tipView.x = 12;
    self.tipView.size = CGSizeMake(20, 20);
    self.tipView.centerY = self.height / 2.0;
    
    self.tipLabel.x = CGRectGetMaxX(self.tipView.frame) + 6;
    self.tipLabel.size = [self.tipLabel.text sizeWithFont:self.tipLabel.font];
    self.tipLabel.centerY = self.tipView.centerY;
    
    CGFloat width = 48;
    CGFloat height = 48;
    CGFloat margin = ((self.width - CGRectGetMaxX(self.tipLabel.frame)) - width * userCount) / (userCount + 1);
    CGFloat imgCenterY = self.tipView.centerY;
    
    for (int i = 0; i < userCount; i++) {
        XDShadowImgView *imgView = [[XDShadowImgView alloc] initWithFrame:CGRectMake(margin + (width + margin) * i + CGRectGetMaxX(self.tipLabel.frame), imgCenterY - height/2.0, width, height)];
        imgView.tag = i;
        [self addSubview:imgView];
        imgView.hidden = YES;
        imgView.userInteractionEnabled = YES;
        [self.userViewsArray addObject:imgView];
        
        UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTap:)];
        [imgView addGestureRecognizer:tap];
        
        // 设置阴影
//        imgView.layer.shadowColor = HEXCOLOR(0x8B3552).CGColor;
        imgView.layer.shadowColor = ThemeColor7.CGColor;
        imgView.layer.shadowOffset = CGSizeMake(0,1);
        imgView.layer.shadowOpacity = 1;
        imgView.layer.shadowRadius = 4;
        imgView.clipsToBounds = NO;
    }
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
    colorLayer.startPoint = CGPointMake(-1, 0.5);
    
    // 结束点
    colorLayer.endPoint   = CGPointMake(1, 0.5);
    
}

- (void)setUsersArray:(NSArray<XDSquareUserModel *> *)usersArray {
    _usersArray = usersArray;
    
    for (int i = 0; i < (usersArray.count <= userCount ? usersArray.count : userCount); i++) {
        XDShadowImgView *imgView = [self.userViewsArray objectAtIndex:i];
        XDSquareUserModel *person = [usersArray objectAtIndex:i];
        imgView.imgName = person.avatar;
        imgView.hidden = NO;
    }
    
    for (int i = (int)usersArray.count; i < userCount; i++) {
        XDShadowImgView *imgView = [self.userViewsArray objectAtIndex:i];
        imgView.hidden = YES;
    }
}

- (void)avatarTap:(UITapGestureRecognizer *)tap {
    NSLog(@"点击了第%ld个",tap.view.tag);
    XDSquareUserModel *person = [self.usersArray objectAtIndex:tap.view.tag];
//    XDOtherViewController *otherVC = [[XDOtherViewController alloc] init];
//    otherVC.username = person.username;
//    [self.navigationController pushViewController:otherVC animated:YES];
}

@end
