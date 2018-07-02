//
//  XDFlopOtherButtomView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/6/8.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDFlopOtherButtomView.h"

// 自身高度
CGFloat const SelfViewHeight = 105;

@interface XDFlopOtherButtomView ()

@property (strong, nonatomic) NSMutableArray *btnsArray;

@end

@implementation XDFlopOtherButtomView

- (NSMutableArray *)btnsArray {
    if (_btnsArray == nil) {
        _btnsArray = [NSMutableArray array];
    }
    return _btnsArray;
}

- (instancetype)init {
    if (self = [super init]) {
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

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    img.image = [UIImage imageNamed:@"other_flop_bottom_background"];
    [self addSubview:img];
    
    self.likeBtn = [self setupBtnWithIcon:@"flop_like"];
    self.unlikeBtn = [self setupBtnWithIcon:@"flop_unlike"];
}


- (UIButton *)setupBtnWithIcon:(NSString *)icon
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageWithName:icon] forState:UIControlStateNormal];
    
    [self addSubview:btn];
    
    [self.btnsArray addObject:btn];
    
    return btn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置按钮的frame
    CGFloat btnH = 81;
    CGFloat btnW = 81;
//    self.unlikeBtn.frame = CGRectMake(12, self.frame.size.height - btnH - 12, btnW, btnH);
//    self.likeBtn.frame = CGRectMake(SCREEN_WIDTH - 12 - btnW, self.frame.size.height - btnH - 12, btnW, btnH);
    self.unlikeBtn.frame = CGRectMake(12, iPhoneX ? self.frame.size.height - btnH - 24 : self.frame.size.height - btnH - 12, btnW, btnH);
    self.likeBtn.frame = CGRectMake(SCREEN_WIDTH - 12 - btnW, iPhoneX ? self.frame.size.height - btnH - 24 : self.frame.size.height - btnH - 12, btnW, btnH);
}

+ (instancetype)createFlopButtomViewInSuperView:(UIView *)superView {
    
    XDFlopOtherButtomView *bottomView = [[self alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - SelfViewHeight, SCREEN_WIDTH, SelfViewHeight)];
    [superView addSubview:bottomView];
    bottomView.transform = CGAffineTransformMakeTranslation(0, SelfViewHeight);
    [bottomView showAnimation];
    return bottomView;
}

- (void)showAnimation {
    [UIView animateWithDuration:0.6f animations:^{
        self.hidden = NO;
        self.transform = CGAffineTransformIdentity;
    }];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
}

- (void)hiddenAnimation {
    
    [UIView animateWithDuration:0.6f animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, SelfViewHeight);
    } completion:^(BOOL finished) {
    }];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
}

@end
