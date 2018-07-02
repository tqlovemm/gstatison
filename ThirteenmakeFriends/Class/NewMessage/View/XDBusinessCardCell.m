//
//  XDBusinessCardCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/30.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDBusinessCardCell.h"
#import "XDMsgCategoryModel.h"

@interface XDBusinessCardCell ()

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UILabel *des;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UIView *contextView;

@end

@implementation XDBusinessCardCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 创建cell
    static NSString *ID = @"XDBusinessCardCellID";
    XDBusinessCardCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if(cell == nil)
    {
        cell = [[XDBusinessCardCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImageView.clipsToBounds = YES;
    [self.contextView addSubview:self.iconImageView];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.font = kPingFangBoldFont(14);
    self.titleLabel.textColor = RGB(226, 99, 142);
    [self.contextView addSubview:self.titleLabel];
    
    self.desLabel = [UILabel new];
    self.desLabel.font = kPingFangRegularFont(14);
    self.desLabel.textColor = RGB(119, 119, 119);
    self.desLabel.numberOfLines = 2;
    [self.contextView addSubview:self.desLabel];
    
    self.des = [UILabel new];
    self.des.font = kPingFangRegularFont(12);
    self.des.textColor = RGB(155, 155, 155);
    [self.contextView addSubview:self.des];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = RGB(230, 230, 230);
    [self.contextView addSubview:self.lineView];
    
    self.arrowView = [[UIImageView alloc] init];
    self.arrowView.image = [UIImage imageNamed:@"common_icon_arrow"];
    [self.contextView addSubview:self.arrowView];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contextView).offset(12);
        make.top.mas_equalTo(self.contextView).offset(6);
        make.size.mas_equalTo(CGSizeMake(65, 65));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView.mas_top);
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(9);
        make.right.mas_equalTo(self.contextView.mas_right).offset(-10);
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.right.mas_equalTo(self.titleLabel.mas_right);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(5);
        make.left.mas_equalTo(self.contextView).offset(6);
        make.right.mas_equalTo(self.contextView).offset(-6);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.des mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(6);
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
    
    XDNewMessageCardModel *cardModel = model.cardModel;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:cardModel.img_url] placeholderImage:[UIImage imageNamed:@"square_image_placeholder"]];
    self.titleLabel.text = cardModel.title;
    self.desLabel.text = cardModel.des;
    self.des.text = @"查看详情";
}

@end
