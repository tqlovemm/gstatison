//
//  XDPostModel.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/3/23.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XDPostLikeItemModel,XDPostCommentItemModel,XDPhotoModel;

@interface XDPostModel : NSObject<NSCoding>

//! 未读消息id
@property (nonatomic, assign) NSInteger mid;
//! 未读消息文字内容
@property (nonatomic, copy) NSString *unreadContent;

//! 是否关注 1.已关注 0.未关注
@property (nonatomic, assign) BOOL follow;
//! 帖子id
@property (nonatomic, copy) NSString *wid;
//! 发帖用户的id
@property (nonatomic, copy) NSString *user_id;
//! 头像
@property (nonatomic, copy) NSString *avatar;
//! 昵称
@property (nonatomic, copy) NSString *nickname;
//! 性别
@property (nonatomic, assign) NSInteger sex;
//! 会员等级
@property (nonatomic, assign) NSInteger groupid;
/** 是否认证 0 未认证 1 认证成功 2 认证失败 3审核中 */
@property (nonatomic,assign) NSInteger is_renzheng;
//! 文字内容
@property (nonatomic, copy) NSString *content;
//! 1.置顶 0.不置顶
@property (nonatomic, assign) NSInteger is_top;
//! 0/正常帖子，1/广告，2/版规
@property (nonatomic, assign) NSInteger type;
//! 配图
@property (nonatomic, strong) NSArray <XDPhotoModel *>*imgItemsArray;
//! 话题
@property (nonatomic, copy) NSString *tag;
//! 位置
@property (nonatomic, copy) NSString *address;
//! 是否喜欢
@property (nonatomic, assign, getter = isLiked) BOOL liked;
//! 创建时间
@property (copy, nonatomic) NSString * created_at;
//! 点赞数
@property (nonatomic, assign) int likeCount;
//! 评论数
@property (nonatomic, assign) int commentCount;
//! 点赞的人数组
@property (nonatomic, strong) NSMutableArray<XDPostLikeItemModel *> *likeItemsArray;
//! 评论的人数组
@property (nonatomic, strong) NSMutableArray<XDPostCommentItemModel *> *commentItemsArray;
//! 是否展开
@property (nonatomic, assign) BOOL isOpening;
//! 是否显示更多按钮
@property (nonatomic, assign, readonly) BOOL shouldShowMoreButton;

@end

@interface XDPostLikeItemModel : NSObject<NSCoding>
//! 昵称
@property (nonatomic, copy) NSString *nickname;
//! 头像
@property (nonatomic, copy) NSString *avatar;
//! 用户id
@property (nonatomic, copy) NSString *user_id;
//!
@property (nonatomic, copy) NSAttributedString *attributedContent;

@end


@interface XDPostCommentItemModel : NSObject<NSCoding>
//! 评论id
@property (nonatomic, copy) NSString *comment_id;
//! 评论内容
@property (nonatomic, copy) NSString *comment;
//! 昵称
@property (nonatomic, copy) NSString *firstName;
//! 头像
@property (nonatomic, copy) NSString *firstUrl;
//! id
@property (nonatomic, copy) NSString *first_id;
//! 评论时间
@property (copy, nonatomic) NSString *created_at;

@property (nonatomic, copy) NSString *secondName;
@property (nonatomic, copy) NSString *secondUrl;
@property (nonatomic, copy) NSString *second_id;

@property (nonatomic, copy) NSAttributedString *attributedContent;

@end
