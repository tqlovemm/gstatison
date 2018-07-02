//
//  Seek.m
//  觅约-seek-
//
//  Created by Xudongdong on 16/3/18.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "Seek.h"
#import "MJExtension.h"
#import "FlopPhoto.h"

@implementation Seek

MJCodingImplementation

- (NSDictionary *)objectClassInArray
{
    return @{@"seekPicture" : [FlopPhoto class],@"chatImg" : [FlopPhoto class]};
}

/**
 *  模型的idstr属性存储的是字典中的id属性
 */
- (NSDictionary *)replacedKeyFromPropertyName { // 模型的idstr属性对应着字典中的id属性
    return @{@"girlNum" : @"thirteen_platform_number",
             @"area" : @"area_one",
             @"publishDate" : @"created_at",
             @"girlHeadIcon" : @"avatar",
             @"datingRequire" : @"make_friend",
             @"girlLabel" : @"mark",
             @"seekPicture" : @"photos"
             };
}

- (NSString *)updated_at {
    if ([_updated_at isKindOfClass:[NSNumber class]]) {
        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:[_updated_at doubleValue]];
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        dateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
        
        _updated_at = [dateFormatter stringFromDate: detaildate];
    }
    return _updated_at;
}

- (NSString *)girlHeadIcon {
    if ([_girlHeadIcon isEqual:[NSNull null]]) {
        _girlHeadIcon = nil;
    }
    return _girlHeadIcon;
}

- (NSString *)introduction {
    if ([_introduction isEqual:[NSNull null]]) {
        _introduction = nil;
    }
    return _introduction;
}

- (NSString *)area_two {
    if ([_area_two isKindOfClass:[NSNull class]]) {
        _area_two = nil;
    }
    return _area_two;
}

- (NSString *)area_three {
    if ([_area_three isKindOfClass:[NSNull class]]) {
        _area_three = nil;
    }
    return _area_three;
}

@end
