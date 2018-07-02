//
//  GirftBtn.m
//  ThirteenmakeFriends
//
//  Created by jie.huang on 2018/4/13.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "GirftBtn.h"

@implementation GirftBtn

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
         self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = RGB(31, 29, 29);
        self.titleLabel.font=[UIFont systemFontOfSize:12.0];
        
    }
    return self;
}




-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.y = 0;
    self.imageView.centerX =self.width/2;
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.bottom;
    self.titleLabel.height = self.height-self.titleLabel.y ;
    self.titleLabel.width = self.width;
}

@end
