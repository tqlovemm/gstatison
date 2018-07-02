//
//  XDTemplateMessageCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/30.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDTemplateMessageCell.h"
#import "XDMsgCategoryModel.h"

@interface XDTemplateMessageCell ()

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *msgTimeLab;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UILabel *kvLabel;
@property (nonatomic, strong) UILabel *remarkLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *des;
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UIView *contextView;

@end

@implementation XDTemplateMessageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 创建cell
    static NSString *ID = @"XDTemplateMessageCellID";
    XDTemplateMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if(cell == nil)
    {
        cell = [[XDTemplateMessageCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
    
    self.titleLabel = [UILabel new];
    self.titleLabel.font = kPingFangRegularFont(20);
    self.titleLabel.textColor = RGB(29, 28, 27);
    [self.contextView addSubview:self.titleLabel];
    
    self.msgTimeLab = [UILabel new];
    self.msgTimeLab.font = kPingFangRegularFont(12);
    self.msgTimeLab.textColor = RGB(170, 170, 170);
    [self.contextView addSubview:self.msgTimeLab];
    
    self.desLabel = [UILabel new];
    self.desLabel.font = kPingFangRegularFont(16);
    self.desLabel.textColor = RGB(119, 119, 119);
    [self.contextView addSubview:self.desLabel];
    
    self.kvLabel = [UILabel new];
    self.kvLabel.font = kPingFangRegularFont(14);
    self.kvLabel.textColor = RGB(29, 28, 27);
    self.kvLabel.numberOfLines = 0;
    [self.contextView addSubview:self.kvLabel];
    
    self.remarkLabel = [UILabel new];
    self.remarkLabel.font = kPingFangRegularFont(12);
    self.remarkLabel.textColor = RGB(155, 155, 155);
    self.remarkLabel.numberOfLines = 0;
    [self.contextView addSubview:self.remarkLabel];
    
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
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contextView.mas_top).offset(20);
        make.left.mas_equalTo(self.contextView.mas_left).offset(20);
        make.right.mas_equalTo(self.contextView.mas_right).offset(-20);
    }];
    
    [self.msgTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom);
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.right.mas_equalTo(self.titleLabel.mas_right);
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.msgTimeLab.mas_bottom).offset(10);
        make.left.mas_equalTo(self.msgTimeLab.mas_left);
        make.right.mas_equalTo(self.msgTimeLab.mas_right);
    }];
    
    [self.kvLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.desLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.desLabel.mas_left);
        make.right.mas_equalTo(self.desLabel.mas_right);
    }];
    
    [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.kvLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.kvLabel.mas_left);
        make.right.mas_equalTo(self.kvLabel.mas_right);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.remarkLabel.mas_bottom).offset(25);
        make.left.mas_equalTo(self.contextView).offset(12);
        make.right.mas_equalTo(self.contextView).offset(-12);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.des mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(8);
        make.left.mas_equalTo(self.remarkLabel.mas_left);
        make.width.lessThanOrEqualTo(@(300));
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
    
    XDNewMessageRemindModel *remindModel = model.remindModel;
    
    self.titleLabel.text = remindModel.title;
    self.msgTimeLab.text = [model getMessageTimeWithCreate_at:model.created_at];
    self.desLabel.text = remindModel.first;
    NSString *str = @"";
    for (XDNewMessageContentModel *contentModel in remindModel.kv) {
        str = [str stringByAppendingString:contentModel.key];
        str = [str stringByAppendingString:@"："];
        str = [str stringByAppendingString:contentModel.value];
        str = [str stringByAppendingString:@"\n"];
    }
    self.kvLabel.text = str;
    self.remarkLabel.text = remindModel.remark;
    self.des.text = @"查看详情";
}

@end
