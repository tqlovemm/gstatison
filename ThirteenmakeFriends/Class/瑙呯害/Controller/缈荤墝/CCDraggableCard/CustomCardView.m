//
//  CustomCardView.m
//  CCDraggableCard-Master
//
//  Created by jzzx on 16/7/9.
//  Copyright © 2016年 Zechen Liu. All rights reserved.
//

#import "CustomCardView.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "ShiSanUser.h"
#import "NSString+Age.h"

@interface CustomCardView ()

@property (strong, nonatomic) ShiSanUser * user;

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImageView *sexView;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UILabel     *titleLabel;
@property (strong, nonatomic) UILabel     *ageLabel;
@property (strong, nonatomic) UILabel     *addressLabel;

//! 喜欢
@property (strong, nonatomic) UIImageView *likeView;
//! 不喜欢
@property (strong, nonatomic) UIImageView *dislikeView;

@end

@implementation CustomCardView

- (instancetype)init {
    if (self = [super init]) {
        [self loadComponent];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadComponent];
    }
    return self;
}

- (void)loadComponent {
    
    self.imageView = [[UIImageView alloc] init];
    self.lineView = [[UIView alloc] init];
    self.sexView = [[UIImageView alloc] init];
    self.titleLabel = [[UILabel alloc] init];
    self.ageLabel = [[UILabel alloc] init];
    self.addressLabel = [[UILabel alloc] init];
    
    self.likeView = [[UIImageView alloc] init];
    self.dislikeView = [[UIImageView alloc] init];
    self.likeView.image = [UIImage imageNamed:@"flop_yesOverlayImage"];
    self.dislikeView.image = [UIImage imageNamed:@"flop_noOverlayImage"];
    self.dislikeView.alpha = 0;
    self.likeView.alpha = 0;
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.imageView.layer setMasksToBounds:YES];
    
    self.titleLabel.textColor = RGB(65, 65, 65);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.ageLabel.textColor = RGB(119, 119, 119);
    self.ageLabel.font = [UIFont systemFontOfSize:14];
    self.addressLabel.textColor = RGB(119, 119, 119);
    self.addressLabel.font = [UIFont systemFontOfSize:14];
    self.lineView.backgroundColor = RGB(119, 119, 119);
    
    [self addSubview:self.imageView];
    [self addSubview:self.sexView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.ageLabel];
    [self addSubview:self.addressLabel];
    [self addSubview:self.lineView];
    
    [self addSubview:self.likeView];
    [self addSubview:self.dislikeView];
    
//    self.backgroundColor = [UIColor colorWithRed:0.951 green:0.951 blue:0.951 alpha:1.00];
    self.backgroundColor = [UIColor whiteColor];

}

- (void)cc_layoutSubviews {
    
    self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 48);
    
    CGSize nicknameSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font maxW:self.frame.size.width / 2.0 - 30];
//    self.titleLabel.frame = (CGRect){{10,CGRectGetMaxY(self.imageView.frame) + 17},nicknameSize};
    self.titleLabel.frame =CGRectMake(10, CGRectGetMaxY(self.imageView.frame) + 17, nicknameSize.width, 20);
    self.sexView.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 5, CGRectGetMaxY(self.imageView.frame) + 19, 15, 15);
    
    CGSize addressSize = [self.addressLabel.text sizeWithFont:self.addressLabel.font];
    self.addressLabel.frame = (CGRect){{self.width - addressSize.width - 10,self.titleLabel.y+2},addressSize};
    
//    self.lineView.frame = CGRectMake(self.width - addressSize.width - 19, self.titleLabel.y+4, 1, 13);
    CGSize ageSize = [self.ageLabel.text sizeWithFont:self.ageLabel.font];
//    self.ageLabel.frame = (CGRect){{self.width - addressSize.width - 27 - ageSize.width,self.titleLabel.y+2},ageSize};
    
    if (addressSize.width == 0) {
        self.ageLabel.frame = (CGRect){{self.width - addressSize.width - 10 - ageSize.width,self.titleLabel.y+2},ageSize};
    } else {
        self.ageLabel.frame = (CGRect){{self.width - addressSize.width - 27 - ageSize.width,self.titleLabel.y+2},ageSize};
    }
    
    if (ageSize.width == 0 || addressSize.width == 0) {
        self.lineView.frame = CGRectMake(self.width - addressSize.width - 19, self.titleLabel.y+4, 0, 0);
    } else {
        self.lineView.frame = CGRectMake(self.width - addressSize.width - 19, self.titleLabel.y+4, 1, 13);
    }
    
//    self.likeView.frame = CGRectMake(10, 10, 65, 65);
//    self.dislikeView.frame = CGRectMake(self.frame.size.width - 75, 10, 65, 65);
    self.likeView.frame = CGRectMake(10, 10, 94, 58);
    self.dislikeView.frame = CGRectMake(self.frame.size.width - 104, 10, 94, 58);
}

- (void)installData:(ShiSanUser *)user {
    self.user = user;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"square_image_placeholder"]];
    self.titleLabel.text = user.nickname;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    dateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    NSDate *ageDate = [dateFormatter dateFromString:user.birthdate];
    
    NSString *age = [NSString fromDateToAge:ageDate];
    self.ageLabel.text = [age isEqualToString:@"0"] ? nil : age;
    self.addressLabel.text = user.area_one;
    self.sexView.image = [UIImage imageNamed:[user.sex isEqualToString:@"1"] ? @"icon_selectedwomen" : @"icon_selectedman"];
}

#pragma mark - 新增(增加喜欢不喜欢遮罩)

- (void)likeViewWithAlpha:(CGFloat )alpha {
    self.likeView.alpha = alpha;
}

- (void)dislikeViewWithAlpha:(CGFloat )alpha {
    self.dislikeView.alpha = alpha;
}

@end
