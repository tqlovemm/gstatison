//
//  XD13SayItemCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/10/25.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XD13SayItemCell.h"
#import "XDPostTopModel.h"

@interface XD13SayItemCell ()

@property (nonatomic, strong) UIImageView *imagView;

@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation XD13SayItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.backgroundColor = [UIColor whiteColor];
    
    self.imagView = [[UIImageView alloc] init];
    self.imagView.contentMode = UIViewContentModeScaleAspectFill;
    self.imagView.clipsToBounds = YES;
    [self addSubview:self.imagView];
    
    self.tipLabel = [[UILabel alloc] init];
    self.tipLabel.textColor = [UIColor whiteColor];
    self.tipLabel.font = kPingFangRegularFont(12);
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    self.tipLabel.numberOfLines = 0;
    [self addSubview:self.tipLabel];
    self.tipLabel.hidden = YES;
}

- (void)setActivityModel:(XDAcitivityModel *)activityModel {
    _activityModel = activityModel;
    
    [self.imagView sd_setImageWithURL:[NSURL URLWithString:activityModel.img]];
    self.tipLabel.text = activityModel.tag_name;
    
    if (activityModel.isLasted) {
        self.tipLabel.textColor = RGB(155, 155, 155);
        self.tipLabel.font = kPingFangBoldFont(10);
        self.tipLabel.textAlignment = NSTextAlignmentRight;
        self.tipLabel.hidden = NO;
    } else {
        self.tipLabel.textColor = [UIColor whiteColor];
        self.tipLabel.font = kPingFangRegularFont(12);
        self.tipLabel.textAlignment = NSTextAlignmentCenter;
        self.tipLabel.hidden = YES;
    }
    
    self.imagView.frame = CGRectMake(5, 5, self.width - 5, self.height - 10);
    self.tipLabel.size = [self.tipLabel.text sizeWithFont:self.tipLabel.font andMaxSize:CGSizeMake(self.width - 10, self.height - 10)];
    self.tipLabel.center = CGPointMake(self.width / 2.0, self.height / 2.0);
    
}

@end
