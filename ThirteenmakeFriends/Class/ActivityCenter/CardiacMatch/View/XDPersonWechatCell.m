//
//  XDPersonWechatCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/12/20.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDPersonWechatCell.h"

@interface XDPersonWechatCell ()

@property (nonatomic, strong) UILabel *weichatLabel;

@end

@implementation XDPersonWechatCell

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
    [self.contentView addSubview:weichatLabel];
    self.weichatLabel = weichatLabel;
    
    XD_WeakSelf
    [self.weichatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.contentView).offset(30);
        make.left.mas_equalTo(self.contentView).offset(10);
        make.bottom.mas_equalTo(self.contentView);
    }];
}

- (void)setWeichat:(NSString *)weichat {
    _weichat = weichat;
    self.weichatLabel.text = [NSString stringWithFormat:@"她的微信：%@",weichat];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 1、创建Cell
    static NSString *identifier = @"XDPersonWechatCellID";
    XDPersonWechatCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[XDPersonWechatCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    // 3、返回Cell
    return cell;
}

@end
