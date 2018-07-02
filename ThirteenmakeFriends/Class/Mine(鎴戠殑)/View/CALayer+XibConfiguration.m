//
//  CALayer+XibConfiguration.m
//  demo30-0
//
//  Created by 空谷凌虚 on 2018/5/31.
//  Copyright © 2018年 空谷凌虚. All rights reserved.
//

#import "CALayer+XibConfiguration.h"

@implementation CALayer (XibConfiguration)


-(void)setBorderUIColor:(UIColor*)color{
    self.borderColor = color.CGColor;
}

-(UIColor *)borderUIColor{
    return [UIColor colorWithCGColor:self.borderColor];
}

-(void)setShadowUIColor:(UIColor*)color
{
    self.shadowColor = color.CGColor;
}

-(UIColor *)shadowUIColor
{
    return [UIColor colorWithCGColor:self.shadowColor];
}


@end
