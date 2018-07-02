//
//  MineHeaderView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/6/7.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "MineHeaderView.h"
#import "UIImageView+WebCache.h"
#import "MyModuleView.h"
#import "MyModule.h"

#define attributePrefix @"关注"
#define fansPrefix @"粉丝"
#define sendPostPrefix @"发帖"

#define LineColor RGB(242, 242, 242)

@interface MineHeaderView ()

//! 底部view
@property (weak, nonatomic) UIView *header;

@end

@implementation MineHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self xdd_setupSubViews];
    }
    return self;
}

- (void)xdd_setupSubViews {
    // 头
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 120 + NavigationBar_Height)];
    header.backgroundColor = [UIColor whiteColor];
    self.header = header;
    // 头像
    UIImageView *headIcon = [[UIImageView alloc] init];
    headIcon.contentMode = UIViewContentModeScaleAspectFill;
    [header addSubview:headIcon];
    self.headIcon = headIcon;
    
    self.headIcon.layer.borderWidth = 1;
    self.headIcon.layer.borderColor = [UIColor whiteColor].CGColor;
    
    // 用户名
    UILabel *userName = [[UILabel alloc]init];
    userName.font = kPingFangRegularFont(14);
    userName.backgroundColor = [UIColor clearColor];
    userName.textColor = RGB(154, 154, 154);
    [header addSubview:userName];
    self.userName = userName;
    
    // 昵称
    UILabel *nickName = [[UILabel alloc]init];
    nickName.font = kPingFangBoldFont(20);
    nickName.backgroundColor = [UIColor clearColor];
    nickName.backgroundColor = [UIColor purpleColor];
    nickName.textColor = RGB(29, 28, 27);
    [header addSubview:nickName];
    self.nickName = nickName;
    
    // 性别
    UIImageView *sexView = [[UIImageView alloc]init];
    [header addSubview:sexView];
    self.sexView = sexView;
    
    // 视频认证
    UIImageView *autheView = [[UIImageView alloc]init];
    autheView.userInteractionEnabled = YES;
    [header addSubview:autheView];
    self.autheView = autheView;
    
    // 粉丝
    UILabel *fansCount = [[UILabel alloc]init];
    fansCount.font = kPingFangRegularFont(14);
    fansCount.userInteractionEnabled = YES;
    fansCount.textAlignment = NSTextAlignmentLeft;
    fansCount.backgroundColor = [UIColor clearColor];
    fansCount.textColor = RGB(119, 119, 119);
    [header addSubview:fansCount];
    self.fansCount = fansCount;
    
    // 关注
    UILabel *attributeCount = [[UILabel alloc]init];
    attributeCount.font = kPingFangRegularFont(14);
    attributeCount.userInteractionEnabled = YES;
    attributeCount.textAlignment = NSTextAlignmentLeft;
    attributeCount.backgroundColor = [UIColor clearColor];
    attributeCount.textColor = RGB(119, 119, 119);
    [header addSubview:attributeCount];
    self.attributeCount = attributeCount;
    
    // 发帖
    UILabel *sendPostCount = [[UILabel alloc]init];
    sendPostCount.font = kPingFangRegularFont(14);
    sendPostCount.userInteractionEnabled = YES;
    sendPostCount.textAlignment = NSTextAlignmentLeft;
    sendPostCount.backgroundColor = [UIColor clearColor];
    sendPostCount.textColor = RGB(119, 119, 119);
    [header addSubview:sendPostCount];
    self.sendPostCount = sendPostCount;
    
    [self addSubview:header];
    
    self.headIcon.layer.cornerRadius = 102 / 2.0;
    self.headIcon.layer.masksToBounds = YES;
    
    [self.headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NavigationBar_Height);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(102, 102));
    }];
    
    [self.nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headIcon.mas_top).offset(15);
        make.left.mas_equalTo(self.headIcon.mas_right).offset(12);
//        make.right.mas_equalTo(self.header.mas_right).offset(26);
    }];
    
    [self.sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nickName);
        make.left.mas_equalTo(self.nickName.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    // 认证
    [self.autheView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nickName);
        make.left.mas_equalTo(self.sexView.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(3.78*20, 1*20));
    }];
    
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nickName.mas_bottom).offset(11);
        make.left.mas_equalTo(self.nickName.mas_left);
        make.right.mas_equalTo(self.header.mas_right).offset(-10);
    }];
    // 关注
    [self.attributeCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userName.mas_bottom).offset(11);
        make.left.mas_equalTo(self.nickName.mas_left);
    }];
    // 粉丝
    [self.fansCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.attributeCount.mas_top);
        make.left.mas_equalTo(self.attributeCount.mas_right).offset(25);
    }];
    // 发帖
    [self.sendPostCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.fansCount.mas_top);
        make.left.mas_equalTo(self.fansCount.mas_right).offset(25);
    }];
}

