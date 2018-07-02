//
//  XDSingleGraphicCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/26.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDSingleGraphicCell.h"
#import "XDMsgCategoryModel.h"

@interface XDSingleGraphicCell ()

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *des;
@property (nonatomic, strong) UIView *contextView;

@end

@implementation XDSingleGraphicCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 创建cell
    static NSString *ID = @"XDSingleGraphicCellID";
    XDSingleGraphicCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if(cell == nil)
    {
        cell = [[XDSingleGraphicCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
    
    self.label = [UILabel new];
    self.label.font = kPingFangRegularFont(18);
    self.label.textColor = RGB(29, 28, 27);
    self.label.numberOfLines = 2;
    [self.contextView addSubview:self.label];
    
    self.des = [UILabel new];
    self.des.font = kPingFangRegularFont(14);
    self.des.textColor = RGB(119, 119, 119);
    self.des.numberOfLines = 2;
    [self.contextView addSubview:self.des];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.contextView);
        make.height.mas_equalTo(196);
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(15);
        make.left.mas_equalTo(self.contextView.mas_left).offset(20);
        make.right.mas_equalTo(self.contextView.mas_right).offset(-20);
    }];
    
    [self.des mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.label.mas_bottom).offset(8);
        make.left.mas_equalTo(self.label.mas_left);
        make.right.mas_equalTo(self.label.mas_right);
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
    
    XDNewMessageGraphicModel *graphicModel = model.graphicModel;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:graphicModel.img_url] placeholderImage:[UIImage imageNamed:@"square_image_placeholder"]];
    self.label.text = graphicModel.title;
    self.des.text = graphicModel.des;
}

@end
