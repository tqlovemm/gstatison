//
//  XDCustomPopupCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/25.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDCustomPopupCell.h"

@implementation XDCustomPopupCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 取消cell选中背景
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 创建cell内部子控件
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    self.backgroundColor = [UIColor clearColor];
    
    // 头像
    UIImageView *iconView = [[UIImageView alloc]init];
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = kPingFangRegularFont(14);
    titleLabel.textColor = RGB(65, 65, 65);
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *badge = [[UILabel alloc] init];
    badge.translatesAutoresizingMaskIntoConstraints = NO;
    badge.textAlignment = NSTextAlignmentCenter;
    badge.textColor = [UIColor whiteColor];
    badge.backgroundColor = [UIColor redColor];
    badge.font = [UIFont boldSystemFontOfSize:11];;
    badge.hidden = YES;
    badge.layer.cornerRadius = 20 / 2;
    badge.clipsToBounds = YES;
    [self.contentView addSubview:badge];
    self.badge = badge;
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.left.top.mas_equalTo(0);
        make.height.mas_equalTo(self.contentView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(4);
        make.top.mas_equalTo(14);
    }];
    
    [self.badge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(5);
        make.centerY.mas_equalTo(self.titleLabel);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

- (void)setBadgeValue:(NSInteger)badgeValue {
    _badgeValue = badgeValue;
    
    if (badgeValue > 0) {
        self.badge.text = [NSString stringWithFormat:@"%ld",badgeValue];
        if (badgeValue > 99) {
            self.badge.text = @"N+";
        }
        self.badge.hidden = NO;
    } else {
        self.badge.text = nil;
        self.badge.hidden = YES;
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 创建cell
    static NSString *ID = @"XDCustomPopupCellID";
    XDCustomPopupCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if(cell == nil)
    {
        cell = [[XDCustomPopupCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

@end
