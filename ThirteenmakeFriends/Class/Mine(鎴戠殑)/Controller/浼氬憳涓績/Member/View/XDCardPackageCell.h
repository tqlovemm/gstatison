//
//  XDCardPackageCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/18.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XDVoucherModel;

@interface XDCardPackageCell : UITableViewCell

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) XDVoucherModel *voucherModel;

@end
