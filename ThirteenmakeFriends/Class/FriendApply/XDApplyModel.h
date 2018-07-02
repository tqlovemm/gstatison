//
//  XDApplyModel.h
//  ThirteenmakeFriends
//
//  Created by 空谷凌虚 on 2018/5/21.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDApplyModel : NSObject

@property(nonatomic,assign) NSInteger is_returnable; //2：等待操作中；3：拒绝，4接受
@property(nonatomic,copy) NSString* gifts_img_url;
@property(nonatomic,copy) NSString* send_name;
@property(nonatomic,copy) NSString* send_username;
@property(nonatomic,copy) NSString* send_avatar_url;
@property(nonatomic,copy) NSString* created_at;
@property(nonatomic,assign) NSInteger applyId;

@end
