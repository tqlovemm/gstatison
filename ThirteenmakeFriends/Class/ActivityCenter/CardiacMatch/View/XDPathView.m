//
//  XDPathView.m
//  MultiTargetApp
//
//  Created by Xudongdong on 2017/11/29.
//  Copyright © 2017年 Xudongdong. All rights reserved.
//

#import "XDPathView.h"

#import <QuartzCore/QuartzCore.h>
#define RYUIColorWithRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface XDPathView ()<CAAnimationDelegate>

@end

@implementation XDPathView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self gradentWith:frame];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self gradentWith];
        
    }
    return self;
}
- (void)gradentWith{
    NSLog(@"=-----%f",CGRectGetMidX(self.frame));
    
}
- (void)gradentWith:(CGRect)frame{
    
    // 创建一个tracker(轨道layer)
    CAShapeLayer *trackLayer = [CAShapeLayer layer];
    trackLayer.frame = self.bounds;
    [self.layer addSublayer:trackLayer];
    trackLayer.fillColor = [UIColor clearColor].CGColor;
    trackLayer.strokeColor = RYUIColorWithRGB(240, 239, 245).CGColor;
    // 背景透明度
    trackLayer.opacity = 0.6f;
    trackLayer.lineCap = kCALineCapRound;
    trackLayer.lineWidth = PROGRESS_LINE_WIDTH;
    // 创建轨道
    UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2) radius:(frame.size.width-PROGRESS_LINE_WIDTH)/2-5 startAngle:degressToRadius(-240) endAngle:degressToRadius(120) clockwise:YES];
    trackLayer.path = [path2 CGPath];
    
    //设置贝塞尔曲线
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:(frame.size.width-PROGRESS_LINE_WIDTH)/2-5 startAngle:degressToRadius(-240) endAngle:degressToRadius(60) clockwise:YES];
    
    //遮罩层
    
    _progressLayer = [CAShapeLayer layer];
    
    _progressLayer.frame = self.bounds;
    
    _progressLayer.fillColor =  [[UIColor clearColor] CGColor];
    
    _progressLayer.strokeColor=[UIColor redColor].CGColor;
    
    _progressLayer.lineCap = kCALineCapRound;
    
    _progressLayer.lineWidth = PROGRESS_LINE_WIDTH;
    
    
    
    //渐变图层
    CALayer * grain = [CALayer layer];
    
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    
    gradientLayer.frame = CGRectMake(0, 0, self.bounds.size.width/2, self.bounds.size.height);
    
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)[RYUIColorWithRGB(233, 174, 121) CGColor],(id)[RYUIColorWithRGB(232, 63, 120) CGColor], nil]];
    
    [gradientLayer setLocations:@[@0.1,@0.9]];
    
    [gradientLayer setStartPoint:CGPointMake(0.05, 1)];
    
    [gradientLayer setEndPoint:CGPointMake(0.9, 0)];
    [grain addSublayer:gradientLayer];
    
    
    CAGradientLayer * gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = CGRectMake(self.bounds.size.width/2-10, 0, self.bounds.size.width/2+10, self.bounds.size.height);

    [gradientLayer1 setColors:[NSArray arrayWithObjects:(id)[RYUIColorWithRGB(232, 63, 120) CGColor],(id)[RYUIColorWithRGB(233, 174, 121) CGColor], nil]];
    [gradientLayer1 setLocations:@[@0.3,@1]];

    [gradientLayer1 setStartPoint:CGPointMake(0.9, 0.05)];

    [gradientLayer1 setEndPoint:CGPointMake(1, 1)];
    [grain addSublayer:gradientLayer1];
    
    //用progressLayer来截取渐变层 遮罩
    
    [grain setMask:_progressLayer];
    
    [self.layer addSublayer:grain];
    
    
    //增加动画
    
    CABasicAnimation *pathAnimation=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    
    pathAnimation.duration = 0.8;
    
    pathAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    pathAnimation.fromValue=[NSNumber numberWithFloat:0.0f];
    
    pathAnimation.toValue=[NSNumber numberWithFloat:1.0f];
    
    pathAnimation.autoreverses=NO;
    pathAnimation.repeatCount = 1;
    _progressLayer.path=path.CGPath;
    
    [_progressLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];

    [self performSelector:@selector(rotatingAnimation:) withObject:_progressLayer afterDelay:0.8];
    
}

- (void)rotatingAnimation:(CAShapeLayer *)rippleLayer {
    /* 旋转 */
    
    // 对Y轴进行旋转（指定Z轴的话，就和UIView的动画一样绕中心旋转）
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    // 设定动画选项
    animation.duration = 8; // 持续时间
    animation.repeatCount = FLT_MAX; // 重复次数
    //    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    // 设定旋转角度
    animation.fromValue = [NSNumber numberWithFloat:0.0]; // 起始角度
    animation.toValue = [NSNumber numberWithFloat:22 * M_PI]; // 终止角度
    
    // 添加动画
    [rippleLayer addAnimation:animation forKey:@"rotate-layer"];
}

@end
