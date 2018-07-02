//
//  NSString+html.h
//  TestApi
//
//  Created by Xudongdong on 16/1/11.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (html)

/**
 *  去除字符串中的html标签
 */
+ (NSString *)filterHTML:(NSString *)html;
@end
