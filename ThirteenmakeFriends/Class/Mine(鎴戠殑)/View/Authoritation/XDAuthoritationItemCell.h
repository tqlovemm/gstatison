//
//  XDAuthoritationItemCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/11/10.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XDAnthoritationModel;

@interface XDAuthoritationItemCell : UITableViewCell

@property (nonatomic, strong) XDAnthoritationModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
