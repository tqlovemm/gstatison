//
//  XDPhotoScrollView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/8/30.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDPhotoScrollView.h"
#import "SDCycleScrollView.h"
#import "XDPhotoBrowser.h"

@interface XDPhotoScrollView ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleScroll;

@property (nonatomic, strong) UIButton *countBtn;

@end

@implementation XDPhotoScrollView

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
    
    self.cycleScroll = [[SDCycleScrollView alloc] init];
    self.cycleScroll.delegate = self;
    self.cycleScroll.placeholderImage = [UIImage imageNamed:@"square_image_placeholder"];
    self.cycleScroll.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.cycleScroll.autoScrollTimeInterval = 2;
    XD_WeakSelf
    self.cycleScroll.clickItemOperationBlock = ^(NSInteger currentIndex) {
        XD_StrongSelf
        XDPhotoBrowser *photoBrowser = [XDPhotoBrowser defaultManager];
        [photoBrowser showBrowserWithImages:self.photos andCurrentIndex:currentIndex fromImageContainer:self.cycleScroll];
    };
    [self addSubview:self.cycleScroll];
    
    self.countBtn = [[UIButton alloc] init];
    [self.countBtn setImage:[UIImage imageNamed:@"seek_photo"] forState:UIControlStateNormal];
    [self.countBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.countBtn setBackgroundColor:RGBA(68, 63, 77, 0.65)];
    [self.countBtn.titleLabel setFont:kPingFangRegularFont(10)];
    [self addSubview:self.countBtn];
    self.countBtn.layer.cornerRadius = 10;
    
    self.cycleScroll.localizationImageNamesGroup = @[@"http://ounw0bp6w.bkt.clouddn.com/uploads/user/files/2017/08/29/zy34659a4d1cf5fb4c59a54f34957da.jpg",@"http://ounw0bp6w.bkt.clouddn.com/uploads/user/avatar/2017/08/30/4158259a65fe87e079.jpg"];
    [self.countBtn setTitle:@"2" forState:UIControlStateNormal];
    
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

- (void)setPhotos:(NSArray *)photos {
    _photos = photos;
    
    self.cycleScroll.localizationImageNamesGroup = photos;
    [self.countBtn setTitle:[NSString stringWithFormat:@" %ld",photos.count] forState:UIControlStateNormal];
}

@end
