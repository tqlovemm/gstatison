//
//  XDXDBillingCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/8/28.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XDBillingModel,XDBillingDiaModel;

@interface XDXDBillingCell : UITableViewCell

@property (strong, nonatomic) XDBillingModel * billingModel;
@property (strong, nonatomic) XDBillingDiaModel * billingDiaModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
