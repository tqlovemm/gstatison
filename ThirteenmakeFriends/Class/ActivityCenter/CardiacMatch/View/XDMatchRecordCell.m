//
//  XDMatchRecordCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/12/19.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDMatchRecordCell.h"
#import "XDMatchRecordModel.h"

@interface XDMatchRecordCell ()

/** 头像 */
@property (nonatomic, weak) UIImageView *iconView;
/** 昵称 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 性别 */
@property (nonatomic, weak) UIImageView *sexView;
/** 其他信息 */
@property (nonatomic, weak) UILabel *userInfoLabel;
/** 评价 */
@property (nonatomic, weak) UIButton *commentBtn;

@end

@implementation XDMatchRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 取消cell选中背景
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 创建cell内部子控件
        [self setupSubViews];
    }
    return self;
}

/**
 *  创建cell内部子控件
 */
- (void)setupSubViews {
    // 头像
    UIImageView *iconView = [[UIImageView alloc] init];
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    
    // 昵称
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.font = kPingFangBoldFont(14);
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = RGB(65, 65, 65);
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    // 性别
    UIImageView *sexView = [[UIImageView alloc]init];
    [self.contentView addSubview:sexView];
    self.sexView = sexView;
    
    // 其他用户信息
    UILabel *userInfoLabel = [[UILabel alloc]init];
    userInfoLabel.font = kPingFangRegularFont(12);
    userInfoLabel.backgroundColor = [UIColor clearColor];
    userInfoLabel.textColor = RGB(65, 65, 65);
    [self.contentView addSubview:userInfoLabel];
    self.userInfoLabel = userInfoLabel;
    
    // 是否匹配
    UIButton *commentBtn = [[UIButton alloc]init];
    commentBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    commentBtn.titleLabel.textColor = RGB(155, 155, 155);
    commentBtn.backgroundColor = [UIColor clearColor];
    [commentBtn addTarget:self action:@selector(commentBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:commentBtn];
    self.commentBtn = commentBtn;
    
    XD_WeakSelf
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.bottom.mas_equalTo(self.contentView).offset(-10);
    }];
    self.iconView.layer.cornerRadius = 25;
    self.iconView.layer.masksToBounds = YES;
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(17);
        make.left.mas_equalTo(self.iconView.mas_right).mas_offset(10);
    }];
    
    [self.sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.nameLabel.mas_top);
        make.left.mas_equalTo(self.nameLabel.mas_right).mas_offset(5);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [self.userInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.nameLabel.mas_left);
    }];
    
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(-5);
        make.size.mas_equalTo(CGSizeMake(92, 27));
    }];
}

- (void)setRecordModel:(XDMatchRecordModel *)recordModel {
    _recordModel = recordModel;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:recordModel.avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    self.nameLabel.text = recordModel.nickname;
    self.sexView.image = [UIImage imageNamed:recordModel.sex == 1 ? @"icon_selectedwomen" : @"icon_selectedman"];
    self.userInfoLabel.text = [NSString stringWithFormat:@"%ld岁 · %ldcm · %ldkg",recordModel.age,recordModel.height,recordModel.weight];
    
    [self.commentBtn setTitle:recordModel.comment_level forState:UIControlStateNormal];
    self.commentBtn.layer.cornerRadius = 13;
    self.commentBtn.layer.borderWidth = 1;
    if (recordModel.is_comment == 1) {
        [self.commentBtn setTitleColor:RGB(170, 170, 170) forState:UIControlStateNormal];
        self.commentBtn.layer.borderColor = [UIColor clearColor].CGColor;
    } else {
        [self.commentBtn setTitleColor:ThemeColor1 forState:UIControlStateNormal];
        self.commentBtn.layer.borderColor = ThemeColor1.CGColor;
    }
}

- (void)commentBtnClicked:(UIButton *)btn {
    if (!self.recordModel.is_comment) {
        if (self.commentButtonClickedBlock) {
            self.commentButtonClickedBlock(btn);
        }
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 1、创建Cell
    static NSString *identifier = @"XDMatchRecordCellID";
    XDMatchRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[XDMatchRecordCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    // 3、返回Cell
    return cell;
}

@end
