//
//  OtherInfoCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/3/4.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "OtherInfoCell.h"
#import "ShiSanUser.h"
#import "NSString+Age.h"

@interface OtherInfoCell ()

//! 用户名
@property (nonatomic, weak) UILabel * nameLabel;

//! 年龄
@property (nonatomic, weak) UILabel * ageLabel;

//! 身高
@property (nonatomic, weak) UILabel * heightLabel;

//! 体重
@property (nonatomic, weak) UILabel * weightLabel;

//! 签名
@property (nonatomic, weak) UILabel * signatureLabel;

@end

@implementation OtherInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    // 昵称
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.font = postNameFont;
    nameLabel.textColor = RGB(135, 135, 135);
    nameLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    // 年龄
    UILabel *ageLabel = [[UILabel alloc]init];
    ageLabel.font = postContentFont;
    ageLabel.textColor = RGB(135, 135, 135);
    ageLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:ageLabel];
    self.ageLabel = ageLabel;
    
    // 身高
    UILabel *heightLabel = [[UILabel alloc]init];
    heightLabel.font = postContentFont;
    heightLabel.textColor = RGB(135, 135, 135);
    heightLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:heightLabel];
    self.heightLabel = heightLabel;
    
    // 体重
    UILabel *weightLabel = [[UILabel alloc]init];
    weightLabel.font = postContentFont;
    weightLabel.textColor = RGB(135, 135, 135);
    weightLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:weightLabel];
    self.weightLabel = weightLabel;
    
    // 签名
    UILabel *signatureLabel = [[UILabel alloc]init];
    signatureLabel.font = postContentFont;
    signatureLabel.numberOfLines = 0;
    signatureLabel.textColor = RGB(135, 135, 135);
    signatureLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:signatureLabel];
    self.signatureLabel = signatureLabel;
}

- (void)setOtherInfoF:(OtherInfoFrame *)otherInfoF {
    _otherInfoF = otherInfoF;
    
    self.nameLabel.frame = otherInfoF.nameLabelF;
    self.nameLabel.text = [NSString stringWithFormat:@"用户名：%@",otherInfoF.user.username];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    dateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    NSDate *ageDate = [dateFormatter dateFromString:otherInfoF.user.birthdate];
    
    NSString *age = [NSString fromDateToAge:ageDate];
    NSString *ageLabel = [NSString stringWithFormat:@"年龄：%@岁",age];
    self.ageLabel.frame = otherInfoF.ageLabelF;
    self.ageLabel.text = ageLabel;
    
    self.heightLabel.frame = otherInfoF.heightLabelF;
    self.heightLabel.text = [NSString stringWithFormat:@"身高：%@ cm",otherInfoF.user.height];
    
    self.weightLabel.frame = otherInfoF.weightLabelF;
    self.weightLabel.text = [NSString stringWithFormat:@"体重：%@ kg",otherInfoF.user.weight];
    
    self.signatureLabel.frame = otherInfoF.signatureLabelF;
    self.signatureLabel.text = [NSString stringWithFormat:@"签名：%@",otherInfoF.user.signature];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
