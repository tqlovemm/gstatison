//
//  XDIsMatchView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/12/15.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDIsMatchView.h"
#import "YYImage.h"
#import "XDRadarView.h"

@interface XDIsMatchView ()

@property (nonatomic, weak) UIImageView * heartView;

@property (nonatomic, weak) UIImageView * rotateView;

@property (nonatomic, weak) UILabel * matchLabel;

@property (nonatomic, weak) UILabel *countdownLabel;

@property (nonatomic, assign) NSInteger downCount;

@end

@implementation XDIsMatchView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {

    // 人物闪动
    YYAnimatedImageView *bgPersonView = [[YYAnimatedImageView alloc] init];
    bgPersonView.image = [YYImage imageNamed:@"match_person_animation"];
    [self addSubview:bgPersonView];
    
    XDRadarView *radarView = [[XDRadarView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.width * 14 / 15.0) andThumbnail:@"app_icon" andRaderColor:HEXCOLOR(0xf5c6d1)];
    [self addSubview:radarView];
    
    // 旋转
    UIImageView *rotateView = [[UIImageView alloc] init];
    rotateView.image = [UIImage imageNamed:@"match_roate"];
    rotateView.layer.anchorPoint = CGPointMake(1, 0);
    [self addSubview:rotateView];
    self.rotateView = rotateView;
    
    // 心跳
    UIImageView *heartView = [[UIImageView alloc] init];
    heartView.image = [UIImage imageNamed:@"heart_dump"];
    [self addSubview:heartView];
    self.heartView = heartView;
    
    // 心电图
    YYAnimatedImageView *ecgView = [[YYAnimatedImageView alloc] init];
    ecgView.image = [YYImage imageNamed:@"match_ecg_animation"];
    [self addSubview:ecgView];
    
    UILabel *ismatchLabel = [[UILabel alloc] init];
    ismatchLabel.text = @"正在匹配";
    ismatchLabel.textColor = RGB(19, 19, 19);
    ismatchLabel.font = kPingFangThinFont(22);
    [self addSubview:ismatchLabel];
    self.matchLabel = ismatchLabel;
    
    UILabel *countdownLabel = [[UILabel alloc] init];
    countdownLabel.text = @"匹配倒时间";
    countdownLabel.textColor = ThemeColor1;
    countdownLabel.font = kPingFangRegularFont(16);
    [self addSubview:countdownLabel];
    self.countdownLabel = countdownLabel;
    
    [self dump];
    [self rotateAnimation];
    [self ShowHiddenAnimation];
    
//    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    XD_WeakSelf
    [bgPersonView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
//        make.size.mas_equalTo(CGSizeMake(self.width, self.width * 14 / 15.0));
        make.width.mas_equalTo(self);
        make.height.mas_equalTo(bgPersonView.mas_width).multipliedBy(14/15.0);
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(self);
    }];
    
    [heartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(110, 89));
        make.centerX.mas_equalTo(bgPersonView.mas_centerX);
        make.centerY.mas_equalTo(bgPersonView.mas_centerY);
    }];
    
    [rotateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(167, 78));
        make.centerX.mas_equalTo(bgPersonView.mas_centerX);
        make.centerY.mas_equalTo(bgPersonView.mas_centerY);
    }];
    
    [ecgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.width, self.width * 14 / 15.0));
        make.centerX.mas_equalTo(bgPersonView.mas_centerX);
        make.centerY.mas_equalTo(bgPersonView.mas_centerY);
    }];
    
    [ismatchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgPersonView.mas_centerX);
        make.top.mas_equalTo(heartView.mas_bottom).offset(10);
    }];
    
    [countdownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(ismatchLabel.mas_centerX);
        make.top.mas_equalTo(ismatchLabel.mas_bottom).offset(5);
//        make.bottom.mas_equalTo(self).offset(-20);
    }];
}

#pragma mark - 心跳动画
/**
 *  心跳
 */
- (void)dump {
    
    float bigSize = 1.1;
    CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulseAnimation.duration = 0.5;
    pulseAnimation.toValue = [NSNumber numberWithFloat:bigSize];
    pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    // 倒转动画
    pulseAnimation.autoreverses = YES;
    // 设置重复次数为无限大
    pulseAnimation.repeatCount = FLT_MAX;
    // 动画页面push后pop返回动画继续
    pulseAnimation.removedOnCompletion = NO;
    // 添加动画到layer
    [self.heartView.layer addAnimation:pulseAnimation forKey:@"transform.scale"];
    
}

#pragma mark - 旋转动画
- (void)rotateAnimation {
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue =  [NSNumber numberWithFloat: M_PI *2];
    animation.duration  = 3;
    animation.autoreverses = NO;
    animation.fillMode =kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    // 动画页面push后pop返回动画继续
    animation.removedOnCompletion = NO;
    
    [self.rotateView.layer addAnimation:animation forKey:@"transform.rotation.z"];
}

#pragma mark - 隐藏显示动画
- (void)ShowHiddenAnimation {
    CABasicAnimation *hiddenAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    hiddenAnimation.fromValue = [NSNumber numberWithInt:1];
    hiddenAnimation.toValue = [NSNumber numberWithInt:0];
    hiddenAnimation.duration = 0.5;
    hiddenAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    // 倒转动画
    hiddenAnimation.autoreverses = YES;
    // 设置重复次数为无限大
    hiddenAnimation.repeatCount = FLT_MAX;
    // 动画页面push后pop返回动画继续
    hiddenAnimation.removedOnCompletion = NO;
    // 添加动画到layer
    [self.matchLabel.layer addAnimation:hiddenAnimation forKey:@"addLayerAnimationOpacity"];
}

#pragma mark - 倒计时
- (void)setMinCount:(NSInteger)minCount {
    _minCount = minCount;
    
    self.downCount = minCount;
    [self setCountdownLabelText];
}

-(void)timerFired:(NSTimer *)timer
{
    if (self.downCount !=1) {
        self.downCount -=1;
        [self setCountdownLabelText];
    }
    else
    {
        [timer invalidate];
        self.countdownLabel.text = [NSString stringWithFormat:@"匹配结束"];
        if (self.countdownFinished) {
            self.countdownFinished(YES);
        }
    }
}

- (void)setCountdownLabelText {
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",self.downCount/3600];
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(self.downCount%3600)/60];
    NSString *str_second = [NSString stringWithFormat:@"%02ld",self.downCount%60];
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    //修改倒计时标签现实内容
    self.countdownLabel.text = format_time;
}

@end
