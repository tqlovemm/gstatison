//
//  XDSendSaveMeInfoCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/6.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDSendSaveMeInfoCell.h"

@interface XDSendSaveMeInfoCell ()

/** lineView */
@property (nonatomic, weak) UIView *lineView;
/** 指示器 */
@property (nonatomic, weak) UIImageView *accessView;

@end

@implementation XDSendSaveMeInfoCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    // 头像
    UIImageView *iconView = [[UIImageView alloc]init];
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    
    // 昵称
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.font = kPingFangRegularFont(16);
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = RGB(65, 65, 65);
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    // 正文
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.font = kPingFangRegularFont(14);
    contentLabel.textColor = RGB(119, 119, 119);
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    // lineView
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = RGB(230, 230, 230);
    [self.contentView addSubview:lineView];
    self.lineView = lineView;
    
    // 指示器
    UIImageView *accessView = [[UIImageView alloc]init];
    accessView.image = [UIImage imageNamed:@"common_icon_arrow"];
    [self.contentView addSubview:accessView];
    self.accessView = accessView;
    
    XD_WeakSelf
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.left.mas_equalTo(self.iconView.mas_right).offset(5);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.accessView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.size.mas_equalTo(CGSizeMake(12, 12));
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.right.mas_equalTo(self.accessView.mas_left).offset(-10);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-1);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
}

@end
