//
//  XDDetailHeaderView.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/3/29.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XDPostModel;

@interface XDDetailHeaderView : UIView

@property (strong, nonatomic) XDPostModel * model;

@property (assign, nonatomic) CGFloat headerHeight;

@property (nonatomic, copy) void (^likeButtonClickedOperation)(void);
@property (nonatomic, copy) void (^commentButtonClickedOperation)(void);

@property (nonatomic, copy) void (^otherButtonClickedBlock)(void);

/** 关注与取消关注 */
@property (nonatomic, copy) void (^attentionViewClickedBlock)(UIImageView *attentionView);

/**
 是否隐藏关注
 */
- (void)setAttentionVIewisHiddden:(BOOL)hidden;
@end
