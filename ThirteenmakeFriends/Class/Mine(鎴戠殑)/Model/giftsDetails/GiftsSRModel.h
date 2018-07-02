//
//  GiftsSRModel.h
//  ThirteenmakeFriends
//
//  Created by 空谷凌虚 on 2018/6/4.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GiftsSRModel : NSObject


@property(nonatomic,assign)NSInteger gifts_id;
@property(nonatomic,copy)NSString *created_at;
@property(nonatomic,copy)NSString *gifts_img_url;
@property(nonatomic,copy)NSString *receive_avatar_url;
@property(nonatomic,copy)NSString *receive_name;
@property(nonatomic,copy)NSString *send_avatar_url;
@property(nonatomic,copy)NSString *send_name;

@end
