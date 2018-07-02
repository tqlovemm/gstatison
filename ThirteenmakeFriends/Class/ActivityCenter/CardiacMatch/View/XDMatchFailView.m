
//
//  XDMatchFailView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/12/19.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDMatchFailView.h"
#import "UIImageView+WebCache.h"
#import "ProfileUser.h"
#import "XDAccountTool.h"

@interface XDMatchFailView ()

@property (nonatomic, weak) UILabel * successLabel;

@property (nonatomic, weak) UIImageView * myView;

@property (nonatomic, weak) UIButton * chatButton;

@property (nonatomic, weak) UIButton * continueButton;

@end

@implementation XDMatchFailView

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
    successLabel.text = @"暂无匹配";
    successLabel.font = kPingFangThinFont(48);
    successLabel.textColor = RGB(67, 63, 77);
    successLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:successLabel];
    self.successLabel = successLabel;
    
    UIImageView *myView = [[UIImageView alloc]init];
    myView.userInteractionEnabled = YES;
    [self addSubview:myView];
    self.myView = myView;
    
    UIButton *chatButton = [[UIButton alloc] init];
    [chatButton setImage:[UIImage imageNamed:@"match_request_person"] forState:UIControlStateNormal];
    [chatButton addTarget:self action:@selector(chatButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:chatButton];
    self.chatButton = chatButton;
    
    UIButton * continueButton = [[UIButton alloc] init];
    [continueButton setImage:[UIImage imageNamed:@"match_retry"] forState:UIControlStateNormal];
    [continueButton addTarget:self action:@selector(continueButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:continueButton];
    self.continueButton = continueButton;
    
    UITapGestureRecognizer *yourTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headIconClicked:)];
    [myView addGestureRecognizer:yourTap];
    
    XD_WeakSelf
    [self.successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(63);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.myView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.successLabel.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(82, 82));
    }];
    self.myView.layer.cornerRadius = 41;
    self.myView.layer.masksToBounds = YES;
    
    [self.chatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.myView.mas_bottom).offset(40);
        make.centerX.mas_equalTo(self.myView);
        make.size.mas_equalTo(CGSizeMake(192, 44));
    }];
    
    [self.continueButton mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.top.mas_equalTo(self.chatButton.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.chatButton);
        make.size.mas_equalTo(CGSizeMake(192, 44));
    }];
    
    [self setPersonInfo];
}

- (void)setPersonInfo {
    ProfileUser *user = [XDAccountTool account];
    [self.myView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
}

- (void)chatButtonEvent:(UIButton *)chatBtn {
    if ([self.delegate respondsToSelector:@selector(personMatchButtonClicked:)]) {
        [self.delegate personMatchButtonClicked:chatBtn];
    }
}

- (void)continueButtonEvent:(UIButton *)continueBtn {
    if ([self.delegate respondsToSelector:@selector(retryMatchButtonClicked:)]) {
        [self.delegate retryMatchButtonClicked:continueBtn];
    }
}

- (void)headIconClicked:(UITapGestureRecognizer *)tap {
    
    ProfileUser *user = [XDAccountTool account];
    NSString *user_id = [NSString stringWithFormat:@"%@",user.user_id];
    
    if (self.headIconClicked) {
        self.headIconClicked(user_id);
    }
}

@end
