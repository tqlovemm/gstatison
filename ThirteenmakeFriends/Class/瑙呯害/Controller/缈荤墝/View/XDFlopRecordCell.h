//
//  XDFlopRecordCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/6/8.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XDFlopEvaluationModel;

@interface XDFlopRecordCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong, nonatomic) XDFlopEvaluationModel *matchModel;

@end
