//
//  XDSeekScreenCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/9/5.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDSeekScreenCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UILabel *desLabel;

@end
