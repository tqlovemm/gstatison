//
//  EaseBubbleView+XDCustomGiftsView.m
//  ThirteenmakeFriends
//
//  Created by 空谷凌虚 on 2018/5/22.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "EaseBubbleView+XDCustomGiftsView.h"
#import <objc/runtime.h>

static char _userHeaderImageView_;
static char _userNameLabel_;
static char _userDesLabel_;
static char _line_;
static char _tipsLabel_;
static char _rightImageView_;


@implementation EaseBubbleView (XDCustomGiftsView)

#pragma mark - private
- (void)_setupGiftConstraintsXX
{
    [self.marginConstraints removeAllObjects];
    
    //userHeaderImageView
    NSLayoutConstraint *userHeaderImageViewTopConstraint =
    [NSLayoutConstraint constraintWithItem:self.userHeaderImageView
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.backgroundImageView
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0
                                  constant:10];
    [self.marginConstraints addObject:userHeaderImageViewTopConstraint];

    
    if(self.isSender){
        NSLayoutConstraint *userHeaderImageViewLeadingConstraint =
        [NSLayoutConstraint constraintWithItem:self.userHeaderImageView
                                     attribute:NSLayoutAttributeLeading
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.backgroundImageView
                                     attribute:NSLayoutAttributeLeading
                                    multiplier:1.0
                                      constant:11];
        
        [self.marginConstraints addObject:userHeaderImageViewLeadingConstraint];
    } else {
        NSLayoutConstraint *userHeaderImageViewLeadingConstraint =
        [NSLayoutConstraint constraintWithItem:self.userHeaderImageView
                                     attribute:NSLayoutAttributeLeading
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.backgroundImageView
                                     attribute:NSLayoutAttributeLeading
                                    multiplier:1.0
                                      constant:16];
        
        [self.marginConstraints addObject:userHeaderImageViewLeadingConstraint];
    }
    
    //    NSLayoutConstraint *userHeaderImageViewLeadingConstraint =
    //    [NSLayoutConstraint constraintWithItem:self.userHeaderImageView
    //                                 attribute:NSLayoutAttributeLeading
    //                                 relatedBy:NSLayoutRelationEqual
    //                                    toItem:self.backgroundImageView
    //                                 attribute:NSLayoutAttributeLeading
    //                                multiplier:1.0
    //                                  constant:11];
    //
    //    [self.marginConstraints addObject:userHeaderImageViewLeadingConstraint];
    
    NSLayoutConstraint *userHeaderImageViewHeightConstraint =
    [NSLayoutConstraint constraintWithItem:self.userHeaderImageView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:0
                                  constant:45];

    NSLayoutConstraint *userHeaderImageViewWidthConstraint =
    [NSLayoutConstraint constraintWithItem:self.userHeaderImageView
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:0
                                  constant:45];
    
    [self.userHeaderImageView addConstraint:userHeaderImageViewHeightConstraint];
    [self.userHeaderImageView addConstraint:userHeaderImageViewWidthConstraint];
    
    // userNameLabel
    NSLayoutConstraint *userNameLabelWithMarginTopConstraint =
    [NSLayoutConstraint constraintWithItem:self.userNameLabel
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.userHeaderImageView
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0
                                  constant:0];
    
    NSLayoutConstraint *userNameLabelWithMarginRightConstraint =
    [NSLayoutConstraint constraintWithItem:self.userNameLabel
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.backgroundImageView
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1.0
                                  constant:-self.margin.right];
    
    NSLayoutConstraint *userNameLabelWithMarginLeftConstraint =
    [NSLayoutConstraint constraintWithItem:self.userNameLabel
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.userHeaderImageView
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1.0
                                  constant:5];
    
    [self.marginConstraints addObject:userNameLabelWithMarginRightConstraint];
    [self.marginConstraints addObject:userNameLabelWithMarginTopConstraint];
    [self.marginConstraints addObject:userNameLabelWithMarginLeftConstraint];
    
    // userDesLabel
    //    NSLayoutConstraint *userDesLabelTopConstraint =
    //    [NSLayoutConstraint constraintWithItem:self.userDesLabel
    //                                 attribute:NSLayoutAttributeBottom
    //                                 relatedBy:NSLayoutRelationEqual
    //                                    toItem:self.userHeaderImageView
    //                                 attribute:NSLayoutAttributeBottom
    //                                multiplier:1.0
    //                                  constant:1];
    
    NSLayoutConstraint *userDesLabelTopConstraint =
    [NSLayoutConstraint constraintWithItem:self.userDesLabel
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.userNameLabel
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:0];
    
    NSLayoutConstraint *userDesLabelLeftConstraint =
    [NSLayoutConstraint constraintWithItem:self.userDesLabel
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.userNameLabel
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1.0
                                  constant:0];
    NSLayoutConstraint *userDesLabelRightConstraint =
    [NSLayoutConstraint constraintWithItem:self.userDesLabel
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.backgroundImageView
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1.0
                                  constant:-self.margin.right];
    
    [self.marginConstraints addObject:userDesLabelTopConstraint];
    [self.marginConstraints addObject:userDesLabelLeftConstraint];
    [self.marginConstraints addObject:userDesLabelRightConstraint];
    

    //  line
    NSLayoutConstraint *lineTopConstraint =
    [NSLayoutConstraint constraintWithItem:self.line
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.userHeaderImageView
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:10];

    NSLayoutConstraint *lineLeftConstraint =
    [NSLayoutConstraint constraintWithItem:self.line
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.userHeaderImageView
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1.0
                                  constant:0];

    NSLayoutConstraint *lineRightConstraint =
    [NSLayoutConstraint constraintWithItem:self.line
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.backgroundImageView
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1.0
                                  constant:-self.margin.right];

    NSLayoutConstraint *lineHeightConstraint =
    [NSLayoutConstraint constraintWithItem:self.line
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:0.0
                                  constant:0.3];

    [self.marginConstraints addObject:lineTopConstraint];
    [self.marginConstraints addObject:lineLeftConstraint];
    [self.marginConstraints addObject:lineRightConstraint];
    [self.marginConstraints addObject:lineHeightConstraint];

    // tipsLabel
    NSLayoutConstraint *tipsLabelTopConstraint =
    [NSLayoutConstraint constraintWithItem:self.tipsLabel
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.line
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:4];

    NSLayoutConstraint *tipsLabelLeftConstraint =
    [NSLayoutConstraint constraintWithItem:self.tipsLabel
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.line
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1.0
                                  constant:0];
    NSLayoutConstraint *tipsLabelRightConstraint =
    [NSLayoutConstraint constraintWithItem:self.tipsLabel
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.line
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1.0
                                  constant:0];
    [self.marginConstraints addObject:tipsLabelTopConstraint];
    [self.marginConstraints addObject:tipsLabelLeftConstraint];
    [self.marginConstraints addObject:tipsLabelRightConstraint];

    
    NSLayoutConstraint *rIVWithMarginCentYConstraint =
    [NSLayoutConstraint constraintWithItem:self.rightImageView
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.tipsLabel
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1.0
                                  constant:0];
    
    NSLayoutConstraint *rIVWithMarginRightConstraint =
    [NSLayoutConstraint constraintWithItem:self.rightImageView
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.backgroundImageView
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1.0
                                  constant:-self.margin.right];
    

    NSLayoutConstraint *rIVWithMarginHeightConstraint =
    [NSLayoutConstraint constraintWithItem:self.rightImageView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:0
                                  constant:16];
    
    NSLayoutConstraint *rIVWithMarginWidthConstraint =
    [NSLayoutConstraint constraintWithItem:self.rightImageView
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:0
                                  constant:16];
    
    [self.marginConstraints addObject:rIVWithMarginCentYConstraint];
    [self.marginConstraints addObject:rIVWithMarginRightConstraint];
    [self.marginConstraints addObject:rIVWithMarginHeightConstraint];
    [self.marginConstraints addObject:rIVWithMarginWidthConstraint];
    
    [self addConstraints:self.marginConstraints];
    
    NSLayoutConstraint *backImageConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0f constant:260];
    
    [self.superview addConstraint:backImageConstraint];
}


