//
//  XDCheckSignUpCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/9.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XDSignUpModel;

@interface XDCheckSignUpCell : UITableViewCell

@property (nonatomic, strong) XDSignUpModel *model;

/** 会话按钮点击 */
@property (nonatomic, copy) void (^sessionBtnClicked)(XDSignUpModel *model);

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
