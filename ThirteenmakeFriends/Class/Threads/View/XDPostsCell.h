//
//  XDPostsCell.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/3/23.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XDPostFrameModel;

#define XDPostCellModelKey @"XDPostCellHeadIcon"
#define XDPostCellModelViewKey @"XDPostCellHeadIconView"
extern NSString *const kRouterEventHeadIconViewTapEventName;

@interface XDPostsCell : UITableViewCell

@property (strong, nonatomic) XDPostFrameModel * postFrameModel;

@property (nonatomic, strong) NSIndexPath *indexPath;


/** 是否展开 */
@property (nonatomic, copy) void (^moreButtonClickedBlock)(NSIndexPath *indexPath);
/** 其他 */
@property (nonatomic, copy) void (^otherButtonClickedBlock)(NSIndexPath *indexPath);
/** 关注与取消关注 */
@property (nonatomic, copy) void (^attentionViewClickedBlock)(UIImageView *attentionView);
/** 点赞 */
@property (nonatomic, copy) void (^praiseButtonClickedBlock)(void);
/** 评论 */
@property (nonatomic, copy) void (^commentButtonClickedBlock)(void);


/**
 是否隐藏关注
 */
- (void)setAttentionVIewisHiddden:(BOOL)hidden;

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
