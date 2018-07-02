//
//  XDPostsTopicView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/3/24.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDPostsTopicView.h"
#import "UIResponder+Router.h"

NSString *const kRouterEventPostTopicViewTapEventName = @"kRouterEventPostTopicViewTapEventName";

@interface XDPostsTopicView ()

@property (weak, nonatomic) UILabel * lab;


@end

@implementation XDPostsTopicView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    // 创建Lab
    UILabel *lab = [[UILabel alloc] init];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont boldSystemFontOfSize:13];
    lab.textColor = ThemeColor3;
    lab.layer.cornerRadius = 5;
    lab.layer.masksToBounds = YES;
    lab.layer.borderWidth = 0.5;
    lab.layer.borderColor = ThemeColor3.CGColor;
    lab.layer.cornerRadius = 12;
    lab.layer.masksToBounds = YES;
    lab.userInteractionEnabled = YES;
    
    [self addSubview:lab];
    self.lab = lab;
    
    // 添加手势监听器（一个手势监听器 只能 监听对应的一个view）
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
    [recognizer addTarget:self action:@selector(tapTopicView:)];
    [lab addGestureRecognizer:recognizer];
}

- (void)tapTopicView:(UITapGestureRecognizer *)tap
{
    [self routerEventWithName:kRouterEventPostTopicViewTapEventName userInfo:@{TopicStringKey:self.topicStiing}];
}

- (void)setTopicStiing:(NSString *)topicStiing {
    _topicStiing = topicStiing;
    
    self.lab.text = topicStiing;
    
    CGSize labSize = [topicStiing sizeWithFont:[UIFont boldSystemFontOfSize:13]];
    CGFloat labH = labSize.height + 8;
    CGFloat labW = labSize.width + 12;
    self.lab.frame = CGRectMake(10, 10, labW, labH);
}

@end
