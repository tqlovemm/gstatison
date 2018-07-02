//
//  FansCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/1/18.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FansCell;
@class AttitudeAndFansFrame;

@protocol FansCellDelegate <NSObject>

@optional
- (void)fansCell:(FansCell *)fansCell ClickedBtnWithAttitudeAndFansFrame:(AttitudeAndFansFrame *)attitudeFrame;

@end


@interface FansCell : UITableViewCell

@property (strong, nonatomic) AttitudeAndFansFrame * attitudeFrame;

//! 关注按钮
@property (nonatomic, weak) UIButton *attitudeBtn;

@property (nonatomic, weak) id<FansCellDelegate> delegate;


@end
