//
//  XDFlopRecordCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/6/8.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDFlopRecordCell.h"
#import "UIImageView+WebCache.h"
#import "XDFlopEvaluationModel.h"
#import "ShiSanUser.h"
#import "Masonry.h"
#import "NSString+Age.h"

@interface XDFlopRecordCell ()
//! 头像
@property (nonatomic, weak) UIImageView *iconView;
//! 昵称
@property (nonatomic, weak) UILabel *nameLabel;
//! 年龄
@property (nonatomic, weak) UIImageView *sexView;
//! 正文
@property (nonatomic, weak) UILabel *addressLabel;
//! 年龄
@property (nonatomic, weak) UILabel *ageLabel;
//! 是否匹配
@property (nonatomic, weak) UILabel *isMatchLabel;
//! lineView
@property (nonatomic, weak) UIView *lineView;

@end

@implementation XDFlopRecordCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 创建子视图
        [self setupSubViews];
    }
    return self;
}

/**
 创建子视图
 */
- (void)setupSubViews {
    
    // 头像
    UIImageView *iconView = [[UIImageView alloc]init];
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    
    // 昵称
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.font = k14Font;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = RGB(65, 65, 65);
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    // 性别
    UIImageView *sexView = [[UIImageView alloc]init];
    [self.contentView addSubview:sexView];
    self.sexView = sexView;
    
    // 地址
    UILabel *addressLabel = [[UILabel alloc]init];
    addressLabel.font = k12Font;
    addressLabel.textColor = RGB(119, 119, 119);
    addressLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:addressLabel];
    self.addressLabel = addressLabel;
    
    // 年龄
    UILabel *ageLabel = [[UILabel alloc]init];
    ageLabel.font = k12Font;
    ageLabel.textColor = RGB(119, 119, 119);
    ageLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:ageLabel];
    self.ageLabel = ageLabel;
    
    // lineView
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = RGB(230, 230, 230);
    [self.contentView addSubview:lineView];
    self.lineView = lineView;
    
    // 是否匹配
    UILabel *isMatchLabel = [[UILabel alloc]init];
    isMatchLabel.font = [UIFont systemFontOfSize:10];
    isMatchLabel.textColor = RGB(155, 155, 155);
    isMatchLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:isMatchLabel];
    self.isMatchLabel = isMatchLabel;
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    self.iconView.layer.cornerRadius = 25;
    self.iconView.layer.masksToBounds = YES;
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(17);
        make.left.mas_equalTo(self.iconView.mas_right).mas_offset(10);
    }];
    
    [self.ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_offset(6);
        make.left.mas_equalTo(self.nameLabel);
    }];
    
    [self.sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_top);
        make.left.mas_equalTo(self.nameLabel.mas_right).mas_offset(5);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.ageLabel);
        make.left.mas_equalTo(self.ageLabel.mas_right).mas_offset(6);
        make.size.mas_equalTo(CGSizeMake(1, 10));
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.ageLabel);
        make.left.mas_equalTo(self.lineView.mas_right).mas_offset(5);
    }];
    
    [self.isMatchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(35);
        make.right.mas_equalTo(-7);
    }];
}

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"XDFlopRecordCellID";
    XDFlopRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[XDFlopRecordCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

- (void)setMatchModel:(XDFlopEvaluationModel *)matchModel {
    _matchModel = matchModel;
    
    ShiSanUser *user = matchModel.info;
    
    self.nameLabel.text = user.nickname;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    self.addressLabel.text = user.area_one;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    dateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    NSDate *ageDate = [dateFormatter dateFromString:user.birthdate];
    
    NSString *age = [NSString fromDateToAge:ageDate];
    self.ageLabel.text = age;
    self.sexView.image = [UIImage imageNamed:[user.sex isEqualToString:@"1"] ? @"icon_selectedwomen" : @"icon_selectedman"];
    
    if (matchModel.is_friend == 1) {
        self.isMatchLabel.text = @"已匹配";
        self.isMatchLabel.textColor = ThemeColor1;
    } else if (matchModel.is_friend == 2) {
        self.isMatchLabel.text = @"已发送";
        self.isMatchLabel.textColor = RGB(155, 155, 155);
    } else {
        self.isMatchLabel.text = @"";
        self.isMatchLabel.textColor = RGB(155, 155, 155);
    }
}

@end
