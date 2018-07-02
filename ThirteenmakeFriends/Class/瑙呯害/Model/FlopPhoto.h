//
//  FlopPhoto.h
//  翻牌
//
//  Created by Xudongdong on 16/3/31.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlopPhoto : NSObject<NSCoding>
/**
 *  图片url地址
 */
@property (copy, nonatomic) NSString * path;

//! 翻牌id
@property (copy, nonatomic) NSString * flop_content_id;


/**
 专属图片url
 */
@property (copy, nonatomic) NSString * img_path;

@end
