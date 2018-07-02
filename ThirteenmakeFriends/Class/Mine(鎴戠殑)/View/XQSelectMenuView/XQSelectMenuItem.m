//
//  XQSelectMenuItem.m
//  上下级菜单选择器
//
//  Created by 徐强 on 15/10/30.
//  Copyright © 2015年 xuqiang. All rights reserved.
//

#import "XQSelectMenuItem.h"

@interface XQSelectMenuItem ()

@property (nonatomic, weak) UILabel *label;

@end

@implementation XQSelectMenuItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addControl];
    }
    return self;
}

- (void)addControl{
    
    UILabel *label = [[UILabel alloc] init];
    label.text = self.labelText;
    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [UIFont systemFontOfSize:13.0f];
    label.font = [UIFont systemFontOfSize:13.0f];
    label.textColor = [UIColor whiteColor];
    [self addSubview:label];
    self.label = label;
    
    self.backgroundColor = ThemeColor;
    self.layer.cornerRadius = 3.0;
    self.layer.masksToBounds = YES;
    self.layer.shouldRasterize = NO;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)setLabelText:(NSString *)labelText{
    _labelText = labelText;
    self.label.text = labelText;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.label.frame = self.bounds;
}

- (void)setLabelColor:(UIColor *)labelColor {
    _labelColor = labelColor;
    
    if (labelColor) {
        self.backgroundColor = labelColor;
    }
}


@end
