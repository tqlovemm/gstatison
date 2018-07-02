//
//  XDCoinComsumeCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/29.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDCoinComsumeCell.h"
#import "XDMsgCategoryModel.h"

@interface XDCoinComsumeCell ()

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UILabel *sumLabel;
@property (nonatomic, strong) UIView *contextView;

@end

@implementation XDCoinComsumeCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 创建cell
    static NSString *ID = @"XDCoinComsumeCellID";
    XDCoinComsumeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if(cell == nil)
    {
        cell = [[XDCoinComsumeCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
    
    self.sumLabel = [UILabel new];
    self.sumLabel.font = kPingFangRegularFont(24);
    self.sumLabel.textColor = RGB(29, 28, 27);
    [self.contextView addSubview:self.sumLabel];
    
    self.desLabel = [UILabel new];
    self.desLabel.font = kPingFangRegularFont(14);
    self.desLabel.textColor = RGB(155, 155, 155);
    [self.contextView addSubview:self.desLabel];
    
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
    
    [self.sumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.right.mas_equalTo(self.titleLabel.mas_right);
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.sumLabel.mas_bottom).offset(7);
        make.left.mas_equalTo(self.sumLabel);
        make.right.mas_equalTo(self.sumLabel.mas_right);
    }];
    
    [self.contextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(12);
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(10);
        make.right.mas_equalTo(self.contentView).offset(-12);
        make.bottom.mas_equalTo(self.desLabel.mas_bottom).offset(10);
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
    self.sumLabel.text = [NSString stringWithFormat:@"%@",comsumeModel.sum];
}

@end
