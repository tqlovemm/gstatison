//
//  XDReportPostModel.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/5/4.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDReportPostModel : NSObject

/** 举报选项id */
@property (assign, nonatomic) NSInteger report_id;

/** 举报内容 */
@property (copy, nonatomic) NSString * content;

@end
