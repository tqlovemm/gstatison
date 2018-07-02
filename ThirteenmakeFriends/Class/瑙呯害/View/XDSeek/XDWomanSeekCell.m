//
//  XDWomanSeekCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/11/8.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDWomanSeekCell.h"
#import "XDSeekItemTopView.h"
#import "XDWomanSeekModel.h"
#import "XDSeekItemBottomView.h"

@interface XDWomanSeekCell ()

/** 图片view */
@property (nonatomic, strong) XDSeekItemTopView *topView;

@property (nonatomic, strong) XDSeekItemBottomView *bottomView;

@end

@implementation XDWomanSeekCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setupSubviews];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setupSubviews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 2;
    self.contentView.clipsToBounds = YES;
    
    XDSeekItemTopView *topView = [[XDSeekItemTopView alloc] init];
    [self.contentView addSubview:topView];
    self.topView = topView;
    
    XDSeekItemBottomView *bottomView = [[XDSeekItemBottomView alloc] init];
    [self.contentView addSubview:bottomView];
    self.bottomView = bottomView;
}

- (void)setUser:(XDWomanSeekModel *)user {
    _user = user;
    
    self.topView.photo = [user.photos firstObject];
    self.topView.photoCount = user.photos.count;
    self.bottomView.user = user;
    
    XD_WeakSelf
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.left.right.top.mas_equalTo(self.contentView);
        make.height.equalTo(self.topView.mas_width).multipliedBy(1);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.left.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.height.mas_equalTo(92);
    }];
}

@end
