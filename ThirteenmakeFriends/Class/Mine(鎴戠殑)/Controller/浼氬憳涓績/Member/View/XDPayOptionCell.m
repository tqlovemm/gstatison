//
//  XDPayOptionCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/19.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDPayOptionCell.h"
#import "XDPay.h"

@interface XDPayOptionCell ()

@property (nonatomic ,strong) UIImageView *payIcon;

@property (nonatomic ,strong) UILabel *payTitle;

@property (nonatomic ,strong) UILabel *payDes;

@property (nonatomic ,strong) UIButton *checkBox;

@end

@implementation XDPayOptionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setup {
    
    _payIcon = [[UIImageView alloc]init];
    _payIcon.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_payIcon];
    
    _payTitle = [[UILabel alloc]init];
    _payTitle.textColor = RGB(68, 63, 77);
    _payTitle.font = kPingFangRegularFont(12);
    [self.contentView addSubview:_payTitle];
    
    _payDes = [[UILabel alloc]init];
    _payDes.textColor = RGB(170, 170, 170);
    _payDes.font = kPingFangRegularFont(12);
    [self.contentView addSubview:_payDes];
    
    _checkBox = [[UIButton alloc] init];
    [_checkBox setImage:[UIImage imageNamed:@"f_adressUnSel_18x18"] forState:UIControlStateNormal];
    [_checkBox setImage:[UIImage imageNamed:@"f_adressSel_17x17"] forState:UIControlStateSelected];
    _checkBox.userInteractionEnabled = false;
    [self.contentView addSubview:_checkBox];
    
    WEAKSELF
    [_payIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(18);
        make.left.mas_equalTo(12);
        make.size.mas_equalTo(CGSizeMake(31, 31));
    }];
    
    [_payTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.payIcon);
        make.left.mas_equalTo(weakSelf.payIcon.mas_right).offset(12);
    }];
    
    [_payDes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.payTitle.mas_bottom).offset(2);
        make.left.mas_equalTo(weakSelf.payTitle);
    }];
    
    [_checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-18);
        make.centerY.mas_equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(17, 17));
    }];
}

- (void)setPayItem:(XDPay *)payItem {
    _payItem = payItem;
    
    self.payTitle.text = payItem.title;
    self.payDes.text = payItem.des;
    self.payIcon.image = payItem.icon;
    self.checkBox.selected = payItem.isChecked;
}

//- (void)setSelected:(BOOL)selected {
//    
//    self.checkBox.selected = selected;
//}

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"XDPayOptionCellID";
    XDPayOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[XDPayOptionCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

@end
