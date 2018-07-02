//
//  XDPersonBasicInfoView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/12/20.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDPersonBasicInfoView.h"
#import "ShiSanUser.h"
#import "NSString+Age.h"

@interface XDPersonBasicInfoView ()

/** 昵称 */
@property (nonatomic, strong) UILabel *nicknameLabel;
/** 基本信息 */
@property (nonatomic, strong) UILabel *infoLabel;
/** 所有地区 */
@property (nonatomic, strong) UILabel *allAreeLabel;
/** 描述 */
@property (nonatomic, strong) UILabel *desLabel;

@end

@implementation XDPersonBasicInfoView

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
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *nicknameLabel = [[UILabel alloc] init];
    nicknameLabel.textColor = RGB(65, 65, 65);
    nicknameLabel.font = kPingFangBoldFont(16);
    [self addSubview:nicknameLabel];
    self.nicknameLabel = nicknameLabel;
    
    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.textColor = RGB(226, 99, 142);
    infoLabel.font = kPingFangRegularFont(12);
    [self addSubview:infoLabel];
    self.infoLabel = infoLabel;
    
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
    
    XD_WeakSelf
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14);
        make.left.mas_equalTo(10);
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.nicknameLabel.mas_bottom).offset(4);
        make.left.mas_equalTo(11);
    }];
    
    [self.allAreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.infoLabel.mas_bottom).offset(4);
        make.left.mas_equalTo(self.infoLabel.mas_left);
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.allAreeLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.allAreeLabel.mas_left);
        make.right.mas_equalTo(-11);
        make.bottom.mas_equalTo(self).offset(-20);
    }];
    
}

- (void)setUser:(ShiSanUser *)user {
    _user = user;
    
    self.nicknameLabel.text = user.nickname;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    dateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    NSDate *ageDate = [dateFormatter dateFromString:user.birthdate];
    
    NSString *age = [NSString fromDateToAge:ageDate];
    self.infoLabel.text = [NSString stringWithFormat:@"%@岁 · %@cm · %@kg",age,user.height,user.weight];
    NSString *areaStr = [NSString stringWithFormat:@"%@",user.area_one];
    if (user.area_two) {
        areaStr = [areaStr stringByAppendingString:[NSString stringWithFormat:@" %@",user.area_two]];
    }
    if (user.area_three) {
        areaStr = [areaStr stringByAppendingString:[NSString stringWithFormat:@" %@",user.area_three]];
    }
    self.allAreeLabel.text = [NSString stringWithFormat:@"工作生活在：%@",areaStr];
    self.desLabel.text = user.signature;
}

@end
