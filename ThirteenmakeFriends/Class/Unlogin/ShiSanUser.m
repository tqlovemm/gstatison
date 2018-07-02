//
//  ShiSanUser.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 15/12/22.
//  Copyright © 2015年 ThirtyOneDay. All rights reserved.
//

#import "ShiSanUser.h"
#import "MJExtension.h"

@implementation ShiSanUser

MJCodingImplementation

+ (id)sharedUser {
    return [[self alloc]init];
}

- (NSString *)groupid {
    if ([_groupid isEqual:[NSNull null]]) {
        _groupid = nil;
    }
    return _groupid;
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

- (NSString *)nickname {
    if (_nickname != nil && ![_nickname isEqualToString:@""]) {
        return _nickname;
    }
    return _username;
}

- (NSString *)avatar {
    if ([_avatar isEqual:[NSNull null]]) {
        return nil;
    }
    return _avatar;
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

- (NSString *)signature {
    if ([_signature isEqual:[NSNull null]]) {
        _signature = nil;
    }
    return _signature;
}

- (NSArray *)received_gifts {
    if ([_received_gifts isEqual:[NSNull null]]) {
        _received_gifts = nil;
    }
    return _received_gifts;
}



/**
 *  将传入的模型对象的属性 更新
 */
- (void)replaceProperties:(ShiSanUser *)receivedUserInfo {
    u_int count;
    objc_property_t *properties  = class_copyPropertyList([self class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++)
    {
        const char* propertyName = property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    
    for (NSString *propertyName in propertiesArray) {
        id receivedPropertyValue = [receivedUserInfo valueForKey:(NSString *)propertyName];
        // 新的模型对象属性 替换
        [self setValue:receivedPropertyValue forKey:propertyName];
    }
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
