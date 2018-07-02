//
//  XDSendSaveMeTipCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/8.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDSendSaveMeTipCell.h"

@interface XDSendSaveMeTipCell ()

/** 标题 */
@property (nonatomic, weak) UILabel *nameLabel;

@end

@implementation XDSendSaveMeTipCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    // 昵称
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"提示：违规照片会被删除哦";
    nameLabel.font = kPingFangRegularFont(10);
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = ThemeColor1;
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    XD_WeakSelf
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(self.contentView);
    }];
}

@end