#pragma mark - public
- (void)setupBusinessGiftBubbleView {
    // 头像
    self.userHeaderImageView = [UIImageView new];
    [self.userHeaderImageView setImage:[UIImage imageNamed:@"gife"]];
    self.userHeaderImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.userHeaderImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.userHeaderImageView.layer.cornerRadius = 22.f;
    self.userHeaderImageView.layer.masksToBounds = YES;
    
    [self.backgroundImageView addSubview:self.userHeaderImageView];
    // 昵称
    self.userNameLabel = [UILabel new];
    self.userNameLabel.font = kPingFangBoldFont(14);
    self.userNameLabel.textColor = RGB(65, 65, 65);
    self.userNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.backgroundImageView addSubview:self.userNameLabel];
    // 描述
    self.userDesLabel = [UILabel new];
    self.userDesLabel.numberOfLines = 2;
    self.userDesLabel.font = kPingFangRegularFont(10);
    self.userDesLabel.textColor = RGB(119, 119, 119);
    self.userDesLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.backgroundImageView addSubview:self.userDesLabel];

    
    // 分隔线
    self.line = [UIView new];
    self.line.backgroundColor = RGBA(119, 119, 119,0.3);
    self.line.translatesAutoresizingMaskIntoConstraints = NO;
    [self.backgroundImageView addSubview:self.line];
    // 提示字
    self.tipsLabel = [UILabel new];
    self.tipsLabel.text = @"送礼给TA";
    self.tipsLabel.font = [UIFont systemFontOfSize:12.0f];
    self.tipsLabel.textColor = RGB(119, 119, 119);
    self.tipsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.backgroundImageView addSubview:self.tipsLabel];
    
    
    self.rightImageView = [UIImageView new];
    [self.rightImageView setImage:[UIImage imageNamed:@"arrow"]];
    self.rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.rightImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.rightImageView.layer.masksToBounds = YES;
    [self.backgroundImageView addSubview:self.rightImageView];
    [self _setupGiftConstraintsXX];
}
- (void)updateBusinessGiftMargin:(UIEdgeInsets)margin
{
    if (_margin.top == margin.top && _margin.bottom == margin.bottom && _margin.left == margin.left && _margin.right == margin.right) {
        return;
    }
    _margin = margin;
    
    [self removeConstraints:self.marginConstraints];
    [self _setupGiftConstraintsXX];
}

