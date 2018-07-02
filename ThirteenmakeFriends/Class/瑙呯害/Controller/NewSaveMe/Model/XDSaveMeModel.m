//
//  XDSaveMeModel.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/3.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDSaveMeModel.h"
#import "MJExtension.h"

@implementation XDSaveMeModel

- (NSDictionary *)objectClassInArray {
    return @{@"signup":[XDSignUpModel class]};
}

- (NSString *)stringDatewithInterval:(NSInteger)timestamp {    
    // 1.获得帖子的发送时间
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 设置时区，因为中国和美国显示格式不一样，不设置的话下面的createDate会为空
    formatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    return [formatter stringFromDate:detaildate];
}

- (NSString *)stringDatewithEndInterval:(NSInteger)timestamp {
    NSDate *second = [NSDate date];
    long secondTimeZone = [second timeIntervalSince1970];
    
    if (secondTimeZone > timestamp) {
        return @"已过期";
    }
    
    // 1.获得帖子的发送时间
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    // 设置时区，因为中国和美国显示格式不一样，不设置的话下面的createDate会为空
    formatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    return [formatter stringFromDate:detaildate];
}

@end

@implementation XDSignUpModel

- (NSString *)stringDatewithInterval:(NSInteger)timestamp {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //获取此时时间戳长度
    NSTimeInterval nowTimeinterval = [[NSDate date] timeIntervalSince1970];
    int timeInt = nowTimeinterval - timestamp; //时间差
    
    int year = timeInt / (3600 * 24 * 30 *12);
    int month = timeInt / (3600 * 24 * 30);
    int day = timeInt / (3600 * 24);
    int hour = timeInt / 3600;
    int minute = timeInt / 60;
    if (year > 0) {
        return [NSString stringWithFormat:@"%d年以前",year];
    }else if(month > 0){
        return [NSString stringWithFormat:@"%d个月以前",month];
    }else if(day > 0){
        return [NSString stringWithFormat:@"%d天以前",day];
    }else if(hour > 0){
        return [NSString stringWithFormat:@"%d小时以前",hour];
    }else if(minute > 0){
        return [NSString stringWithFormat:@"%d分钟以前",minute];
    }else{
        return [NSString stringWithFormat:@"刚刚"];
    }
}

@end
