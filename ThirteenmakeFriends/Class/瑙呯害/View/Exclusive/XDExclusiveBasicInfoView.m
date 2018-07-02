//
//  XDExclusiveBasicInfoView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/9/6.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDExclusiveBasicInfoView.h"
#import "ExclusiveModel.h"

@interface XDExclusiveBasicInfoView ()
/** 主地区 */
@property (nonatomic, strong) UILabel *areeLabel;
/** 编号 */
@property (nonatomic, strong) UILabel *numberLabel;
/** 所有地区 */
@property (nonatomic, strong) UILabel *allAreeLabel;
/** 描述 */
@property (nonatomic, strong) UILabel *desLabel;
@end

@implementation XDExclusiveBasicInfoView

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
    areeLabel.font = kPingFangBoldFont(16);
    [self addSubview:areeLabel];
    self.areeLabel = areeLabel;
    
    UILabel *numberLabel = [[UILabel alloc] init];
    numberLabel.textColor = RGB(226, 99, 142);
    numberLabel.font = kPingFangRegularFont(12);
    [self addSubview:numberLabel];
    self.numberLabel = numberLabel;
    
    UILabel *allAreeLabel = [[UILabel alloc] init];
    allAreeLabel.textColor = RGB(119, 119, 119);
    allAreeLabel.font = kPingFangRegularFont(12);
    [self addSubview:allAreeLabel];
    self.allAreeLabel = allAreeLabel;
    
    UILabel *desLabel = [[UILabel alloc] init];
    desLabel.numberOfLines = 0;
    desLabel.textColor = RGB(119, 119, 119);
    desLabel.font = kPingFangRegularFont(12);
    [self addSubview:desLabel];
    self.desLabel = desLabel;
    
}

- (void)setSeekModel:(ExclusiveModel *)seekModel {
    _seekModel = seekModel;
    
    self.areeLabel.text = [NSString stringWithFormat:@"%@妹子",seekModel.address];
    self.numberLabel.text = [NSString stringWithFormat:@"UID:%@",seekModel.zid];
    self.allAreeLabel.text = [NSString stringWithFormat:@"工作生活在：%@",seekModel.address];
    self.desLabel.text = seekModel.introduction;
    
    XD_WeakSelf
    [self.areeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14);
        make.left.mas_equalTo(10);
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.areeLabel.mas_bottom).offset(4);
        make.left.mas_equalTo(11);
    }];
    
    [self.allAreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.numberLabel.mas_bottom).offset(4);
        make.left.mas_equalTo(self.numberLabel.mas_left);
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.allAreeLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.allAreeLabel.mas_left);
        make.right.mas_equalTo(-11);
        //        make.bottom.mas_equalTo(self).offset(-20);
        make.bottom.mas_equalTo(self).offset(seekModel.introduction.length > 0 ? -20 : -10);
    }];
}

@end
