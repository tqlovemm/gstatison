//
//  XDTopicItemCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/10/27.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XDAcitivityModel;

@interface XDTopicItemCell : UITableViewCell

@property (nonatomic, strong) XDAcitivityModel *tagModel;

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
