//
//  XDMsgCategoryModel.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/25.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDMsgCategoryModel.h"
#import "NSDate+Extension.h"

@implementation XDMsgCategoryModel

@end

@implementation XDNewMessageModel

- (NSString *)getMessageTimeWithCreate_at:(NSString *)created_at {
    NSInteger timestamp = [created_at integerValue];
    // 1.获得帖子的发送时间
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy年MM月dd日 HH:mm:ss";
    // 设置时区，因为中国和美国显示格式不一样，不设置的话下面的createDate会为空
    formatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
//    return [formatter stringFromDate:detaildate];
    NSString *currentStr = [formatter stringFromDate:detaildate];
    NSDate *createdDate = [formatter dateFromString:currentStr];
    
    NSString *timeStr = @"";
    // 2.判断帖子发送时间 和 现在时间的差距
    if(createdDate.isToday) { // 今天
        if(createdDate.deltaWithNow.hour >= 1) {
            timeStr = [NSString stringWithFormat:@"%ld小时前",createdDate.deltaWithNow.hour];
            return timeStr;
        } else if(createdDate.deltaWithNow.minute >= 1) {
            timeStr = [NSString stringWithFormat:@"%ld分钟前",createdDate.deltaWithNow.minute];
            return timeStr;
        } else {
            timeStr = @"刚刚";
            return timeStr;
        }
    } else if(createdDate.isYesterday) { // 昨天
        formatter.dateFormat = @"昨天 HH:mm";
        timeStr = [formatter stringFromDate:createdDate];
        return timeStr;
    } else if(createdDate.isThisYear) { // 今年
        formatter.dateFormat = @"MM-dd HH:mm";
        timeStr = [formatter stringFromDate:createdDate];
        return timeStr;
    } else { // 其他年份
        formatter.dateFormat = @"yyyy-MM-dd";
        timeStr = [formatter stringFromDate:createdDate];
        return timeStr;
    }
}

@end

@implementation XDNewMessageImageModel

- (NSInteger)width {
    if (_width == 0) {
        return 100;
    }
    return _width;
}

- (NSInteger)height {
    if (_height == 0) {
        return 100;
    }
    return _height;
}

@end

@implementation XDNewMessageGraphicModel

@end

@implementation XDNewMessageRemindModel

- (NSDictionary *)objectClassInArray {
    return @{@"kv":[XDNewMessageContentModel class]};
}

@end

@implementation XDNewMessageContentModel

@end

@implementation XDNewMessageComsumeModel

@end

@implementation XDNewMessageCardModel

@end
