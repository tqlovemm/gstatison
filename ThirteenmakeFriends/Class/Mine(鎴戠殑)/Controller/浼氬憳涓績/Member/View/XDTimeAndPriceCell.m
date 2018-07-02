//
//  XDTimeAndPriceCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/19.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDTimeAndPriceCell.h"
#import "XDCardModel.h"
#import "XDAccountTool.h"
#import "ProfileUser.h"

@interface XDTimeAndPriceCell ()

@property (weak, nonatomic) UIImageView *timeView;

@property (weak, nonatomic) UIImageView *moneyView;

@property (weak, nonatomic) UIButton *timeBtn1;

@property (weak, nonatomic) UIButton *timeBtn2;

@property (weak, nonatomic) UILabel *priceLabel;

@property (weak, nonatomic) UILabel *coinLabel;

@property (weak, nonatomic) UIButton *selectBtn;

@end

@implementation XDTimeAndPriceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setup {
    
    UIImageView *timeView = [[UIImageView alloc]init];
    timeView.image = [UIImage imageNamed:@"time_thread"];
    [self.contentView addSubview:timeView];
    self.timeView = timeView;
    
    UIImageView *moneyView = [[UIImageView alloc]init];
    moneyView.image = [UIImage imageNamed:@"pay_money"];
    [self.contentView addSubview:moneyView];
    self.moneyView = moneyView;
    
    UIButton *timeBtn1 = [[UIButton alloc]init];
    timeBtn1.titleLabel.font = kPingFangBoldFont(14);
    [timeBtn1 setTitleColor:RGB(170, 170, 170) forState:UIControlStateNormal];
    [timeBtn1 setTitleColor:ThemeColor1 forState:UIControlStateSelected];
    [timeBtn1.layer setBorderColor:RGB(170, 170, 170).CGColor];
    [timeBtn1.layer setBorderWidth:1];
    [self.contentView addSubview:timeBtn1];
    self.timeBtn1 = timeBtn1;
    timeBtn1.layer.cornerRadius = 14;
    timeBtn1.layer.masksToBounds = YES;
    
    UIButton *timeBtn2 = [[UIButton alloc]init];
    timeBtn2.titleLabel.font = kPingFangBoldFont(14);
    [timeBtn2 setTitleColor:RGB(170, 170, 170) forState:UIControlStateNormal];
    [timeBtn2 setTitleColor:ThemeColor1 forState:UIControlStateSelected];
    [timeBtn2.layer setBorderColor:RGB(170, 170, 170).CGColor];
    [timeBtn2.layer setBorderWidth:1];
    [self.contentView addSubview:timeBtn2];
    self.timeBtn2 = timeBtn2;
    timeBtn2.layer.cornerRadius = 14;
    timeBtn2.layer.masksToBounds = YES;
    
    [timeBtn1 addTarget:self action:@selector(bottomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [timeBtn2 addTarget:self action:@selector(bottomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *priceLabel = [[UILabel alloc]init];
    priceLabel.textColor = RGB(68, 63, 77);
    priceLabel.font = kPingFangRegularFont(12);
    [self.contentView addSubview:priceLabel];
    self.priceLabel = priceLabel;
    
    UILabel *coinLabel = [[UILabel alloc]init];
    coinLabel.textColor = RGB(170, 170, 170);
    coinLabel.font = kPingFangRegularFont(12);
    [self.contentView addSubview:coinLabel];
    self.coinLabel = coinLabel;
    
    [timeBtn1 setTitle:@"一年" forState:UIControlStateNormal];
    [timeBtn2 setTitle:@"半年" forState:UIControlStateNormal];
//    priceLabel.text = [NSString stringWithFormat:@"2280元"];
//    coinLabel.text = [NSString stringWithFormat:@"赠送1040心动币"];
    
//    WEAKSELF
    [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(26);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    [moneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(timeView);
        make.top.mas_equalTo(timeView.mas_bottom).offset(35);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    [timeBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(timeView.mas_right).offset(16);
        make.centerY.mas_equalTo(timeView);
        make.size.mas_equalTo(CGSizeMake(92, 27));
    }];
    
    [timeBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(timeBtn1.mas_right).offset(10);
        make.centerY.mas_equalTo(timeBtn1);
        make.size.mas_equalTo(CGSizeMake(92, 27));
    }];
    
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(moneyView.mas_right).offset(15);
        make.centerY.mas_equalTo(moneyView);
    }];
    
    [coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(priceLabel.mas_right).offset(8);
        make.centerY.mas_equalTo(priceLabel);
    }];
}

- (void)setCardModel:(XDCardModel *)cardModel {
    _cardModel = cardModel;
    
    if (cardModel.groupid == 1) {
        self.timeBtn1.hidden = NO;
        self.timeBtn2.hidden = YES;
        
        [self.timeBtn1 setTitle:@"包月" forState:UIControlStateNormal];
        self.priceLabel.text = [NSString stringWithFormat:@"%ld元",cardModel.allPrice];
        self.coinLabel.text = [NSString stringWithFormat:@"赠送%ld%@",cardModel.giveaway,coin_name];
    } else if (cardModel.groupid == 2) {
        self.timeBtn1.hidden = NO;
        self.timeBtn2.hidden = YES;
        
        [self.timeBtn1 setTitle:@"终身" forState:UIControlStateNormal];
        self.priceLabel.text = [NSString stringWithFormat:@"%ld元",cardModel.allPrice];
        self.coinLabel.text = [NSString stringWithFormat:@"赠送%ld%@",cardModel.giveaway,coin_name];
    } else {
        ProfileUser *user = [XDAccountTool account];
        if ([user.groupid integerValue] == self.cardModel.groupid) { // 续费当前等级会员只能全年
            self.timeBtn1.hidden = NO;
            self.timeBtn2.hidden = YES;
        } else {
            self.timeBtn1.hidden = NO;
            self.timeBtn2.hidden = NO;
        }
        
        [self.timeBtn1 setTitle:@"一年" forState:UIControlStateNormal];
        [self.timeBtn2 setTitle:@"半年" forState:UIControlStateNormal];
        self.priceLabel.text = [NSString stringWithFormat:@"%ld元",cardModel.allPrice];
        self.coinLabel.text = [NSString stringWithFormat:@"赠送%ld%@",cardModel.giveaway,coin_name];
    }
    [self bottomBtnClicked:self.timeBtn1];
}

- (void)bottomBtnClicked:(UIButton *)btn {
    // 1.控制按钮状态
    if (btn != self.selectBtn) {
        // 设置边框颜色
        [self.selectBtn.layer setBorderColor:RGB(170, 170, 170).CGColor];
        [btn.layer setBorderColor:ThemeColor1.CGColor];
        
        // 控制单选
        self.selectBtn.selected = NO;
        btn.selected = YES;
        self.selectBtn = btn;
        
        if ([btn isEqual:self.timeBtn1]) {
            self.priceLabel.text = [NSString stringWithFormat:@"%ld元",self.cardModel.allPrice];
            self.coinLabel.text = [NSString stringWithFormat:@"赠送%ld%@",self.cardModel.giveaway,coin_name];
            if (self.timeButtonClicked) {
                self.timeButtonClicked(0);
            }
        } else {
            self.priceLabel.text = [NSString stringWithFormat:@"%ld元",self.cardModel.halfPrice];
            self.coinLabel.text = [NSString stringWithFormat:@"赠送%ld%@",self.cardModel.semiAnnualGiveaway,coin_name];
            if (self.timeButtonClicked) {
                self.timeButtonClicked(1);
            }
        }
    }
}

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"XDTimeAndPriceCellID";
    XDTimeAndPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[XDTimeAndPriceCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

@end
