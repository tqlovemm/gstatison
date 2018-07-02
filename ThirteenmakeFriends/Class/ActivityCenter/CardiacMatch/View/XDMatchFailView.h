//
//  XDMatchFailView.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/12/19.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XDMatchFailViewDelegate <NSObject>

- (void)personMatchButtonClicked:(UIButton *)btn;

- (void)retryMatchButtonClicked:(UIButton *)btn;

@end

@interface XDMatchFailView : UIView

/** 头像点击 */
@property (copy, nonatomic) void (^headIconClicked)(NSString *user_id);

@property (weak, nonatomic) id<XDMatchFailViewDelegate> delegate;

@end
