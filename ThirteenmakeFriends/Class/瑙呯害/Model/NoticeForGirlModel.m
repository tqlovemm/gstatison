//
//  NoticeForGirlModel.m
//  ThirteenmakeFriends
//
//  Created by iOS on 26/4/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "NoticeForGirlModel.h"

@implementation NoticeForGirlModel

- (NSString *)created_at {
    if ([_created_at isKindOfClass:[NSNumber class]]) {
        NSDate *detaildate             = [NSDate dateWithTimeIntervalSince1970:[_created_at doubleValue]];
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy.MM.dd HH:mm"];
        dateFormatter.locale           = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
        _created_at = [dateFormatter stringFromDate: detaildate];
    }
    return _created_at;
}

@end
