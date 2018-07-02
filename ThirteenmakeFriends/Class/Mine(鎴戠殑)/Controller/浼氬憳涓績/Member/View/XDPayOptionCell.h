//
//  XDPayOptionCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/19.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XDPay;

@interface XDPayOptionCell : UITableViewCell

@property (strong, nonatomic) XDPay *payItem;

//@property (assign, nonatomic) BOOL selected;

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
