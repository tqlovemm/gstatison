//
//  XDCardItemView.m
//  MemberCardDemo
//
//  Created by Xudongdong on 2017/7/10.
//  Copyright © 2017年 Xudongdong. All rights reserved.
//

#import "XDCardItemView.h"
#import "XDCardModel.h"
#import "UIImageView+EMWebCache.h"
#import "XDAccountTool.h"
#import "ProfileUser.h"

#if APP_Puppet  // Puppet
#define kTextColor RGB(226, 99, 142)
#elif APP_myPuppet
#define kTextColor RGB(218, 169, 82)
#else // 正常
#define kTextColor RGB(226, 99, 142)
#endif

@interface XDCardItemView ()

/** 会员等级图标 */
@property (nonatomic, weak) UIImageView *bigMemberView;
/** 会员名 */
@property (nonatomic, weak) UILabel *memberNameLabel;
/** 会员权益数 */
@property (nonatomic, weak) UILabel *rightCountLabel;
/** 会员真实价格 */
@property (nonatomic, weak) UILabel *memberPriceLabel;
/** 会员原来价格 */
@property (nonatomic, weak) UILabel *memberOriginPriceLabel;
/** 赠送心动币描述 */
@property (nonatomic, weak) UILabel *coinsDesLabel;

@end

@implementation XDCardItemView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView *bigMemberView = [[UIImageView alloc] init];
    [self addSubview:bigMemberView];
    self.bigMemberView = bigMemberView;
    
    UILabel *memberNameLabel = [[UILabel alloc] init];
    memberNameLabel.font = kPingFangRegularFont(18);
    memberNameLabel.textColor = RGB(20, 19, 19);
    [self addSubview:memberNameLabel];
    self.memberNameLabel = memberNameLabel;
    
    UILabel *rightCountLabel = [[UILabel alloc] init];
    rightCountLabel.font = kPingFangRegularFont(12);
    rightCountLabel.textColor = kTextColor;
    [self addSubview:rightCountLabel];
    self.rightCountLabel = rightCountLabel;
    
    UILabel *memberPriceLabel = [[UILabel alloc] init];
    memberPriceLabel.font = [UIFont systemFontOfSize:24];
    memberPriceLabel.textColor = RGB(65, 65, 65);
    [self addSubview:memberPriceLabel];
    self.memberPriceLabel = memberPriceLabel;
    
    UILabel *memberOriginPriceLabel = [[UILabel alloc] init];
    memberOriginPriceLabel.font = kPingFangRegularFont(14);
    memberOriginPriceLabel.textColor = RGB(170, 170, 170);
    [self addSubview:memberOriginPriceLabel];
    self.memberOriginPriceLabel = memberOriginPriceLabel;
    
    UILabel *coinsDesLabel = [[UILabel alloc] init];
    coinsDesLabel.font = kPingFangRegularFont(12);
    coinsDesLabel.textColor = RGB(68, 68, 68);
    [self addSubview:coinsDesLabel];
    self.coinsDesLabel = coinsDesLabel;
    
    WEAKSELF
    [bigMemberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.centerX.equalTo(weakSelf);
        make.top.mas_equalTo(18);
    }];
    
    [memberNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bigMemberView.centerX);
        make.top.equalTo(bigMemberView.mas_bottom).with.offset(8);
    }];
    
    [rightCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(memberNameLabel.centerX);
        make.top.equalTo(memberNameLabel.mas_bottom).with.offset(-3);
    }];
    
    [memberPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(rightCountLabel.centerX);
        make.top.equalTo(rightCountLabel.mas_bottom).with.offset(28);
    }];
    
    [memberOriginPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(memberPriceLabel.centerX);
        make.top.equalTo(memberPriceLabel.mas_bottom).with.offset(1);
    }];
    
    [coinsDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(memberPriceLabel.centerX);
        make.top.equalTo(memberOriginPriceLabel.mas_bottom).with.offset(18);
    }];
}

- (void)setCardModel:(XDCardModel *)cardModel {
    _cardModel = cardModel;
    
#if APP_Puppet  // Puppet
    [self.bigMemberView sd_setImageWithURL:[NSURL URLWithString:cardModel.vipIcon] placeholderImage:[UIImage imageNamed:@"square_image_placeholder"]];
#elif APP_myPuppet
    self.bigMemberView.image = [UIImage imageNamed:cardModel.vipIcon];
#else // 正常
    [self.bigMemberView sd_setImageWithURL:[NSURL URLWithString:cardModel.vipIcon] placeholderImage:[UIImage imageNamed:@"square_image_placeholder"]];
#endif
    self.memberNameLabel.text = cardModel.member_name;
    self.rightCountLabel.text = [NSString stringWithFormat:@"%ld项会员权益",cardModel.auth_count];
    
    NSString *unit = @""; // 单位
    
    if (cardModel.groupid == 1) {
        unit = @"/月";
    } else if (cardModel.groupid == 2) {
//        unit = @"/终身";
        unit = self.is_status ? @"/年" : @"/终身";
    } else {
        unit = @"/年";
    }
    
    NSString *actualPrice = @""; // 实际价格
    ProfileUser *user = [XDAccountTool account];
    if (cardModel.groupid == 5) {
        actualPrice = [user.groupid integerValue] >= 4 ? [NSString stringWithFormat:@"%ld ",cardModel.allPrice] : @"????";
    } else {
        actualPrice = [NSString stringWithFormat:@"%ld ",cardModel.allPrice];
    }
    
    NSMutableAttributedString *priceStr = [[NSMutableAttributedString alloc] initWithString:actualPrice];
    NSAttributedString *priceUnit = [[NSAttributedString alloc] initWithString:unit attributes:@{NSForegroundColorAttributeName:RGB(170, 170, 170),
                                                                                                                                NSFontAttributeName:[UIFont boldSystemFontOfSize:8]                                                                             }];
    [priceStr appendAttributedString:priceUnit];
    self.memberPriceLabel.attributedText = priceStr;
    
    NSMutableAttributedString *originPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"原价￥%ld",cardModel.orgPrice]];
    [originPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, originPrice.length)];
    self.memberOriginPriceLabel.attributedText = originPrice;
    
    // 是否隐藏原价
    self.memberOriginPriceLabel.hidden = cardModel.orgPrice == cardModel.allPrice ? YES : NO;
    if (cardModel.orgPrice == cardModel.allPrice || ([user.groupid integerValue] < 4 && cardModel.groupid == 5)) {
        self.memberOriginPriceLabel.hidden = YES;
    } else {
        self.memberOriginPriceLabel.hidden = NO;
    }
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@""];
    // 创建图片图片附件
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"coin_giving"];
    attach.bounds = CGRectMake(0, -4, 24, 17);
    NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
    [string appendAttributedString:attachString];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:@" 赠送"]];
    
    NSAttributedString *givingStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",cardModel.giveaway] attributes:@{NSForegroundColorAttributeName:RGB(226, 99, 143),
                                                    NSFontAttributeName:[UIFont boldSystemFontOfSize:12]                                                                             }];
    [string appendAttributedString:givingStr];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:coin_name]];
    
    self.coinsDesLabel.attributedText = string;
}

@end
