//
//  XDCustomPopupCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/25.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDCustomPopupCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

//! 图标
@property (nonatomic, weak) UIImageView * iconView;
//! 标题
@property (nonatomic, weak) UILabel *titleLabel;
//! 内容
@property (weak, nonatomic) UILabel *badge;

@property (nonatomic, assign) NSInteger badgeValue;

@end
