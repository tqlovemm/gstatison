//
//  XDFlopOtherButtomView.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/6/8.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDFlopOtherButtomView : UIView

@property (weak, nonatomic) UIButton *likeBtn;

@property (weak, nonatomic) UIButton *unlikeBtn;

+ (instancetype)createFlopButtomViewInSuperView:(UIView *)superView;

- (void)showAnimation;

- (void)hiddenAnimation;

@end
