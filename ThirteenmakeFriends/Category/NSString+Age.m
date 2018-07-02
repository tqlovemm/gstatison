//
//  NSString+Age.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/1/5.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "NSString+Age.h"

@implementation NSString (Age)

+ (NSString*)fromDateToAge:(NSDate*)date{
    
    NSDate *myDate = date;
    
    NSDate *nowDate = [NSDate date];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    unsigned int unitFlags = NSYearCalendarUnit;
    
    NSDateComponents *comps = [calendar components:unitFlags fromDate:myDate toDate:nowDate options:0];
    
    int year = [comps year];
    
    return [NSString stringWithFormat:@"%d",year];
}

@end
