//
//  ThirteenSayArticlesModel.m
//  ThirteenmakeFriends
//
//  Created by iOS on 16/5/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "ThirteenSayArticlesModel.h"

@implementation ThirteenSayArticlesModel

MJCodingImplementation

- (NSString *)created_at {
    if ([_created_at isKindOfClass:[NSNumber class]]) {
        NSDate *detaildate             = [NSDate dateWithTimeIntervalSince1970:[_created_at doubleValue]];
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
        dateFormatter.locale           = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
        _created_at = [dateFormatter stringFromDate: detaildate];
    }
    return _created_at;
}

- (void)setTitle:(NSString *)title {
    if (title) {
        _title = title;
        self.titleHeight = [title sizeWithFont:[UIFont systemFontOfSize:20] maxW:SCREEN_WIDTH - 20].height;
    }
}

- (void)setMiaoshu:(NSString *)miaoshu {
    if (miaoshu) {
        _miaoshu = miaoshu;
        self.contentHeight = [miaoshu sizeWithFont:[UIFont systemFontOfSize:12] maxW:SCREEN_WIDTH - 20].height;
    }
}

- (void)setContentHeight:(NSInteger)contentHeight {
    NSLog(@"%ld",(long)contentHeight);
    if (contentHeight) {
        _contentHeight = contentHeight;
        self.cellHeight += _contentHeight;
    }
}

- (void)setTitleHeight:(NSInteger)titleHeight {
    NSLog(@"%ld",(long)titleHeight);
    if (titleHeight) {
        _titleHeight = titleHeight;
        self.cellHeight += _titleHeight;
    }
}

- (NSString *)labelthumb {
    if ([_labelthumb isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return _labelthumb;
}

- (NSString *)sex {
    if ([_sex isKindOfClass:[NSNull class]]) {
        return @"0";
    }
    return _sex;
}

- (NSString *)avatar {
    if ([_avatar isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return _avatar;
}

- (NSString *)level {
    if ([_level isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return _level;
}

- (NSString *)nickname {
    if ([_nickname isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return _nickname;
}

@end
