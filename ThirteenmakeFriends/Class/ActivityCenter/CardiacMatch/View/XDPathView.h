//
//  XDPathView.h
//  MultiTargetApp
//
//  Created by Xudongdong on 2017/11/29.
//  Copyright © 2017年 Xudongdong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define degressToRadius(ang) (M_PI*(ang)/180.0f) //把角度转换成PI的方式
#define PROGRESS_WIDTH 80 // 圆直径
#define PROGRESS_LINE_WIDTH 5 //弧线的宽度

@interface XDPathView : UIView
{
    CAShapeLayer * _trackLayer;
    CAShapeLayer * _progressLayer;
    
}

@end
