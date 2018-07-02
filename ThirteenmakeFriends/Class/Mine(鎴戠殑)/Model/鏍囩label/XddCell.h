//
//  XddCell.h
//  xdd-布局
//
//  Created by jifeng on 16/2/16.
//  Copyright © 2016年 jifeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XddItemModelFrame.h"
#import "XddItemModel.h"

@interface XddCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) XddItemModelFrame *itemModelFrame;

@end
