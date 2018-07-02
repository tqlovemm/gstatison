//
//  MyModuleView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/6/8.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "MyModuleView.h"

#define ModuleTextColor RGB(119 ,119 ,119)

@interface MyModuleView ()
//! 头像
@property (weak, nonatomic) UIImageView *headIcon;
//! 模块名
@property (weak, nonatomic) UILabel *moduleNameLabel;
//! 模块值
@property (weak, nonatomic) UILabel *moduleValueLabel;

@end

@implementation MyModuleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    // 图片
    UIImageView *headIcon = [[UIImageView alloc] init];
    headIcon.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:headIcon];
    self.headIcon = headIcon;
    
    // 模块名
    UILabel *moduleName = [[UILabel alloc]init];
    moduleName.font = k12Font;
    moduleName.textAlignment = NSTextAlignmentLeft;
    moduleName.backgroundColor = [UIColor clearColor];
    moduleName.textColor = ModuleTextColor;
    [self addSubview:moduleName];
    self.moduleNameLabel = moduleName;
    
    // 模块值
    UILabel *moduleValue = [[UILabel alloc]init];
    moduleValue.font = k12Font;
    moduleValue.textAlignment = NSTextAlignmentRight;
    moduleValue.backgroundColor = [UIColor clearColor];
    moduleValue.textColor = ModuleTextColor;
    [self addSubview:moduleValue];
    self.moduleValueLabel = moduleValue;
    
}

- (void)setModule:(MyModule *)module {
    _module = module;
    
    self.headIcon.image = [UIImage imageNamed:module.imageName];
    self.moduleNameLabel.text = module.moduleName;
    self.moduleValueLabel.text = module.moduleValue;
    
#if APP_Puppet  // Puppet
    self.headIcon.size = CGSizeMake(30, 30);
    self.headIcon.y = 25;
    self.headIcon.centerX = self.width / 2.0;
    
    self.moduleNameLabel.size = [module.moduleName sizeWithFont:self.moduleNameLabel.font];
    self.moduleNameLabel.y = CGRectGetMaxY(self.headIcon.frame) + postCellBorder;
    self.moduleNameLabel.centerX = self.headIcon.centerX;
    
    self.moduleValueLabel.frame = CGRectMake(0, 0, 0, 0);
#elif APP_myPuppet
    self.headIcon.size = CGSizeMake(30, 30);
    self.headIcon.y = 25;
    self.headIcon.centerX = self.width / 2.0;
    
    self.moduleNameLabel.size = [module.moduleName sizeWithFont:self.moduleNameLabel.font];
    self.moduleNameLabel.y = CGRectGetMaxY(self.headIcon.frame) + postCellBorder;
    self.moduleNameLabel.centerX = self.headIcon.centerX;
    
    self.moduleValueLabel.frame = CGRectMake(0, 0, 0, 0);
#else // 正常
    self.headIcon.size = CGSizeMake(40, 40);
    self.headIcon.y = 20;
    self.headIcon.centerX = self.width / 2.0;
    
    self.moduleNameLabel.size = [module.moduleName sizeWithFont:postNameFont];
    self.moduleNameLabel.y = CGRectGetMaxY(self.headIcon.frame) + postCellBorder;
    self.moduleNameLabel.x = postCellBorder;
    
    self.moduleValueLabel.size = [module.moduleValue sizeWithFont:postNameFont];
    self.moduleValueLabel.y = self.moduleNameLabel.y;
    self.moduleValueLabel.x = self.width - self.moduleValueLabel.width - postCellBorder;
#endif
    
}

@end
