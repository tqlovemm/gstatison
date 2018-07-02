//
//  XDMsgCategoryModel.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/25.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XDNewMessageModel,XDNewMessageImageModel,XDNewMessageGraphicModel,XDNewMessageRemindModel,XDNewMessageContentModel,XDNewMessageComsumeModel,XDNewMessageCardModel;

@interface XDMsgCategoryModel : NSObject

/** 类别id */
@property (nonatomic, assign) NSInteger entry_id;
/** 类别名 */
@property (nonatomic, copy) NSString *entry_name;
/** 类别图片 */
@property (nonatomic, copy) NSString *entry_image_url;
/** 类别未读消息数 */
@property (nonatomic, assign) NSInteger unread_count;

@property (nonatomic, strong) XDNewMessageModel *latest_news;

@end

@interface XDNewMessageModel : NSObject

/** 消息id */
@property (nonatomic, assign) NSInteger single_msg_id;
/** 类别id */
@property (nonatomic, assign) NSInteger entry_id;
/** 用户id */
@property (nonatomic, assign) NSInteger to_user_id;
/** 消息名 */
@property (nonatomic, copy) NSString *msg_title;
/** 消息描述 */
@property (nonatomic, copy) NSString *msg_description;
/** 消息类型 1文字，2图片，3图文t跳转消息，4语音，5视频。*/
@property (nonatomic, assign) NSInteger msg_type;
/** 消息模板 10模板消息模板，11纯文字模板，12可跳转链接文字模板，15心动币消费模板，16现金消费模板，21纯图片模板，31单图文模板，32多图文模板，35小名片模板 */
@property (nonatomic, assign) NSInteger template_id;
/** 消息跳转url */
@property (nonatomic, copy) NSString *msg_url;
/** 模板内容 */
@property (nonatomic, copy) NSString *extra;
/** 消息发送时间 */
@property (nonatomic, copy) NSString *created_at;
/** 是否已读  0未读，1已读*/
@property (nonatomic, copy) NSString *is_read;
/** 是否允许删除 */
@property (nonatomic, copy) NSString *is_allow_deleted;
/** 发送人图片url */
@property (nonatomic, copy) NSString *from_user_url;

@property (nonatomic, strong) XDNewMessageImageModel *imageModel;

@property (nonatomic, strong) XDNewMessageGraphicModel *graphicModel;

@property (nonatomic, strong) NSArray<XDNewMessageGraphicModel*> *graphicArray;

@property (nonatomic, strong) XDNewMessageRemindModel *remindModel;

@property (nonatomic, strong) XDNewMessageComsumeModel *comsumeModel;

@property (nonatomic, strong) XDNewMessageCardModel *cardModel;

- (NSString *)getMessageTimeWithCreate_at:(NSString *)created_at;

@end

@interface XDNewMessageImageModel : NSObject

/** 图片url */
@property (nonatomic, copy) NSString *img_url;
/** 图片宽度 */
@property (nonatomic, assign) NSInteger width;
/** 图片高度 */
@property (nonatomic, assign) NSInteger height;

@end

@interface XDNewMessageGraphicModel : NSObject

/** 图片url */
@property (nonatomic, copy) NSString *img_url;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 描述 */
@property (nonatomic, copy) NSString *des;
/** 跳转链接 */
@property (nonatomic, copy) NSString *url;

@end

@interface XDNewMessageRemindModel : NSObject
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 一级描述 */
@property (nonatomic, copy) NSString *first;
/** 内容描述 */
@property (nonatomic, copy) NSString *remark;

@property (nonatomic, strong) NSArray<XDNewMessageContentModel *> *kv;
/** 跳转url */
@property (nonatomic, copy) NSString *url;

@end

@interface XDNewMessageContentModel : NSObject
/** key */
@property (nonatomic, copy) NSString *key;
/** value */
@property (nonatomic, copy) NSString *value;

@end

@interface XDNewMessageComsumeModel : NSObject

/** 名称 */
@property (nonatomic, copy) NSString *title;
/** 金额 */
@property (nonatomic, copy) NSString *sum;
/** 描述 */
@property (nonatomic, copy) NSString *des;
/** 图片url */
@property (nonatomic, copy) NSString *img_url;
/** 跳转url */
@property (nonatomic, copy) NSString *url;

@end

@interface XDNewMessageCardModel : NSObject

/** 图片url */
@property (nonatomic, copy) NSString *img_url;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 描述 */
@property (nonatomic, copy) NSString *des;
/** 跳转链接 */
@property (nonatomic, copy) NSString *url;
/** 跳转该用户的user_id */
@property (nonatomic, assign) NSInteger user_id;

@end



