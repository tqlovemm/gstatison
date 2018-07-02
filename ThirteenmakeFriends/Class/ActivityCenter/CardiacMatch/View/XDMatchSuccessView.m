//
//  XDMatchSuccessView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/12/14.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDMatchSuccessView.h"
#import "UIImageView+WebCache.h"
#import "XDMatchUserModel.h"
#import "ProfileUser.h"
#import "XDAccountTool.h"

@interface XDMatchSuccessView ()
@property (nonatomic, weak) UILabel * successLabel;

@property (nonatomic, weak) UIImageView * centerView;

@property (nonatomic, weak) UIImageView * myView;

@property (nonatomic, weak) UIImageView * yourView;

@property (nonatomic, weak) UIButton * chatButton;

@property (nonatomic, weak) UIButton * continueButton;

@end

@implementation XDMatchSuccessView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    
    UILabel *successLabel = [[UILabel alloc]init];
    successLabel.text = @"匹配成功";
    successLabel.font = kPingFangThinFont(48);
    successLabel.textColor = RGB(67, 63, 77);
    successLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:successLabel];
    self.successLabel = successLabel;
    
    UIImageView *centerView = [[UIImageView alloc]init];
    centerView.image = [UIImage imageNamed:@"match_success_center"];
    [self addSubview:centerView];
    self.centerView = centerView;
    
    UIImageView *myView = [[UIImageView alloc]init];
    myView.userInteractionEnabled = YES;
    [self addSubview:myView];
    self.myView = myView;
    
    UIImageView *yourView = [[UIImageView alloc]init];
    yourView.userInteractionEnabled = YES;
    [self addSubview:yourView];
    self.yourView = yourView;
    
    UIButton *chatButton = [[UIButton alloc] init];
    [chatButton setImage:[UIImage imageNamed:@"match_look"] forState:UIControlStateNormal];
    [chatButton addTarget:self action:@selector(chatButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:chatButton];
    self.chatButton = chatButton;
    
    UIButton * continueButton = [[UIButton alloc] init];
    [continueButton setImage:[UIImage imageNamed:@"match_retry"] forState:UIControlStateNormal];
    [continueButton addTarget:self action:@selector(continueButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:continueButton];
    self.continueButton = continueButton;
    
    UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headIconClicked:)];
    [myView addGestureRecognizer:myTap];
    
    UITapGestureRecognizer *yourTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headIconClicked:)];
    [yourView addGestureRecognizer:yourTap];
    
    XD_WeakSelf
    [self.successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(63);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.successLabel.mas_bottom).offset(64);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(23, 16));
    }];
    
    [self.yourView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.right.mas_equalTo(self.centerView.mas_left).offset(-20);
        make.centerY.mas_equalTo(self.centerView);
        make.size.mas_equalTo(CGSizeMake(82, 82));
    }];
    self.yourView.layer.cornerRadius = 41;
    self.yourView.layer.masksToBounds = YES;
    
    [self.myView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.left.mas_equalTo(self.centerView.mas_right).offset(20);
        make.centerY.mas_equalTo(self.centerView);
        make.size.mas_equalTo(CGSizeMake(82, 82));
    }];
    self.myView.layer.cornerRadius = 41;
    self.myView.layer.masksToBounds = YES;
    
    [self.chatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.centerView.mas_bottom).offset(70);
        make.centerX.mas_equalTo(self.centerView);
        make.size.mas_equalTo(CGSizeMake(192, 44));
    }];
    
    [self.continueButton mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.chatButton.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.chatButton);
        make.size.mas_equalTo(CGSizeMake(192, 44));
    }];
}

- (void)chatButtonEvent:(UIButton *)chatBtn {
    if ([self.delegate respondsToSelector:@selector(chatButtonClicked:)]) {
        [self.delegate chatButtonClicked:chatBtn];
    }
}

- (void)continueButtonEvent:(UIButton *)continueBtn {
    if ([self.delegate respondsToSelector:@selector(continueButtonClicked:)]) {
        [self.delegate continueButtonClicked:continueBtn];
    }
}

- (void)headIconClicked:(UITapGestureRecognizer *)tap {
    NSString *user_id = @"";
    if ([tap.view isEqual:self.myView]) {
        user_id = [NSString stringWithFormat:@"%ld",self.user.user_id];
    } else {
        ProfileUser *mineUser = [XDAccountTool account];
        user_id = [NSString stringWithFormat:@"%@",mineUser.user_id];
    }
    
    if (self.headIconClicked) {
        self.headIconClicked(user_id);
    }
}

- (void)setUser:(XDMatchUserModel *)user {
    _user = user;
    
    ProfileUser *mineUser = [XDAccountTool account];
//    [self.myView sd_setImageWithURL:[NSURL URLWithString:mineUser.avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
//    [self.yourView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    [self.myView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    [self.yourView sd_setImageWithURL:[NSURL URLWithString:mineUser.avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
}

@end
