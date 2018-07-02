//
//  XDPostPraiseModel.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/5/15.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDPostPraiseModel : NSObject

@property (assign, nonatomic) NSInteger user_id;
@property (assign, nonatomic) NSInteger created_at;
@property (copy, nonatomic) NSString * nickname;
@property (copy, nonatomic) NSString * avatar;
@property (assign, nonatomic) NSInteger thread_count;
@property (copy, nonatomic) NSString * address;
@property (assign, nonatomic) NSInteger age;
@property (assign, nonatomic) NSInteger height;
@property (assign, nonatomic) NSInteger weight;

@end
