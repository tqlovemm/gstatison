//
//  XDMessageCategoryCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/25.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XDMsgCategoryModel;

@interface XDMessageCategoryCell : UITableViewCell

@property (nonatomic, strong) XDMsgCategoryModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
