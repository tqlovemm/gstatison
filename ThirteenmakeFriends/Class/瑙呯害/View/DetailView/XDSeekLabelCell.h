//
//  XDSeekLabelCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/8/25.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDLabelItemFrameModel.h"
#import "XDLabelItemModel.h"


@interface XDSeekLabelCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) XDLabelItemFrameModel *itemModelFrame;

@end
