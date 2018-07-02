//
//  XDPostPraiseCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/5/15.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XDPostPraiseFrameModel;

@interface XDPostPraiseCell : UITableViewCell

@property (strong, nonatomic) XDPostPraiseFrameModel * praiseFrameModel;

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
