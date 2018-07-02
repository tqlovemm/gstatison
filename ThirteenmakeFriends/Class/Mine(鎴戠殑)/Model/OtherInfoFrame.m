//
//  OtherInfoFrame.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/3/4.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "OtherInfoFrame.h"
#import "NSString+Age.h"

@implementation OtherInfoFrame

- (void)setUser:(ShiSanUser *)user {
    _user = user;
    
    // 用户名
    CGFloat nameLabelX = postCellBorder * 1.5;
    CGFloat nameLabelY = postCellBorder;
    NSString *username = [NSString stringWithFormat:@"用户名：%@",user.username];
    CGSize nameLabelSize = [username sizeWithFont:postNameFont];
    _nameLabelF = (CGRect){{nameLabelX,nameLabelY},nameLabelSize};
    
    // 年龄
    CGFloat ageLabelX = nameLabelX;
    CGFloat ageLabelY = CGRectGetMaxY(_nameLabelF) + postCellBorder;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    dateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    NSDate *ageDate = [dateFormatter dateFromString:user.birthdate];
    
    NSString *age = [NSString fromDateToAge:ageDate];
    NSString *ageLab = [NSString stringWithFormat:@"年龄：%@岁",age];
    CGSize ageLabelSize = [ageLab sizeWithFont:postContentFont];
    _ageLabelF = (CGRect) {{ageLabelX,ageLabelY} ,ageLabelSize};
    
    // 身高
    CGFloat heightLabelX = nameLabelX;
    CGFloat heightLabelY = CGRectGetMaxY(_ageLabelF) + postCellBorder;
    NSString *height = [NSString stringWithFormat:@"身高：%@ cm",user.height];
    CGSize heightLabelSize = [height sizeWithFont:postContentFont];
    _heightLabelF = (CGRect){{heightLabelX,heightLabelY},heightLabelSize};
    
    // 体重
    CGFloat weightLabelX = nameLabelX;
    CGFloat weightLabelY = CGRectGetMaxY(_heightLabelF) + postCellBorder;
    NSString *weight = [NSString stringWithFormat:@"体重：%@ kg",user.weight];
    CGSize weightLabelSize = [weight sizeWithFont:postContentFont];
    _weightLabelF = (CGRect){{weightLabelX,weightLabelY},weightLabelSize};
    
    // 签名
    CGFloat signatureLabelX = nameLabelX;
    CGFloat signatureLabelY = CGRectGetMaxY(_weightLabelF) + postCellBorder;
    NSString *signature = [NSString stringWithFormat:@"签名：%@",user.signature];
    CGFloat contentLabelMaxW = SCREEN_WIDTH - 2 * postCellBorder;
    CGSize signatureLabelSize = [signature sizeWithFont:postContentFont maxW:contentLabelMaxW];
    _signatureLabelF = (CGRect){{signatureLabelX,signatureLabelY},signatureLabelSize};
    
    _cellHeight = CGRectGetMaxY(_signatureLabelF) + postCellBorder * 2;
}

@end
