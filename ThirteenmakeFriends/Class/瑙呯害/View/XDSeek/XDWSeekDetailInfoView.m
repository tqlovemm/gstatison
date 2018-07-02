//
//  XDWSeekDetailInfoView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/11/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDWSeekDetailInfoView.h"
#import "XDWomanSeekModel.h"

@interface XDWSeekDetailInfoView ()

/** 主地区 */
@property (nonatomic, strong) UILabel *areeLabel;
/** 年龄 */
@property (nonatomic, strong) UILabel *ageLabel;
/** 描述 */
@property (nonatomic, strong) UILabel *desLabel;

@end

@implementation XDWSeekDetailInfoView

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
    
    UILabel *areeLabel = [[UILabel alloc] init];
    areeLabel.textColor = RGB(65, 65, 65);
    areeLabel.font = kPingFangBoldFont(15);
    [self addSubview:areeLabel];
    self.areeLabel = areeLabel;
    
    UILabel *ageLabel = [[UILabel alloc] init];
    ageLabel.textColor = RGB(20, 22, 55);
    ageLabel.font = kPingFangBoldFont(12);
    [self addSubview:ageLabel];
    self.ageLabel = ageLabel;
    
    UILabel *desLabel = [[UILabel alloc] init];
    desLabel.numberOfLines = 0;
    desLabel.textColor = RGB(119, 119, 119);
    desLabel.font = kPingFangRegularFont(12);
    desLabel.layer.cornerRadius = 9;
    [self addSubview:desLabel];
    self.desLabel = desLabel;
    
}

- (void)setUser:(XDWomanSeekModel *)user {
    _user = user;
    
    self.areeLabel.text = [NSString stringWithFormat:@"%@男生",user.area_one];
    self.ageLabel.text = [NSString stringWithFormat:@"%ld岁",user.age];
    self.desLabel.text = user.des;
    
    XD_WeakSelf
    [self.areeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(12);
    }];
    
    [self.ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.bottom.mas_equalTo(self.areeLabel.mas_bottom);
        make.left.mas_equalTo(self.areeLabel.mas_right).offset(12);
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.areeLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(self.areeLabel);
        make.right.mas_equalTo(-12);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-20);
    }];
}

@end
