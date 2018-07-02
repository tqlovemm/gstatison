//
//  XDTimeAndPriceCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/19.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XDCardModel;

@interface XDTimeAndPriceCell : UITableViewCell

@property (strong, nonatomic) XDCardModel * cardModel;

/**
 会员时间选择 (0.全年，1.半年)
 */
@property (copy, nonatomic) void (^timeButtonClicked)(NSInteger index);

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
