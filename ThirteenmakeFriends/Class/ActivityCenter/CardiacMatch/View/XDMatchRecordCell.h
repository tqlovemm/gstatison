//
//  XDMatchRecordCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/12/19.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XDMatchRecordModel;

@interface XDMatchRecordCell : UITableViewCell

@property (nonatomic, strong) XDMatchRecordModel *recordModel;

/** 点击评论 */
@property (nonatomic, copy) void (^commentButtonClickedBlock)(UIButton *btn);

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
