//
//  WomanHeader.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/6/29.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "WomanHeader.h"
#import "UIImageView+WebCache.h"
#import "MyModuleView.h"
#import "MyModule.h"

#define attributePrefix @"关注 "
#define fansPrefix @"粉丝 "
#define sendPostPrefix @"发帖 "

#define LineColor RGB(242, 242, 242)

@interface WomanHeader ()

//! 底部view
@property (weak, nonatomic) UIView *header;

@end

@implementation WomanHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {

#if APP_Puppet  // Puppet
    // 头
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 220 + NavigationBar_Height - 10)];
    header.backgroundColor = RGB(248, 248, 248);
    self.header = header;
    
    UIImageView *headIcon = [[UIImageView alloc] init];
    headIcon.contentMode = UIViewContentModeScaleAspectFill;
    [header addSubview:headIcon];
    self.headIcon = headIcon;
    
    // 用户名
    UILabel *userName = [[UILabel alloc]init];
    userName.font = k14Font;
    userName.textAlignment = NSTextAlignmentCenter;
    userName.backgroundColor = [UIColor clearColor];
    userName.textColor = RGB(65, 65, 65);
    [header addSubview:userName];
    self.userName = userName;
    
    // 昵称
    UILabel *nickName = [[UILabel alloc]init];
    nickName.font = [UIFont boldSystemFontOfSize:14.0f];
    nickName.textAlignment = NSTextAlignmentCenter;
    nickName.backgroundColor = [UIColor clearColor];
    nickName.textColor = RGB(65, 65, 65);
    [header addSubview:nickName];
    self.nickName = nickName;
    
    // 性别
    UIImageView *sexView = [[UIImageView alloc]init];
    [header addSubview:sexView];
    self.sexView = sexView;
    
    // 粉丝
    UILabel *fansCount = [[UILabel alloc]init];
    fansCount.font = k12Font;
    fansCount.userInteractionEnabled = YES;
    fansCount.textAlignment = NSTextAlignmentCenter;
    fansCount.backgroundColor = [UIColor clearColor];
    fansCount.textColor = RGB(65, 65, 65);
    [header addSubview:fansCount];
    self.fansCount = fansCount;
    
    // 关注
    UILabel *attributeCount = [[UILabel alloc]init];
    attributeCount.font = k12Font;
    attributeCount.userInteractionEnabled = YES;
    attributeCount.textAlignment = NSTextAlignmentCenter;
    attributeCount.backgroundColor = [UIColor clearColor];
    attributeCount.textColor = RGB(65, 65, 65);
    [header addSubview:attributeCount];
    self.attributeCount = attributeCount;
    
    // 发帖
    UILabel *sendPostCount = [[UILabel alloc]init];
    sendPostCount.font = k12Font;
    sendPostCount.userInteractionEnabled = YES;
    sendPostCount.textAlignment = NSTextAlignmentCenter;
    sendPostCount.backgroundColor = [UIColor clearColor];
    sendPostCount.textColor = RGB(65, 65, 65);
    [header addSubview:sendPostCount];
    self.sendPostCount = sendPostCount;
    
    [self addSubview:header];
    
    // 四块
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, header.height + 10, header.width, 100)];
    footer.backgroundColor = [UIColor whiteColor];
    [self addSubview:footer];
    
    CGFloat moduleW = footer.width / 4.0;
    CGFloat moduleH = footer.height;
    
    MyModuleView *coinView = [[MyModuleView alloc] init];
    coinView.frame = CGRectMake(0, 0, moduleW, moduleH);
    [footer addSubview:coinView];
    self.coinView = coinView;
    
    MyModuleView *vipLevelView = [[MyModuleView alloc] init];
    vipLevelView.frame = CGRectMake(moduleW, 0, moduleW, moduleH);
    [footer addSubview:vipLevelView];
    self.vipLevelView = vipLevelView;
    
    MyModuleView *seekRecordView = [[MyModuleView alloc] init];
    seekRecordView.frame = CGRectMake(moduleW * 2, 0, moduleW, moduleH);
    [footer addSubview:seekRecordView];
    self.seekRecordView = seekRecordView;
    
    MyModuleView *charmView = [[MyModuleView alloc] init];
    charmView.frame = CGRectMake(moduleW * 3, 0, moduleW, moduleH);
    [footer addSubview:charmView];
    self.charmView = charmView;
