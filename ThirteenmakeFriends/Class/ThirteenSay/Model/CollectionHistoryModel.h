//
//  CollectionHistoryModel.h
//  ThirteenmakeFriends
//
//  Created by iOS on 23/5/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionHistoryModel : NSObject

//{
//    "article_created_at" = 1493864378;
//    "article_id" = 1;
//    "collection_created_at" = 1495525008;
//    id = 1;
//    miaoshu = dasdsada;
//    title = "\U6807\U9898";
//    wimg = "http://omsnqyd5g.bkt.clouddn.com/uploads/qinhua/2017/05/04/590a8fb985f07_2614204f51629b9377b0bad6e39fe41a";
//}

@property (nonatomic, copy) NSString *article_created_at;
@property (nonatomic, copy) NSString *article_id;
@property (nonatomic, copy) NSString *collection_created_at;
@property (nonatomic, copy) NSString *miaoshu;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *wimg;
@property (nonatomic, copy) NSString *collectID;
@property (nonatomic, copy) NSString *islike;
@property (nonatomic, copy) NSString *like_count;
@property (nonatomic, copy) NSString *url;

@end
