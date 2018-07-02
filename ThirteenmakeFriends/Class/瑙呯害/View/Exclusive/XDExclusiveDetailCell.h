//
//  XDExclusiveDetailCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/9/6.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ExclusiveModel;

@interface XDExclusiveDetailCell : UITableViewCell

@property (nonatomic, strong) ExclusiveModel *seekModel;

/**
 支付
 */
@property (copy, nonatomic) void (^payButtonClicked)(UIButton *payBtn);

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
