//
//  XDOtherInfoCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/8/24.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XDEditInfoModel;

@interface XDOtherInfoCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView reusableCellWithIdentifier:(NSString *)identifier;

@property (assign, nonatomic) CGFloat cellHeight;

@property (nonatomic, strong) XDEditInfoModel *infoModel;

//! 内容
@property (nonatomic, weak) UITextField *textField;

@end
