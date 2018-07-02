//
//  XDSingleImageMsgCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/26.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel.h"

@class XDNewMessageModel;

@interface XDSingleImageMsgCell : UITableViewCell

@property (nonatomic, strong) XDNewMessageModel *model;

@property (nonatomic, copy) void (^didSelectLinkTextOperationBlock)(NSString *link, MLEmojiLabelLinkType type);

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
