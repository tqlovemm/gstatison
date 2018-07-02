//
//  XDPersonForbiddenCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/12/20.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDPersonForbiddenCell.h"

@interface XDPersonForbiddenCell ()

@property (nonatomic, strong) UILabel *weichatLabel;
@property (nonatomic, strong) UIButton *upgradeBtn;

@end

@implementation XDPersonForbiddenCell

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
    UILabel *weichatLabel = [[UILabel alloc] init];
    weichatLabel.font = kPingFangRegularFont(16);
    weichatLabel.textColor = RGB(65, 65, 65);
    weichatLabel.text = @"可查看他/她的微信";
    weichatLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:weichatLabel];
    self.weichatLabel = weichatLabel;
    
    UIButton *upgradeBtn = [[UIButton alloc] init];
    [upgradeBtn addTarget:self action:@selector(upgradeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [upgradeBtn setTitleColor:ThemeColor1 forState:UIControlStateNormal];
    upgradeBtn.layer.borderColor = ThemeColor1.CGColor;
    upgradeBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    upgradeBtn.layer.cornerRadius = 13;
    upgradeBtn.layer.borderWidth = 1;
    if ([User_Sex integerValue] == 1) {
        [upgradeBtn setTitle:@"进行认证" forState:UIControlStateNormal];
    } else {
        [upgradeBtn setTitle:@"升级会员" forState:UIControlStateNormal];
    }
    [self.contentView addSubview:upgradeBtn];
    self.upgradeBtn = upgradeBtn;
    
    XD_WeakSelf
    [self.upgradeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.weichatLabel.mas_bottom).offset(20);
        make.left.mas_equalTo(self.contentView).offset(10);
        make.size.mas_equalTo(CGSizeMake(92, 27));
        make.bottom.mas_equalTo(self.contentView).offset(-10);
    }];
    
    [self.weichatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.centerY.mas_equalTo(self.upgradeBtn.mas_centerY);
        make.left.mas_equalTo(self.upgradeBtn.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(150, 27));
    }];
}

- (void)upgradeBtnClicked:(UIButton *)btn {
    if (self.upgradeButtonClicked) {
        self.upgradeButtonClicked([User_Sex integerValue]);
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 1、创建Cell
    static NSString *identifier = @"XDPersonForbiddenCellID";
    XDPersonForbiddenCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[XDPersonForbiddenCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    // 3、返回Cell
    return cell;
}

@end
