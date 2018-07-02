//
//  XDPostTopModel.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/10/24.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDPostTopModel : NSObject

/** 点击跳转十三说文章详情的url */
@property (nonatomic, copy) NSString *url;

/** 标题 */
@property (nonatomic, copy) NSString *title;

/** 显示图片 */
@property (nonatomic, copy) NSString *wimg;

/** 文章类型 1.视频 2.教学 3.两性 4.故事 5.活动 */
@property (nonatomic, copy) NSString *wtype;

@end

@interface XDRecommendPersonModel : NSObject

/** 用户头像 */
@property (nonatomic, copy) NSString *avatar;

/** 用户名 */
@property (nonatomic, copy) NSString *username;

@end

@interface XDAcitivityModel : NSObject

/** 标签图片 */
@property (nonatomic, copy) NSString *img;

/** 标签名 */
@property (nonatomic, copy) NSString *tag_name;

/** 是否是最后一个 */
@property (nonatomic, assign, getter=isLasted) BOOL last;

@end
