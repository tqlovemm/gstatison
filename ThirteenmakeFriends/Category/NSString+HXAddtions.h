//
//  NSString+HXAddtions.h
//  json
//
//  Created by jiangpei on 15/5/5.
//  Copyright (c) 2015年 JiangPei. All rights reserved.
//  相应对象 转换成 json 字符串

#import <Foundation/Foundation.h>

@interface NSString (HXAddtions)

+ (NSString *)jsonStringWithDictionary:(NSDictionary *)dictionary;

+ (NSString *)jsonStringWithArray:(NSArray *)array;

+ (NSString *)jsonStringWithString:(NSString *) string;

+ (NSString *)jsonStringWithObject:(id) object;


/**
 将NSString转化为NSArray或者NSDictionary

 @return 字典或数组
 */
- (id)JsonToArrayOrNSDictionary;

@end
