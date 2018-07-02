//
//  XDCardPackageCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/18.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDCardPackageCell.h"
#import "XDVoucherModel.h"

#define kImgTopMargin 5

@interface XDCardPackageCell ()

/** 背景图片 */
@property (nonatomic, weak) UIImageView *backgroudView;
/** 金额 */
@property (nonatomic, weak) UILabel *priceLabel;
/** 描述 */
@property (nonatomic, weak) UILabel *desLabel;
/** 过期时间 */
@property (nonatomic, weak) UILabel *overdueTimeLabel;
/** 卡券类型 （现金券，折扣券） */
@property (nonatomic, weak) UILabel *voucherTypeLabel;

/** 是否使用按钮 */
@property (nonatomic, weak) UIButton *isUserdBtn;

@end

@implementation XDCardPackageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setup {
//    self.backgroundColor = RGB(arc4random() % 255, arc4random() % 255, arc4random() % 255);
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView *backgroudView = [[UIImageView alloc] init];
    [self.contentView addSubview:backgroudView];
    self.backgroudView = backgroudView;
    
    UILabel *priceLabel = [[UILabel alloc]init];
    priceLabel.font = kPingFangRegularFont(30);
    priceLabel.textColor = ThemeColor1;
    priceLabel.textAlignment = NSTextAlignmentCenter;
    priceLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:priceLabel];
    self.priceLabel = priceLabel;
    
    UILabel *desLabel = [[UILabel alloc]init];
    desLabel.font = kPingFangRegularFont(14);
    desLabel.textColor = RGB(65, 65, 65);
    desLabel.textAlignment = NSTextAlignmentCenter;
    desLabel.backgroundColor = [UIColor clearColor];
    desLabel.numberOfLines = 0;
    [self.contentView addSubview:desLabel];
    self.desLabel = desLabel;
    
    UILabel *overdueTimeLabel = [[UILabel alloc]init];
    overdueTimeLabel.font = kPingFangRegularFont(10);
    overdueTimeLabel.textColor = RGB(170, 170, 170);
    overdueTimeLabel.textAlignment = NSTextAlignmentCenter;
    overdueTimeLabel.backgroundColor = [UIColor clearColor];
    overdueTimeLabel.numberOfLines = 0;
    [self.contentView addSubview:overdueTimeLabel];
    self.overdueTimeLabel = overdueTimeLabel;
    
    UILabel *voucherTypeLabel = [[UILabel alloc]init];
    voucherTypeLabel.font = kPingFangRegularFont(14);
    voucherTypeLabel.textColor = ThemeColor1;
    voucherTypeLabel.textAlignment = NSTextAlignmentCenter;
    voucherTypeLabel.backgroundColor = [UIColor clearColor];
    voucherTypeLabel.numberOfLines = 0;
    [self.contentView addSubview:voucherTypeLabel];
    self.voucherTypeLabel = voucherTypeLabel;
    
    UIButton *isUserdBtn = [[UIButton alloc] init];
    isUserdBtn.titleLabel.font = kPingFangRegularFont(12);
    [isUserdBtn setTitleColor:ThemeColor1 forState:UIControlStateNormal];
    [isUserdBtn setTitleColor:RGB(170, 170, 170) forState:UIControlStateDisabled];
    [isUserdBtn setTitle:@"立即使用" forState:UIControlStateNormal];
    [isUserdBtn setTitle:@"已使用" forState:UIControlStateDisabled];
    [isUserdBtn setBackgroundColor:[UIColor whiteColor]];
    isUserdBtn.layer.cornerRadius = 10;
    isUserdBtn.layer.borderWidth = 0.5;
    isUserdBtn.layer.borderColor = RGBA(170, 170, 170, 0.5).CGColor;
    [self.contentView addSubview:isUserdBtn];
    isUserdBtn.layer.masksToBounds = YES;
    self.isUserdBtn = isUserdBtn;
    
    WEAKSELF
    [backgroudView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(8);
        make.trailing.equalTo(weakSelf).offset(-8);
        make.top.equalTo(weakSelf).offset(kImgTopMargin);
        make.size.mas_equalTo(CGSizeMake(weakSelf.width - 16, 104));
    }];
    
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).with.offset(10 + kImgTopMargin);
        make.left.equalTo(weakSelf).with.offset(20);
    }];
    
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceLabel.mas_bottom).with.offset(0);
        make.left.equalTo(priceLabel).offset(5);
    }];
    
    [overdueTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(desLabel.mas_bottom).with.offset(2);
        make.left.equalTo(desLabel);
    }];
    
    [voucherTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).with.offset(21 + kImgTopMargin);
        make.right.equalTo(weakSelf).with.offset(-8);
        make.width.mas_equalTo(self.contentView.width / 4.0);
    }];
    
    [isUserdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf).with.offset(-12 - 5);
        make.centerX.mas_equalTo(voucherTypeLabel);
        make.width.mas_equalTo(self.contentView.width / 4.0 - 15);
        make.height.mas_equalTo(21);
    }];
}

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"XDCardPackageCellID";
    XDCardPackageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[XDCardPackageCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

- (void)setVoucherModel:(XDVoucherModel *)voucherModel {
    _voucherModel = voucherModel;
    
    if (voucherModel.voucherType == 1) {
        self.backgroudView.image = [UIImage imageNamed:@"discount_coupons"];
        self.desLabel.textColor = RGB(240, 239, 245);
    } else {
        self.backgroudView.image = [UIImage imageNamed:@"cash_coupon"];
        self.desLabel.textColor = RGB(65, 65, 65);
    }
    
    if (voucherModel.is_use) {
        self.priceLabel.textColor = RGB(170, 170, 170);
        self.voucherTypeLabel.textColor = RGB(170, 170, 170);
        self.isUserdBtn.enabled = NO;
    } else {
        self.priceLabel.textColor = ThemeColor1;
        self.voucherTypeLabel.textColor = ThemeColor1;
        self.isUserdBtn.enabled = YES;
    }
    
    self.priceLabel.text = [NSString stringWithFormat:@"￥%ld",voucherModel.price];
    self.desLabel.text = voucherModel.des;
    self.overdueTimeLabel.text = [NSString stringWithFormat:@"%ld",voucherModel.overdueTime];
    self.voucherTypeLabel.text = @"现金券";
}

@end