#pragma mark - getter and setter

- (void)setUserHeaderImageView:(UIImageView *)userHeaderImageView
{
    objc_setAssociatedObject(self, &_userHeaderImageView_, userHeaderImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageView *)userHeaderImageView
{
    return objc_getAssociatedObject(self, &_userHeaderImageView_);
}

- (void)setUserNameLabel:(UILabel *)userNameLabel
{
    objc_setAssociatedObject(self, &_userNameLabel_, userNameLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)userNameLabel
{
    return objc_getAssociatedObject(self, &_userNameLabel_);
}

- (void)setUserDesLabel:(UILabel *)userDesLabel
{
    objc_setAssociatedObject(self, &_userDesLabel_, userDesLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)userDesLabel
{
    return objc_getAssociatedObject(self, &_userDesLabel_);
}

- (void)setLine:(UIView *)line
{
    objc_setAssociatedObject(self, &_line_, line, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)line
{
    return objc_getAssociatedObject(self, &_line_);
}

- (void)setTipsLabel:(UILabel *)tipsLabel
{
    objc_setAssociatedObject(self, &_tipsLabel_, tipsLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)tipsLabel
{
    return objc_getAssociatedObject(self, &_tipsLabel_);
}

-(void)setRightImageView:(UIImageView *)rightImageView{
     objc_setAssociatedObject(self, &_rightImageView_, rightImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIImageView *)rightImageView{
     return objc_getAssociatedObject(self, &_rightImageView_);
}

@end
