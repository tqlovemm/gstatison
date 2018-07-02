//
//  XDSeekDetailCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/8/30.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Seek;

@interface XDSeekDetailCell : UITableViewCell

@property (nonatomic, strong) Seek *seekModel;

/**
 支付
 */
@property (copy, nonatomic) void (^payButtonClicked)(UIButton *payBtn);

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
