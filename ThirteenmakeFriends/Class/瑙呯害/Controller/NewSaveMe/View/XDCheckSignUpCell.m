//
//  XDCheckSignUpCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/9.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDCheckSignUpCell.h"
//#import "XDOtherViewController.h"
#import "XDSaveMeModel.h"

@interface XDCheckSignUpCell ()

/** 头像 */
@property (nonatomic, weak) UIImageView *iconView;
/** 昵称 */
@property (nonatomic, weak) UILabel *nickenameLabel;
/** 发布时间 */
@property (nonatomic, weak) UILabel *startTimeLabel;
/** lineView */
@property (nonatomic, weak) UIView *lineView;
/** vlineView */
@property (nonatomic, weak) UIView *vlineView;
/** 会话 */
@property (nonatomic, weak) UIButton *sessionBtn;

@end

@implementation XDCheckSignUpCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupSubviews];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)setupSubviews
{
    self.contentView.backgroundColor = [UIColor clearColor];
    
    UIImageView *iconView = [UIImageView new];
    iconView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headIconBtnClicked:)];
    [iconView addGestureRecognizer:tap];
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    
    UILabel *nickenameLabel = [[UILabel alloc] init];
    nickenameLabel.textColor = RGB(65, 65, 65);
    nickenameLabel.font = kPingFangRegularFont(14);
    [self.contentView addSubview:nickenameLabel];
    self.nickenameLabel = nickenameLabel;
    
    UILabel *startTimeLabel = [[UILabel alloc] init];
    startTimeLabel.textColor = RGB(119, 119, 119);
    startTimeLabel.font = kPingFangRegularFont(11);
    [self.contentView addSubview:startTimeLabel];
    self.startTimeLabel = startTimeLabel;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB(230, 230, 230);
    [self.contentView addSubview:lineView];
    self.lineView = lineView;
    
    UIView *vlineView = [[UIView alloc] init];
    vlineView.backgroundColor = RGB(155, 155, 155);
    [self.contentView addSubview:vlineView];
    self.vlineView = vlineView;
    
    UIButton *sessionBtn = [[UIButton alloc] init];
    [sessionBtn setTitle:@"加好友" forState:UIControlStateNormal];
    sessionBtn.titleLabel.font = kPingFangRegularFont(14);
    [sessionBtn setTitleColor:ThemeColor1 forState:UIControlStateNormal];
    [sessionBtn setTitleColor:DefaultColor_BG_gray forState:UIControlStateHighlighted];
    [sessionBtn addTarget:self action:@selector(sessionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:sessionBtn];
    self.sessionBtn = sessionBtn;
    
    self.iconView.layer.cornerRadius = 25;
    self.iconView.layer.masksToBounds = YES;
    XD_WeakSelf
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(22);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [self.nickenameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.iconView.mas_top).offset(5);
        make.left.mas_equalTo(self.iconView.mas_right).offset(10);
        make.width.lessThanOrEqualTo(@(200));
    }];
    
    [self.startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.nickenameLabel.mas_bottom).offset(2);
        make.left.mas_equalTo(self.nickenameLabel);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.sessionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.size.mas_equalTo(CGSizeMake(50, 44));
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.vlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.right.mas_equalTo(self.sessionBtn.mas_left).offset(-5);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(0.5);
        make.centerY.mas_equalTo(self.sessionBtn.mas_centerY);
    }];
}

/**
 *  头像点击
 */
- (void)headIconBtnClicked:(UITapGestureRecognizer *)recognizer {
    
    UITabBarController *tabBar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tabBar.selectedViewController;
    
//    XDOtherViewController *personVC = [[XDOtherViewController alloc] init];
//    personVC.user_id = [NSString stringWithFormat:@"%ld",self.model.user_id];
//    [nav pushViewController:personVC animated:YES];
}

- (void)setModel:(XDSignUpModel *)model {
    _model = model;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    self.nickenameLabel.text = model.nickname;
    self.startTimeLabel.text = [NSString stringWithFormat:@"%@",[model stringDatewithInterval:model.created_at]];
    [self.sessionBtn setTitle:model.is_friend ? @"联系ta" : @"加好友" forState:UIControlStateNormal];
}

- (void)sessionBtnClicked:(UIButton *)btn {
    if (self.sessionBtnClicked) {
        self.sessionBtnClicked(self.model);
    }
}

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"XDCheckSignUpCellID";
    XDCheckSignUpCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[XDCheckSignUpCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}
@end
