//
//  XDCashTopUpCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/29.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDCashTopUpCell.h"
#import "XDMsgCategoryModel.h"

@interface XDCashTopUpCell ()

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UILabel *sumLabel;
@property (nonatomic, strong) UILabel *des;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UIView *contextView;

@end

@implementation XDCashTopUpCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 创建cell
    static NSString *ID = @"XDCashTopUpCellID";
    XDCashTopUpCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if(cell == nil)
    {
        cell = [[XDCashTopUpCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self xdd_setupView];
    }
    return self;
}

- (void)xdd_setupView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    self.timeLabel = [UILabel new];
    self.timeLabel.font = kPingFangRegularFont(12);
    self.timeLabel.textColor = RGB(170, 170, 170);
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.timeLabel];
    
    self.contextView = [UIView new];
    self.contextView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.contextView];
    
    self.iconImageView = [UIImageView new];
    [self.contextView addSubview:self.iconImageView];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.font = kPingFangRegularFont(16);
    self.titleLabel.textColor = RGB(29, 28, 27);
    [self.contextView addSubview:self.titleLabel];
    
    self.desLabel = [UILabel new];
    self.desLabel.font = kPingFangRegularFont(16);
    self.desLabel.textColor = RGB(155, 155, 155);
    [self.contextView addSubview:self.desLabel];
    
    self.sumLabel = [UILabel new];
    self.sumLabel.font = kPingFangRegularFont(36);
    self.sumLabel.textColor = RGB(29, 28, 27);
    [self.contextView addSubview:self.sumLabel];
    
    self.des = [UILabel new];
    self.des.font = kPingFangRegularFont(16);
    self.des.textColor = RGB(29, 28, 27);
    [self.contextView addSubview:self.des];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = RGB(230, 230, 230);
    [self.contextView addSubview:self.lineView];
    
    self.arrowView = [[UIImageView alloc] init];
    self.arrowView.image = [UIImage imageNamed:@"common_icon_arrow"];
    [self.contextView addSubview:self.arrowView];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contextView).offset(15);
        make.top.mas_equalTo(self.contextView).offset(10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconImageView.mas_centerY);
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(6);
        make.right.mas_equalTo(self.contextView.mas_right).offset(-10);
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contextView.mas_top).offset(77);
        make.centerX.mas_equalTo(self.contextView);
        make.width.lessThanOrEqualTo(@(300));
    }];
    
    [self.sumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.desLabel.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.contextView);
        make.width.lessThanOrEqualTo(@(300));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.sumLabel.mas_bottom).offset(25);
        make.left.mas_equalTo(self.contextView).offset(12);
        make.right.mas_equalTo(self.contextView).offset(-12);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.des mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(8);
        make.left.mas_equalTo(self.iconImageView.mas_left);
        make.width.lessThanOrEqualTo(@(200));
    }];
    
    [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(10, 10));
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(11);
        make.right.mas_equalTo(self.contextView).offset(-15);
    }];
    
    [self.contextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(12);
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(10);
        make.right.mas_equalTo(self.contentView).offset(-12);
        make.bottom.mas_equalTo(self.des.mas_bottom).offset(10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView).offset(10);
        make.width.lessThanOrEqualTo(@(300));
    }];
}

- (void)setModel:(XDNewMessageModel *)model {
    _model = model;
    
    self.timeLabel.text = [model getMessageTimeWithCreate_at:model.created_at];
    
    XDNewMessageComsumeModel *comsumeModel = model.comsumeModel;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:comsumeModel.img_url] placeholderImage:[UIImage imageNamed:@"square_image_placeholder"]];
    self.titleLabel.text = comsumeModel.title;
    self.desLabel.text = comsumeModel.des;
    self.sumLabel.text = [NSString stringWithFormat:@"￥%@",comsumeModel.sum];
    self.des.text = @"查看详情";
}

@end
