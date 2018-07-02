//
//  XDWomanSeekDetailCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/11/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XDWomanSeekModel;

@interface XDWomanSeekDetailCell : UITableViewCell

@property (nonatomic, strong) XDWomanSeekModel *user;

/**
 支付
 */
@property (copy, nonatomic) void (^payButtonClicked)(UIButton *payBtn);

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