- (void)setUser:(ProfileUser *)user {
    
    if (user == nil) {
        [self.headIcon sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
        if ([User_Name length]) {
            [self.userName setText:[NSString stringWithFormat:@"%@: %@",@"账号",User_Name]];
        }
        [self.nickName setText:user.nickname];
        
        NSString *attributeCountStr = [NSString stringWithFormat:@"%@%@",attributePrefix,@"0"];
        NSMutableAttributedString *attributeCountString = [[NSMutableAttributedString alloc]initWithString:attributeCountStr];
        [attributeCountString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]range:NSMakeRange(attributePrefix.length,attributeCountStr.length-attributePrefix.length)];
        self.attributeCount.attributedText= attributeCountString;

        NSString *fansCountStr = [NSString stringWithFormat:@"%@%@",fansPrefix,@"0"];
        NSMutableAttributedString *fansCountString = [[NSMutableAttributedString alloc]initWithString:fansCountStr];
        [attributeCountString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]range:NSMakeRange(fansPrefix.length,fansCountStr.length-fansPrefix.length)];
        self.fansCount.attributedText= fansCountString;
    
        NSString *sendPostCountStr = [NSString stringWithFormat:@"%@%@",sendPostPrefix,@"0"];
        NSMutableAttributedString *sendPostCountString = [[NSMutableAttributedString alloc]initWithString:sendPostCountStr];
        [sendPostCountString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]range:NSMakeRange(sendPostPrefix.length,sendPostCountStr.length-sendPostPrefix.length)];
        self.sendPostCount.attributedText= sendPostCountString;

    } else {
        [self.headIcon sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
        if ([User_Name length]) {
           [self.userName setText:[NSString stringWithFormat:@"%@: %@",kMine_username_prefix,User_Name]];
        }
        
        [self.nickName setText:user.nickname];
//        [self.attributeCount setText:[NSString stringWithFormat:@"%@%@",attributePrefix,user.following_count]];
//        [self.fansCount setText:[NSString stringWithFormat:@"%@%@",fansPrefix,user.follower_count]];
//        self.sendPostCount.text = [NSString stringWithFormat:@"%@%@",sendPostPrefix,user.thread_count];
        
        //        [self.attributeCount setText:[NSString stringWithFormat:@"%@%@",attributePrefix,@"0"]];
        NSString *attributeCountStr = [NSString stringWithFormat:@"%@%@",attributePrefix,user.following_count];
        NSMutableAttributedString *attributeCountString = [[NSMutableAttributedString alloc]initWithString:attributeCountStr];
        [attributeCountString addAttribute:NSForegroundColorAttributeName value:RGB(29, 28, 27)range:NSMakeRange(attributePrefix.length,attributeCountStr.length-attributePrefix.length)];
        self.attributeCount.attributedText= attributeCountString;
        
        //        [self.fansCount setText:[NSString stringWithFormat:@"%@%@",fansPrefix,@"0"]];
        NSString *fansCountStr = [NSString stringWithFormat:@"%@%@",fansPrefix,user.follower_count];
        NSMutableAttributedString *fansCountString = [[NSMutableAttributedString alloc]initWithString:fansCountStr];
        [fansCountString addAttribute:NSForegroundColorAttributeName value:RGB(29, 28, 27)range:NSMakeRange(fansPrefix.length,fansCountStr.length-fansPrefix.length)];
        self.fansCount.attributedText= fansCountString;

        NSString *sendPostCountStr = [NSString stringWithFormat:@"%@%@",sendPostPrefix,user.thread_count];
        NSMutableAttributedString *sendPostCountString = [[NSMutableAttributedString alloc]initWithString:sendPostCountStr];
        [sendPostCountString addAttribute:NSForegroundColorAttributeName value:RGB(29, 28, 27) range:NSMakeRange(sendPostPrefix.length,sendPostCountStr.length-sendPostPrefix.length)];
        self.sendPostCount.attributedText= sendPostCountString;
        
    }
    
    if ([User_Sex isEqualToString:@"1"]) {
        self.sexView.image = [UIImage imageNamed:@"post_man"];
    } else {
        self.sexView.image = [UIImage imageNamed:@"post_woman"];
    }
    
    self.autheView.image = [UIImage imageNamed:@"shenhezhong"];
    if (user.is_renzheng == 0) {
        self.autheView.image = [UIImage imageNamed:@"weirenzheng"];
    }else  if (user.is_renzheng == 1) {
        self.autheView.image = [UIImage imageNamed:@"yirenzheng"];
    }
    
    MyModule *coin = [[MyModule alloc] init];
    coin.imageName = @"member_wallet";
    coin.moduleName = kMine_coin_name;
    coin.moduleValue = [NSString stringWithFormat:@"%ld",user.jiecao_coin];
    
    MyModule *charm = [[MyModule alloc] init];
    charm.imageName = @"member_meili";
    charm.moduleName = @"魅力值";
    charm.moduleValue = [NSString stringWithFormat:@"%d",[user.glamorous intValue]];
    
    MyModule *vipLevel = [[MyModule alloc] init];
    vipLevel.moduleName = @"会员等级";
    if ([user.groupid isEqualToString:@"1"]) {// 会员等级判断
        vipLevel.moduleValue = @"包月会员";
        vipLevel.imageName = @"member_baoyue";
    } else if ([user.groupid isEqualToString:@"2"]) {
        vipLevel.moduleValue = @"初级会员";
        vipLevel.imageName = @"member_chuji";
    } else if ([user.groupid isEqualToString:@"3"]) {
        vipLevel.moduleValue = @"高端会员";
        vipLevel.imageName = @"member_gaoduan";
    } else if ([user.groupid isEqualToString:@"4"]) {
        vipLevel.moduleValue = @"至尊会员";
        vipLevel.imageName = @"member_zhizun";
    } else if ([user.groupid isEqualToString:@"5"]) {
        vipLevel.moduleValue = @"私人至尊";
        vipLevel.imageName = @"member_siren";
    } else if ([user.groupid isEqualToString:@"0"]) {
        vipLevel.moduleValue = @"非会员";
        vipLevel.imageName = @"member_upgrade";
    } else {
        vipLevel.moduleValue = @"未知等级";
        vipLevel.imageName = @"member_upgrade";
    }
    
    MyModule *seekRecord = [[MyModule alloc] init];
    seekRecord.imageName = @"member_miyue";
    seekRecord.moduleName = kSeek_record_name;
    seekRecord.moduleValue = nil;
    
    self.coinView.module = coin;
    self.charmView.module = charm;
    self.vipLevelView.module = vipLevel;
    self.seekRecordView.module = seekRecord;
}

@end