#elif APP_myPuppet
    // 头
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 120 + NavigationBar_Height)];
    header.backgroundColor = [UIColor whiteColor];
    self.header = header;
    
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
    userName.textColor = RGB(159, 159, 159);
    [header addSubview:userName];
    self.userName = userName;
    
    // 昵称
    UILabel *nickName = [[UILabel alloc]init];
    nickName.font = kPingFangBoldFont(20);
    nickName.backgroundColor = [UIColor clearColor];
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
    //    self.headIcon.layer.shadowRadius = 3;
    //    self.headIcon.layer.shadowOffset = CGSizeMake(0, 1);
    //    self.headIcon.layer.shadowOpacity = 0.8;
    //    self.headIcon.layer.shadowColor = RGBA(0, 0, 0, 0.17).CGColor;
    
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
    
    [self.autheView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nickName);
        make.left.mas_equalTo(self.sexView.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(3.78*20, 1*20));
    }];
    
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nickName.mas_bottom).offset(5);
        make.left.mas_equalTo(self.nickName.mas_left);
        make.right.mas_equalTo(self.header.mas_right).offset(-10);
    }];
    
    [self.attributeCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userName.mas_bottom).offset(11);
        make.left.mas_equalTo(self.nickName.mas_left);
    }];
    
    [self.fansCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.attributeCount.mas_top);
        make.left.mas_equalTo(self.attributeCount.mas_right).offset(25);
    }];
    
    [self.sendPostCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.fansCount.mas_top);
        make.left.mas_equalTo(self.fansCount.mas_right).offset(25);
    }];
#else // 正常
    
    // 头
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 220 + NavigationBar_Height - 10)];
    header.backgroundColor = RGB(248, 248, 248);
    self.header = header;
    
    UIImageView *headIcon = [[UIImageView alloc] init];
    headIcon.contentMode = UIViewContentModeScaleAspectFill;
    [header addSubview:headIcon];
    self.headIcon = headIcon;
    
    // 用户名
    UILabel *userName = [[UILabel alloc]init];
    userName.font = k14Font;
    userName.textAlignment = NSTextAlignmentCenter;
    userName.backgroundColor = [UIColor clearColor];
    userName.textColor = RGB(65, 65, 65);
    [header addSubview:userName];
    self.userName = userName;
    
    // 昵称
    UILabel *nickName = [[UILabel alloc]init];
    nickName.font = [UIFont boldSystemFontOfSize:14.0f];
    nickName.textAlignment = NSTextAlignmentCenter;
    nickName.backgroundColor = [UIColor clearColor];
    nickName.textColor = RGB(65, 65, 65);
    [header addSubview:nickName];
    self.nickName = nickName;
    
    // 性别
    UIImageView *sexView = [[UIImageView alloc]init];
    [header addSubview:sexView];
    self.sexView = sexView;
    
    // 粉丝
    UILabel *fansCount = [[UILabel alloc]init];
    fansCount.font = k12Font;
    fansCount.userInteractionEnabled = YES;
    fansCount.textAlignment = NSTextAlignmentCenter;
    fansCount.backgroundColor = [UIColor clearColor];
    fansCount.textColor = RGB(65, 65, 65);
    [header addSubview:fansCount];
    self.fansCount = fansCount;
    
    // 关注
    UILabel *attributeCount = [[UILabel alloc]init];
    attributeCount.font = k12Font;
    attributeCount.userInteractionEnabled = YES;
    attributeCount.textAlignment = NSTextAlignmentCenter;
    attributeCount.backgroundColor = [UIColor clearColor];
    attributeCount.textColor = RGB(65, 65, 65);
    [header addSubview:attributeCount];
    self.attributeCount = attributeCount;
    
    // 发帖
    UILabel *sendPostCount = [[UILabel alloc]init];
    sendPostCount.font = k12Font;
    sendPostCount.userInteractionEnabled = YES;
    sendPostCount.textAlignment = NSTextAlignmentCenter;
    sendPostCount.backgroundColor = [UIColor clearColor];
    sendPostCount.textColor = RGB(65, 65, 65);
    [header addSubview:sendPostCount];
    self.sendPostCount = sendPostCount;
    
    [self addSubview:header];
    
    // 四块
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, header.height + 10, header.width, 200)];
    footer.backgroundColor = [UIColor whiteColor];
    [self addSubview:footer];
    
    CGFloat moduleW = footer.width / 2.0 - 0.5;
    CGFloat moduleH = footer.height / 2.0 - 0.5;
    
    MyModuleView *coinView = [[MyModuleView alloc] init];
    coinView.frame = CGRectMake(0, 0, moduleW, moduleH);
    [footer addSubview:coinView];
    self.coinView = coinView;
    
    MyModuleView *charmView = [[MyModuleView alloc] init];
    charmView.frame = CGRectMake(footer.width - moduleW, 0, moduleW, moduleH);
    [footer addSubview:charmView];
    self.charmView = charmView;
    
    UILabel *seperaterHorizontal = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(coinView.frame), footer.width, 1)];
    seperaterHorizontal.backgroundColor = LineColor;
    [footer addSubview:seperaterHorizontal];
    
    UILabel *seperaterVertical = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(coinView.frame), 0, 1, footer.height)];
    seperaterVertical.backgroundColor = LineColor;
    [footer addSubview:seperaterVertical];
    
    MyModuleView *vipLevelView = [[MyModuleView alloc] init];
    vipLevelView.frame = CGRectMake(0, footer.height - moduleH, moduleW, moduleH);
    [footer addSubview:vipLevelView];
    self.vipLevelView = vipLevelView;
    
    MyModuleView *seekRecordView = [[MyModuleView alloc] init];
    seekRecordView.frame = CGRectMake(footer.width - moduleW, footer.height - moduleH, moduleW, moduleH);
    [footer addSubview:seekRecordView];
    self.seekRecordView = seekRecordView;
