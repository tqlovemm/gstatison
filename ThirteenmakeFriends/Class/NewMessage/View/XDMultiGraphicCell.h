//
//  XDMultiGraphicCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/26.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XDNewMessageModel;

@interface XDMultiGraphicCell : UITableViewCell

//@property (nonatomic, strong) NSArray<XDNewMessageGraphicModel*> *modelArray;
@property (nonatomic, strong) XDNewMessageModel *model;

@property (nonatomic, copy) void (^didSelectMessageItemBlock)(NSString *url);

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
