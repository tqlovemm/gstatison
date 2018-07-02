//
//  AttitudeCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 15/12/31.
//  Copyright © 2015年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AttitudeCell;
@class AttitudeAndFansFrame;

@protocol AttitudeCellDelegate <NSObject>

@optional
- (void)attitudeCell:(AttitudeCell *)attitudeCell ClickedBtnWithAttitudeAndFansFrame:(AttitudeAndFansFrame *)attitudeFrame;

@end

@interface AttitudeCell : UITableViewCell

//+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong, nonatomic) AttitudeAndFansFrame * attitudeFrame;

//! 关注按钮
@property (nonatomic, weak) UIButton *attitudeBtn;

@property (nonatomic, weak) id<AttitudeCellDelegate> delegate;

@end
