//
//  XDUseCouponsCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/19.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDUseCouponsCell.h"

@interface XDUseCouponsCell ()

@property (weak, nonatomic) UIImageView *uperLine;

@property (weak, nonatomic) UIImageView *underLine;

@property (weak, nonatomic) UIImageView *arrowView;

@property (weak, nonatomic) UILabel *desLabel;

@property (weak, nonatomic) UILabel *discountPriceLabel;

@end

@implementation XDUseCouponsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setup {
    
    UIImageView *underLine = [[UIImageView alloc]init];
    underLine.backgroundColor = RGB(230, 230, 230);
    [self.contentView addSubview:underLine];
    self.underLine = underLine;
    
    UIImageView *uperLine = [[UIImageView alloc]init];
    uperLine.backgroundColor = RGB(230, 230, 230);
    [self.contentView addSubview:uperLine];
    self.uperLine = uperLine;
    
    UIImageView *arrowView = [[UIImageView alloc]init];
    arrowView.image = [UIImage imageNamed:@"common_icon_arrow"];
    [self.contentView addSubview:arrowView];
    self.arrowView = arrowView;
    
    UILabel *desLabel = [[UILabel alloc]init];
    desLabel.text = @"使用折扣券";
    desLabel.textColor = RGB(68, 63, 77);
    desLabel.font = kPingFangRegularFont(14);
    [self.contentView addSubview:desLabel];
    self.desLabel = desLabel;
    
    UILabel *discountPriceLabel = [[UILabel alloc]init];
    discountPriceLabel.textColor = RGB(170, 170, 170);
    discountPriceLabel.font = kPingFangRegularFont(14);
    discountPriceLabel.text = @"有0张可用";
    [self.contentView addSubview:discountPriceLabel];
    self.discountPriceLabel = discountPriceLabel;
    
    WEAKSELF
    [underLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(weakSelf);
        make.height.mas_equalTo(0.5);
    }];
    
    [uperLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(weakSelf);
        make.height.mas_equalTo(0.5);
    }];
    
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.5);
        make.centerY.mas_equalTo(weakSelf);
    }];
    
    [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-21);
        make.centerY.mas_equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [discountPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(arrowView.mas_left).offset(-10);
        make.centerY.mas_equalTo(weakSelf);
    }];
}

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"XDUseCouponsCellID";
    XDUseCouponsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[XDUseCouponsCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

@end
