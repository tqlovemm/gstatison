//
//  XDSeekItemTopView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/11/16.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDSeekItemTopView.h"

@interface XDSeekItemTopView ()

@property (nonatomic, strong) UIImageView *cycleScroll;

@property (nonatomic, strong) UIButton *countBtn;

@end

@implementation XDSeekItemTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    
    self.cycleScroll = [[UIImageView alloc] init];
    [self addSubview:self.cycleScroll];
    self.cycleScroll.contentMode = UIViewContentModeScaleAspectFill;
    self.cycleScroll.layer.masksToBounds = YES;
    
    self.countBtn = [[UIButton alloc] init];
    [self.countBtn setImage:[UIImage imageNamed:@"seek_photo"] forState:UIControlStateNormal];
    [self.countBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.countBtn setBackgroundColor:RGBA(68, 63, 77, 0.65)];
    [self.countBtn.titleLabel setFont:kPingFangRegularFont(10)];
    [self addSubview:self.countBtn];
    self.countBtn.layer.cornerRadius = 10;
    
    [self.cycleScroll sd_setImageWithURL:[NSURL URLWithString:@"http://ounw0bp6w.bkt.clouddn.com/uploads/user/files/2017/08/29/zy34659a4d1cf5fb4c59a54f34957da.jpg"] placeholderImage:[UIImage imageNamed:@"square_image_placeholder"]];
    [self.countBtn setTitle:@"2" forState:UIControlStateNormal];
    
    XD_WeakSelf
    [self.cycleScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.bottom.left.right.mas_equalTo(self);
    }];
    
    [self.countBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-14);
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(43, 20));
    }];
    
}

- (void)setPhoto:(NSString *)photo {
    _photo = photo;
    [self.cycleScroll sd_setImageWithURL:[NSURL URLWithString:photo] placeholderImage:[UIImage imageNamed:@"square_image_placeholder"]];
}

- (void)setPhotoCount:(NSInteger)photoCount {
    _photoCount = photoCount;
    [self.countBtn setTitle:[NSString stringWithFormat:@" %ld",photoCount] forState:UIControlStateNormal];
}

@end
