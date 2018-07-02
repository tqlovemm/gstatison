//
//  XDSeekItemBottomView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/11/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDSeekItemBottomView.h"
#import "XDWomanSeekModel.h"

@interface XDSeekItemBottomView ()

/** 主地区 */
@property (nonatomic, strong) UILabel *areeLabel;
/** 年龄 */
@property (nonatomic, strong) UILabel *ageLabel;
/** 标签1 */
@property (nonatomic, strong) UILabel *label1;
/** 标签2 */
@property (nonatomic, strong) UILabel *label2;

@end

@implementation XDSeekItemBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    
    UILabel *areeLabel = [[UILabel alloc] init];
    areeLabel.textColor = RGB(65, 65, 65);
    areeLabel.font = kPingFangBoldFont(15);
    [self addSubview:areeLabel];
    self.areeLabel = areeLabel;
    
    UILabel *ageLabel = [[UILabel alloc] init];
    ageLabel.textColor = RGB(20, 22, 55);
    ageLabel.font = kPingFangBoldFont(12);
    [self addSubview:ageLabel];
    self.ageLabel = ageLabel;
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.textColor = RGB(119, 119, 119);
    label1.font = kPingFangRegularFont(11);
    label1.backgroundColor = RGB(237, 237, 237);
    label1.layer.cornerRadius = 9;
    [self addSubview:label1];
    self.label1 = label1;
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.textColor = RGB(119, 119, 119);
    label2.font = kPingFangRegularFont(11);
    label2.backgroundColor = RGB(237, 237, 237);
    label2.layer.cornerRadius = 9;
    [self addSubview:label2];
    self.label2 = label2;
    
}

- (void)setUser:(XDWomanSeekModel *)user {
    _user = user;
    
    self.areeLabel.text = [NSString stringWithFormat:@"%@男生",user.area_one];
    self.ageLabel.text = [NSString stringWithFormat:@"%ld岁",user.age];
    self.label1.text = [user.mark firstObject] ? [NSString stringWithFormat:@" %@ ",[user.mark firstObject]] : nil;
    self.label2.text = user.mark.count >= 2 ? [NSString stringWithFormat:@" %@ ",[user.mark objectAtIndex:1]] : nil;
    
    XD_WeakSelf
    [self.areeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(12);
    }];
    
    [self.ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.bottom.mas_equalTo(self.areeLabel.mas_bottom);
        make.left.mas_equalTo(self.areeLabel.mas_right).offset(12);
    }];
    
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.areeLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(self.areeLabel);
    }];
    
    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.label1.mas_top);
        make.left.mas_equalTo(self.label1.mas_right).offset(8);
    }];
}

@end
