//
//  ProfileUser.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/1/11.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "ProfileUser.h"
#import "MJExtension.h"

@implementation ProfileUser
MJCodingImplementation

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static ProfileUser *instance;

    // dispatch_once是线程安全的，onceToken默认为0
    static dispatch_once_t onceToken;
    // dispatch_once宏可以保证块代码中的指令只会被执行一次
    dispatch_once(&onceToken, ^{
        // 永远只执行一次，instance只会被实例化一次
        instance = [super allocWithZone:zone];
    });

    return instance;
}

+ (id)sharedUser {
    return [[self alloc]init];
}

- (NSString *)nickname {
    if (_nickname != nil && ![_nickname isEqualToString:@""]) {
        return _nickname;
    }
    return _username;
}

- (NSString *)user_id {
    if ([_user_id isKindOfClass:[NSNumber class]]) {
        return _user_id = [NSString stringWithFormat:@"%@",_user_id];
    }
    return _user_id;
}

- (NSString *)birthdate {
    if ([_birthdate isEqual:[NSNull null]] || [_birthdate isEqualToString:@""]) {
        _birthdate = nil;
    }
    return _birthdate;
}

- (NSString *)area_one {
    if ([_area_one isEqual:[NSNull null]] || [_area_one isEqualToString:@""]) {
        _area_one = nil;
    }
    return _area_one;
}

- (NSString *)area_two {
    if ([_area_two isEqual:[NSNull null]] || [_area_two isEqualToString:@""]) {
        _area_two = nil;
    }
    return _area_two;
}

- (NSString *)area_three {
    if ([_area_three isEqual:[NSNull null]] || [_area_three isEqualToString:@""]) {
        _area_three = nil;
    }
    return _area_three;
}

- (NSString *)signature {
    if ([_signature isEqual:[NSNull null]]) {
        _signature = nil;
    }
    return _signature;
}

- (NSString *)height {
    if ([_height isEqual:[NSNull null]] || [_height isEqualToString:@""]) {
        _height = @"0";
    }
    return _height;
}

- (NSString *)weight {
    if ([_weight isEqual:[NSNull null]] || [_weight isEqualToString:@""]) {
        _weight = @"0";
    }
    return _weight;
}

//- (NSString *)address {
//    if ([_address isEqual:[NSNull null]]) {
//        _address = nil;
//    }
//    return _address;
//}

- (NSString *)cellphone {
    if ([_cellphone isEqual:[NSNull null]]) {
        _cellphone = nil;
    }
    return _cellphone;
}

- (NSString *)email {
    if ([_email isEqual:[NSNull null]]) {
        _email = nil;
    }
    return _email;
}

- (NSString *)sex {
    if ([_sex isEqual:[NSNull null]]) {
        _sex = nil;
    }

    return _sex;
}

- (NSString *)follower_count {
    if ([_follower_count isEqual:[NSNull null]]) {
        _follower_count = @"0";
    }
    return _follower_count;
}

- (NSString *)following_count {
    if ([_following_count isEqual:[NSNull null]]) {
        _following_count = @"0";
    }
    return _following_count;
}

- (NSString *)thread_count {
    if ([_thread_count isEqual:[NSNull null]]) {
        _thread_count = @"0";
    }
    return _thread_count;
}

- (NSArray *)make_friend {
    if ([_make_friend isEqual:[NSNull null]]) {
        _make_friend = nil;
    }
    return _make_friend;
}

- (NSArray *)mark {
    if ([_mark isEqual:[NSNull null]]) {
        _mark = nil;
    }
    return _mark;
}

- (NSArray *)hobby {
    if ([_hobby isEqual:[NSNull null]]) {
        _hobby = nil;
    }
    return _hobby;
}

- (NSString *)is_marry {
    if ([_is_marry isEqual:[NSNull null]]) {
        _is_marry = nil;
    } else if ([_is_marry isEqualToString:@"0"]) {
        _is_marry = @"单身";
    } else if ([_is_marry isEqualToString:@"1"]) {
        _is_marry = @"有男/女朋友";
    } else if ([_is_marry isEqualToString:@"2"]) {
        _is_marry = @"已婚";
    } else if ([_is_marry isEqualToString:@"3"]) {
        _is_marry = @"保密";
    }
    return _is_marry;
}

- (NSArray *)photos {
    if ([_photos isEqual:[NSNull null]]) {
        _photos = nil;
    }
    return _photos;
}

- (void)setNilValueForKey:(NSString *)key {
    if ([key isEqualToString:@"is_renzheng"]) {
        _is_renzheng = 0;
    } else if ([key isEqualToString:@"education"]) {
        _education = 0;
    } else if ([key isEqualToString:@"annual_salary"]) {
        _annual_salary = 0;
    } else if ([key isEqualToString:@"diamonds"]) {
        _diamonds = 0;
    } else {
        [super setNilValueForKey:key];
    }
}

- (NSString *)thirteen_platform_number {
    if ([_thirteen_platform_number isEqual:[NSNull null]]) {
        _thirteen_platform_number = nil;
    }
    return _thirteen_platform_number;
}

/** 获取会员名称 */
- (NSString *)getMemberName {
    if ([self.groupid integerValue] == 1) { // 会员等级判断
        return @"包月会员";
    } else if ([self.groupid integerValue] == 2) {
        return @"初级会员";
    } else if ([self.groupid integerValue] == 3) {
        return @"高端会员";
    } else if ([self.groupid integerValue] == 4) {
        return @"至尊会员";
    } else if ([self.groupid integerValue] == 5) {
        return @"私人至尊";
    } else if ([self.groupid integerValue] == 0) {
        return @"非会员";
    } else {
        return @"未知等级";
    }
}

/** 获取最高学历 */
- (NSString *)getHighestEducation {
    NSString *education = nil;
    switch (self.education) {
        case 1:
            education = @"初中及以下";
            break;
        case 2:
            education = @"高中";
            break;
        case 3:
            education = @"大专";
            break;
        case 4:
            education = @"本科";
            break;
        case 5:
            education = @"研究生";
            break;
        case 6:
            education = @"博士及以上";
            break;
        default:
            break;
    }
    return education;
}

/** 获取收入 */
- (NSString *)getPersonIncome {
    NSString *education = nil;
    switch (self.annual_salary) {
        case 1:
            education = @"10万以下";
            break;
        case 2:
            education = @"10-20万";
            break;
        case 3:
            education = @"20-50万";
            break;
        case 4:
            education = @"50-100万";
            break;
        case 5:
            education = @"100-500万";
            break;
        case 6:
            education = @"500万以上";
            break;
        default:
            break;
    }
    return education;
}

@end
