//
//  XDIntroduceCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/9/11.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XDIntroduceModel;

@interface XDIntroduceCell : UITableViewCell

@property (nonatomic, strong) XDIntroduceModel *introModel;

- (void)setLineViewHidden:(BOOL)hidden;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
