//
//  XDPhotoModel.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/3/23.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDPhotoModel : NSObject<NSCoding>

@property (assign, nonatomic) NSInteger img_id;

@property (assign, nonatomic) NSInteger thread_id;

@property (copy, nonatomic) NSString * img_path;

@property (assign, nonatomic) NSInteger img_width;

@property (assign, nonatomic) NSInteger img_height;

@end
