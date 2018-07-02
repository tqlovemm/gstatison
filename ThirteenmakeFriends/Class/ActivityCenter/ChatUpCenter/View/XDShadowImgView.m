//
//  XDShadowImgView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/19.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDShadowImgView.h"
#import "HJCornerRadius.h"

@interface XDShadowImgView ()

@property (weak, nonatomic) UIImageView * imgView;

@end

@implementation XDShadowImgView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.bounds];
    imgView.aliCornerRadius = self.width / 2.0;
    [self addSubview:imgView];
    self.imgView = imgView;
}

- (void)setImgName:(NSString *)imgName {
    _imgName = imgName;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:imgName] placeholderImage:[UIImage imageNamed:@"square_image_placeholder"]];
}

@end
