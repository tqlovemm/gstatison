//
//  XDMatchSuccessView.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/12/14.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XDMatchUserModel;

@protocol XDMatchSuccessViewDelegate <NSObject>

- (void)chatButtonClicked:(UIButton *)btn;

- (void)continueButtonClicked:(UIButton *)btn;

@end

@interface XDMatchSuccessView : UIView

/** 头像点击 */
@property (copy, nonatomic) void (^headIconClicked)(NSString *user_id);

@property (weak, nonatomic) id<XDMatchSuccessViewDelegate> delegate;

@property (strong, nonatomic) XDMatchUserModel * user;

@end
