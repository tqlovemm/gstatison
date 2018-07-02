//
//  CustomBtn.m
//  0710Test
//
//  Created by XDD on 15/7/10.
//  Copyright (c) 2015年 XDD. All rights reserved.
//

#import "CustomBtn.h"

#define CustomBtnImageW 20

@implementation CustomBtn

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 高亮时不要自动调整图标
        self.adjustsImageWhenHighlighted = NO;
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        // 字体颜色
        [self setTitleColor:RGB(34, 34, 44) forState:UIControlStateNormal];
        // 高亮背景
        [self setBackgroundImage:[UIImage imageNamed:@"alphaBtn"] forState:UIControlStateHighlighted];
        
    }
    return self;
}

+(instancetype)titleButton
{
    return [[self alloc]init];
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageY = 0;
    CGFloat imageW = CustomBtnImageW;
    CGFloat imageX = contentRect.size.width - imageW;
    CGFloat imageH = contentRect.size.height;
    return CGRectMake(imageX, imageY, imageW, imageH);
}
    
-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleY = 0;
    CGFloat titleW = contentRect.size.width - CustomBtnImageW;
    CGFloat titleH = contentRect.size.height;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

@end
