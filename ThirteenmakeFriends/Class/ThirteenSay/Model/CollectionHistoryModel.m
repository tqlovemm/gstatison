//
//  CollectionHistoryModel.m
//  ThirteenmakeFriends
//
//  Created by iOS on 23/5/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "CollectionHistoryModel.h"

@implementation CollectionHistoryModel
@synthesize collection_created_at;

- (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"collectID" : @"id"
             };
}

- (NSString *)collection_created_at {
    if ([collection_created_at isKindOfClass:[NSNumber class]]) {
        NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:[collection_created_at doubleValue]];
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
        dateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
        
        collection_created_at = [dateFormatter stringFromDate: detaildate];

    }
    return collection_created_at;
}

@end
