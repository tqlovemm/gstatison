//
//  XDSeekPhotoView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/9/1.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDSeekPhotoView.h"

@interface XDSeekPhotoView ()

@property (nonatomic, strong) UIImageView *cycleScroll;

@property (nonatomic, strong) UIButton *countBtn;

@property (nonatomic, strong) UIButton *recommendBtn;

@end

@implementation XDSeekPhotoView

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
    
    self.recommendBtn = [[UIButton alloc] init];
    [self.recommendBtn setImage:[UIImage imageNamed:@"seek_recommended"] forState:UIControlStateNormal];
    [self.recommendBtn setImage:[UIImage imageNamed:@"seek_full"] forState:UIControlStateDisabled];
    [self.recommendBtn addTarget:self action:@selector(recommendBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.recommendBtn];
    // 给按钮设置阴影
    self.recommendBtn.layer.cornerRadius = 20;
    self.recommendBtn.layer.shadowRadius = 3;
    self.recommendBtn.layer.shadowOffset = CGSizeMake(0, 1);
    self.recommendBtn.layer.shadowOpacity = 0.8;
    self.recommendBtn.layer.shadowColor = ThemeColor7.CGColor;
    
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
    
    [self.recommendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.bottom.mas_equalTo(-10);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(188, 40));
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

- (void)setIs_limited:(BOOL)is_limited {
    _is_limited = is_limited;
    
    self.recommendBtn.enabled = !is_limited;
    
    if (self.recommendBtn.enabled) {
        self.recommendBtn.layer.shadowColor = ThemeColor7.CGColor;
    } else {
        self.recommendBtn.layer.shadowColor = RGB(170, 170, 170).CGColor;
    }
}

- (void)recommendBtnClicked:(UIButton *)btn {
    if (self.recommendButtonClicked) {
        self.recommendButtonClicked(btn);
    }
}

@end
