//
//  Notice.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/4/21.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "Notice.h"
#import "NSDate+Extension.h"

@implementation Notice

- (NSString *)getCreateTime {
    
    NSString *create = @"";
    
    // 1.获得帖子的发送时间
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:_created_at];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 设置时区，因为中国和美国显示格式不一样，不设置的话下面的createDate会为空
    formatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    NSString *currentStr = [formatter stringFromDate:detaildate];
    NSDate *createdDate = [formatter dateFromString:currentStr];
    
    // 2.判断帖子发送时间 和 现在时间的差距
    if(createdDate.isToday) { // 今天
        if(createdDate.deltaWithNow.hour >= 1) {
            create = [NSString stringWithFormat:@"%ld小时前",createdDate.deltaWithNow.hour];
            return create;
        } else if(createdDate.deltaWithNow.minute >= 1) {
            create = [NSString stringWithFormat:@"%ld分钟前",createdDate.deltaWithNow.minute];
            return create;
        } else {
            create = @"刚刚";
            return create;
        }
    } else if(createdDate.isYesterday) { // 昨天
        formatter.dateFormat = @"昨天 HH:mm";
        create = [formatter stringFromDate:createdDate];
        return create;
    } else if(createdDate.isThisYear) { // 今年
        formatter.dateFormat = @"MM-dd";
        create = [formatter stringFromDate:createdDate];
        return create;
    } else { // 其他年份
        formatter.dateFormat = @"yyyy-MM-dd";
        create = [formatter stringFromDate:createdDate];
        return create;
    }
}

- (NSString *)response {
    if ([_response isEqual:[NSNull null]]) {
        return nil;
    }
    return _response;
}

-(instancetype)init {
    if (self = [super init]) {
        _push_id = 0;
        _title = @"";
        _msg = @"";
        _cid = @"";
        _status = 0;
        _created_at = @"";
        _is_read = 0;
        _icon = @"";
    }
    return self;
}

@end