#endif
}

- (void)setUser:(ProfileUser *)user {
    _user = user;
    
    if (user == nil) {
        [self.headIcon sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
        [self.userName setText:[NSString stringWithFormat:@"%@ ：%@",kMine_username_prefix,User_Name]];
        [self.nickName setText:user.nickname];
//        [self.attributeCount setText:[NSString stringWithFormat:@"%@%@",attributePrefix,@"0"]];
//        [self.fansCount setText:[NSString stringWithFormat:@"%@%@",fansPrefix,@"0"]];
//        self.sendPostCount.text = [NSString stringWithFormat:@"%@%@",sendPostPrefix,@"0"];
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
        [self.userName setText:[NSString stringWithFormat:@"%@ ：%@",kMine_username_prefix,User_Name]];
        [self.nickName setText:user.nickname];
//        [self.attributeCount setText:[NSString stringWithFormat:@"%@%@",attributePrefix,user.following_count]];
//        [self.fansCount setText:[NSString stringWithFormat:@"%@%@",fansPrefix,user.follower_count]];
//        self.sendPostCount.text = [NSString stringWithFormat:@"%@%@",sendPostPrefix,user.thread_count];
        
        NSString *attributeCountStr = [NSString stringWithFormat:@"%@%@",attributePrefix,user.following_count];
        NSMutableAttributedString *attributeCountString = [[NSMutableAttributedString alloc]initWithString:attributeCountStr];
        [attributeCountString addAttribute:NSForegroundColorAttributeName value:RGB(29, 28, 27)range:NSMakeRange(attributePrefix.length,attributeCountStr.length-attributePrefix.length)];
        self.attributeCount.attributedText= attributeCountString;
        
        //        [self.fansCount setText:[NSString stringWithFormat:@"%@%@",fansPrefix,@"0"]];
        NSString *fansCountStr = [NSString stringWithFormat:@"%@%@",fansPrefix,user.follower_count];
        NSMutableAttributedString *fansCountString = [[NSMutableAttributedString alloc]initWithString:fansCountStr];
        [fansCountString addAttribute:NSForegroundColorAttributeName value:RGB(29, 28, 27)range:NSMakeRange(fansPrefix.length,fansCountStr.length-fansPrefix.length)];
        self.fansCount.attributedText= fansCountString;
        
        //        self.sendPostCount.text = [NSString stringWithFormat:@"%@%@",sendPostPrefix,@"0"];
        NSString *sendPostCountStr = [NSString stringWithFormat:@"%@%@",sendPostPrefix,user.thread_count];
        NSMutableAttributedString *sendPostCountString = [[NSMutableAttributedString alloc]initWithString:sendPostCountStr];
        [sendPostCountString addAttribute:NSForegroundColorAttributeName value:RGB(29, 28, 27) range:NSMakeRange(sendPostPrefix.length,sendPostCountStr.length-sendPostPrefix.length)];
        self.sendPostCount.attributedText= sendPostCountString;
    }
    
    if ([User_Sex isEqualToString:@"1"]) {
        self.sexView.image = [UIImage imageNamed:@"icon_selectedwomen"];
    } else {
        self.sexView.image = [UIImage imageNamed:@"icon_selectedman"];
    }
    
     self.autheView.image = [UIImage imageNamed:@"weirenzheng"];
    if (user.is_renzheng == 1) {
        self.autheView.image = [UIImage imageNamed:@"yirenzheng"];
    }else  if (user.is_renzheng == 2) {
        self.autheView.image = [UIImage imageNamed:@"shenhezhong"];
    }

#if APP_Puppet  // Puppet
    self.headIcon.y = postCellBorder + NavigationBar_Height;
    self.headIcon.size = CGSizeMake(100, 100);
    self.headIcon.centerX = SCREEN_WIDTH / 2.0;
    self.headIcon.layer.cornerRadius = self.headIcon.width / 2.0;
    self.headIcon.layer.masksToBounds = YES;
    
    self.userName.y = CGRectGetMaxY(self.headIcon.frame) + postCellBorder;
    self.userName.size = [self.userName.text sizeWithFont:k14Font];
    self.userName.centerX = self.headIcon.centerX;
    
    self.nickName.y = CGRectGetMaxY(self.userName.frame) + postCellBorder;
    self.nickName.size = [self.nickName.text sizeWithFont:[UIFont boldSystemFontOfSize:14.0f]];
    self.nickName.centerX = self.userName.centerX;
    
    self.sexView.x = CGRectGetMaxX(self.nickName.frame) + postCellBorder;
    self.sexView.y = self.nickName.y;
    self.sexView.size = CGSizeMake(16, 16);
    
    self.fansCount.y = CGRectGetMaxY(self.nickName.frame) + postCellBorder;
    self.fansCount.size = [self.fansCount.text sizeWithFont:postNameFont];
    self.fansCount.centerX = self.userName.centerX;
    
    CGFloat margin = 20;
    self.attributeCount.y = self.fansCount.y;
    self.attributeCount.size = [self.attributeCount.text sizeWithFont:postNameFont];
    self.attributeCount.x = self.fansCount.x - self.fansCount.width - margin;
    
    
    self.sendPostCount.y = self.fansCount.y;
    self.sendPostCount.size = [self.sendPostCount.text sizeWithFont:postNameFont];
    self.sendPostCount.x = CGRectGetMaxX(self.fansCount.frame) + margin;
#elif APP_myPuppet
    
#else // 正常
    self.headIcon.y = postCellBorder + NavigationBar_Height;
    self.headIcon.size = CGSizeMake(100, 100);
    self.headIcon.centerX = SCREEN_WIDTH / 2.0;
    self.headIcon.layer.cornerRadius = self.headIcon.width / 2.0;
    self.headIcon.layer.masksToBounds = YES;
    
    self.userName.y = CGRectGetMaxY(self.headIcon.frame) + postCellBorder;
    self.userName.size = [self.userName.text sizeWithFont:k14Font];
    self.userName.centerX = self.headIcon.centerX;
    
    self.nickName.y = CGRectGetMaxY(self.userName.frame) + postCellBorder;
    self.nickName.size = [self.nickName.text sizeWithFont:[UIFont boldSystemFontOfSize:14.0f]];
    self.nickName.centerX = self.userName.centerX;
    
    self.sexView.x = CGRectGetMaxX(self.nickName.frame) + postCellBorder;
    self.sexView.y = self.nickName.y;
    self.sexView.size = CGSizeMake(16, 16);
    
    self.fansCount.y = CGRectGetMaxY(self.nickName.frame) + postCellBorder;
    self.fansCount.size = [self.fansCount.text sizeWithFont:postNameFont];
    self.fansCount.centerX = self.userName.centerX;
    
    CGFloat margin = 20;
    self.attributeCount.y = self.fansCount.y;
    self.attributeCount.size = [self.attributeCount.text sizeWithFont:postNameFont];
    self.attributeCount.x = self.fansCount.x - self.fansCount.width - margin;
    
    
    self.sendPostCount.y = self.fansCount.y;
    self.sendPostCount.size = [self.sendPostCount.text sizeWithFont:postNameFont];
    self.sendPostCount.x = CGRectGetMaxX(self.fansCount.frame) + margin;
#endif
    
    MyModule *coin = [[MyModule alloc] init];
    coin.imageName = @"member_wallet";
    coin.moduleName = kMine_coin_name;
    coin.moduleValue = [NSString stringWithFormat:@"%ld",user.jiecao_coin];
    
    MyModule *charm = [[MyModule alloc] init];
    charm.imageName = @"member_meili";
    charm.moduleName = @"魅力值";
    charm.moduleValue = [NSString stringWithFormat:@"%d",[user.glamorous intValue]];
    
    MyModule *vipLevel = [[MyModule alloc] init];
    vipLevel.imageName = @"member_recognize";
    vipLevel.moduleName = @"女生认证";
    vipLevel.moduleValue = nil;
    
    MyModule *seekRecord = [[MyModule alloc] init];
    seekRecord.imageName = @"member_miyue";
    seekRecord.moduleName = @"约会记录";
    seekRecord.moduleValue = nil;
    
    self.coinView.module = coin;
    self.charmView.module = charm;
    self.vipLevelView.module = vipLevel;
    self.seekRecordView.module = seekRecord;
}

@end
