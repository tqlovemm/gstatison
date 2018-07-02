//
//  XDPersonHeaderView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/12/13.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "XDPersonHeaderView.h"
#import "UIImageView+WebCache.h"
#import "ShiSanUser.h"
#import "XDPhotoBrowser.h"

@interface XDPersonHeaderView ()

@property (strong, nonatomic) ShiSanUser * user;

@property (weak, nonatomic) UIImageView * headerView;

@end

@implementation XDPersonHeaderView

- (instancetype)initWithFrame:(CGRect)frame andUserInfo:(ShiSanUser *)user {
    if (self = [super initWithFrame:frame]) {
        self.user = user;
        [self setupSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.user.avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    [self addSubview:imageView];
    imageView.layer.cornerRadius = 5;
    imageView.layer.masksToBounds = YES;
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewClicked:)];
    [imageView addGestureRecognizer:tap];
    self.headerView = imageView;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 10, 20, 0, 0)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = k14Font;
    nameLabel.textColor = RGB(65, 65, 65);
    nameLabel.text = self.user.nickname.length > 0 ? self.user.nickname : self.user.username;
    CGSize nameLabelSize = [nameLabel.text sizeWithFont:k14Font];
    nameLabel.size = nameLabelSize;
    [self addSubview:nameLabel];
    
    UIImageView *sexView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame) + 10, 20, 15, 15)];
    
    sexView.image = [UIImage imageNamed:[self.user.sex isEqualToString:@"1"] ? @"icon_selectedwomen" : @"icon_selectedman"];
    [self addSubview:sexView];
    
    UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.x, CGRectGetMaxY(nameLabel.frame) + 10, 0, 0)];
    usernameLabel.backgroundColor = [UIColor clearColor];
    usernameLabel.text = [NSString stringWithFormat:@"用户名：%@",self.user.username];
    usernameLabel.font = k12Font;
    usernameLabel.textColor = RGB(159, 159, 159);
    CGSize usernameLabelSize = [usernameLabel.text sizeWithFont:k12Font];
    usernameLabel.size = usernameLabelSize;
    [self addSubview:usernameLabel];
}

- (void)headerViewClicked:(UITapGestureRecognizer *)tap {
    
    [[XDPhotoBrowser defaultManager] showBrowserWithImages:@[self.user.avatar] andCurrentIndex:tap.view.tag fromImageContainer:tap.view];
}

@end
