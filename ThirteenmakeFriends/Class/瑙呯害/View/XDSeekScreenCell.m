//
//  XDSeekScreenCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/9/5.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDSeekScreenCell.h"

@interface XDSeekScreenCell ()

@end

@implementation XDSeekScreenCell

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
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.textColor = RGB(170, 170, 170);
    tipLabel.font = kPingFangBoldFont(12);
    [self.contentView addSubview:tipLabel];
    self.tipLabel = tipLabel;
    
    UILabel *desLabel = [[UILabel alloc] init];
    desLabel.textColor = RGB(65, 65, 65);
    desLabel.font = kPingFangRegularFont(14);
    [self.contentView addSubview:desLabel];
    self.desLabel = desLabel;
    
    tipLabel.text = @"地区";
    desLabel.text = @"不限";
    
    XD_WeakSelf
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(19);
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(19);
    }];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 1、创建Cell
    static NSString *identifier = @"XDSeekScreenCellID";
    XDSeekScreenCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[XDSeekScreenCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    // 3、返回Cell
    return cell;
}

@end
