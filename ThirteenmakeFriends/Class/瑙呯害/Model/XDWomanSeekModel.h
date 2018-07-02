//
//  XDWomanSeekModel.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/11/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDWomanSeekModel : NSObject

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, copy) NSString *area_one;
@property (nonatomic, copy) NSString *area_two;
@property (nonatomic, copy) NSString *area_three;

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *des;

@property (nonatomic, strong) NSArray* mark;
@property (nonatomic, strong) NSArray* like_type;

@property (nonatomic, strong) NSArray* photos;

@property (nonatomic, assign) NSInteger photos_count;

@property (nonatomic, copy) NSString *thirteen_platform_number;

@property (nonatomic, assign) NSInteger vip;

@property (nonatomic, assign) NSInteger worth;

@end
