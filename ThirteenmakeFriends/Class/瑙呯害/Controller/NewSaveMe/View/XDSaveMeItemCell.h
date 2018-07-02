//
//  XDSaveMeItemCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/5.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XDSaveMeModel;

@interface XDSaveMeItemCell : UITableViewCell

@property (nonatomic, strong) XDSaveMeModel *model;

/** 报名 */
@property (nonatomic, copy) void (^signUpBtnClicked)(XDSaveMeModel *model);
/** 查看报名 */
@property (nonatomic, copy) void (^viewBtnClicked)(XDSaveMeModel *model);

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
