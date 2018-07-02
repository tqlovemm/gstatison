//
//  XDSeekCertView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/8/31.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDSeekCertView.h"

@interface XDSeekCertView ()

/** 分割线 */
@property (nonatomic, strong) UIView *lineView;

/** 是否认证 */
@property (nonatomic, strong) UILabel *certLabel;

@end

@implementation XDSeekCertView

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
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB(230, 230, 230);
    [self addSubview:lineView];
    self.lineView = lineView;
    
    UILabel *certLabel = [[UILabel alloc] init];
    certLabel.textColor = RGB(226, 99, 142);
    certLabel.font = kPingFangRegularFont(16);
    [self addSubview:certLabel];
    self.certLabel = certLabel;
    
    XD_WeakSelf
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(1);
    }];
    
    [self.certLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-10);
    }];
}

- (void)setIsCert:(BOOL)isCert {
    _isCert = isCert;
    
    if (isCert) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@""];
        // 创建图片图片附件
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.image = [UIImage imageNamed:@"seek_ certified"];
        attach.bounds = CGRectMake(0, -4, 20, 20);
        NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
        
        [string appendAttributedString:attachString];
        
        NSAttributedString *desStr = [[NSAttributedString alloc] initWithString:@" 已认证" attributes:@{NSForegroundColorAttributeName:RGB(65, 65, 65)                                                                            }];
        [string appendAttributedString:desStr];
        
        self.certLabel.attributedText = string;
    } else {
        self.certLabel.text = @"未通过认证";
    }
    
}

@end
