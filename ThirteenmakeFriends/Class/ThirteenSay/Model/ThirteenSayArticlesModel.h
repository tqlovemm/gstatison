//
//  ThirteenSayArticlesModel.h
//  ThirteenmakeFriends
//
//  Created by iOS on 16/5/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThirteenSayArticlesModel : NSObject<NSCoding>

/*
 code:200 有数据
 created_id :创建者id
 Title：标题
 Wimg:描述图片
 Content:内容
 Wclick：点击数
 Wdianzan：点赞数
 Hot：1 火贴  2 不是火帖
 Wtype：分类
 Nickname：发布人
 Level：发布人会员等级
 Avatar：发布人头像
 Sex：发布人性别
 created_at：发布时间
 */
@property (nonatomic, assign) NSInteger created_id;
@property (nonatomic, copy) NSString *article_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *wimg;
@property (nonatomic, copy) NSString *miaoshu;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *wclick;
@property (nonatomic, copy) NSString *wdianzan; 
@property (nonatomic, copy) NSString *hot;
@property (nonatomic, copy) NSString *wtype;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *iscollection;
@property (nonatomic, copy) NSString *islike;
@property (nonatomic, copy) NSString *comment_count;
@property (nonatomic, copy) NSString *labelname;
@property (nonatomic, copy) NSString *labelthumb;
@property (nonatomic, copy) NSString *yuanchuang;//1 原创 2 非原创

@property (nonatomic, assign) NSInteger titleHeight;   // 标题高度
@property (nonatomic, assign) NSInteger contentHeight; // 描述高度
@property (nonatomic, assign) NSInteger cellHeight;    // cell高度


@end
