//
//  XDBusinessCardCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/30.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XDNewMessageModel;

@interface XDBusinessCardCell : UITableViewCell

@property (nonatomic, strong) XDNewMessageModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
