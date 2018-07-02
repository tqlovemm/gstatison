//
//  XDPersonForbiddenCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/12/20.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDPersonForbiddenCell : UITableViewCell

/** 升级或认证点击 */
@property (copy, nonatomic) void (^upgradeButtonClicked)(NSInteger sex);

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
