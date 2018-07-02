//
//  XDPostModel.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/3/23.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDPostModel.h"
#import "MJExtension.h"
#import "NSDate+Extension.h"
#import "XDPhotoModel.h"

extern const CGFloat postcontentLabelFontSize;
extern CGFloat maxpostContentLabelHeight;

@implementation XDPostModel
{
    CGFloat _lastContentWidth;
}

@synthesize content = _content;

MJCodingImplementation

- (NSString *)created_at {
    
    if ([_created_at isKindOfClass:[NSString class]]) {
        return _created_at;
    } else if ([_created_at isKindOfClass:[NSNull class]]) {
        return nil;
    } else {
        // 1.获得帖子的发送时间
        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:[_created_at integerValue]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        // 设置时区，因为中国和美国显示格式不一样，不设置的话下面的createDate会为空
        formatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
        NSString *currentStr = [formatter stringFromDate:detaildate];
        NSDate *createdDate = [formatter dateFromString:currentStr];
        
        // 2.判断帖子发送时间 和 现在时间的差距
        if(createdDate.isToday) { // 今天
            if(createdDate.deltaWithNow.hour >= 1) {
                _created_at = [NSString stringWithFormat:@"%ld小时前",createdDate.deltaWithNow.hour];
                return _created_at;
            } else if(createdDate.deltaWithNow.minute >= 1) {
                _created_at = [NSString stringWithFormat:@"%ld分钟前",createdDate.deltaWithNow.minute];
                return _created_at;
            } else {
                _created_at = @"刚刚";
                return _created_at;
            }
        } else if(createdDate.isYesterday) { // 昨天
            formatter.dateFormat = @"昨天 HH:mm";
            _created_at = [formatter stringFromDate:createdDate];
            return _created_at;
        } else if(createdDate.isThisYear) { // 今年
            formatter.dateFormat = @"MM-dd";
            _created_at = [formatter stringFromDate:createdDate];
            return _created_at;
        } else { // 其他年份
            formatter.dateFormat = @"yyyy-MM-dd";
            _created_at = [formatter stringFromDate:createdDate];
            return _created_at;
        }
    }
}

- (void)setContent:(NSString *)content
{
    _content = content;
}

- (NSString *)content
{
    if ([_content isEqual:[NSNull null]]) {
        return nil;
    } else {
        // 隐藏展开全文
        CGFloat contentW = [UIScreen mainScreen].bounds.size.width - 20;
        if (contentW != _lastContentWidth) {
            _lastContentWidth = contentW;
            CGRect textRect = [_content boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:postcontentLabelFontSize]} context:nil];
            if (textRect.size.height > maxpostContentLabelHeight) {
                _shouldShowMoreButton = YES;
            } else {
                _shouldShowMoreButton = NO;
            }
        }
        
        return _content;
    }
}

// 隐藏展开全文
- (void)setIsOpening:(BOOL)isOpening
{
    if (!_shouldShowMoreButton) {
        _isOpening = NO;
    } else {
        _isOpening = isOpening;
    }
}

- (NSDictionary *)objectClassInArray {
    return @{@"commentItemsArray":[XDPostCommentItemModel class],
             @"likeItemsArray":[XDPostLikeItemModel class],
             @"imgItemsArray":[XDPhotoModel class]};
}

- (NSString *)tag {
    if ([_tag isEqual:[NSNull null]]) {
        _tag = nil;
    }
    return _tag;
}

- (NSString *)address {
    if ([_address isEqual:[NSNull null]]) {
        _address = nil;
    }
    return _address;
}

- (NSString *)nickname {
    if ([_nickname isEqual:[NSNull null]]) {
        return nil;
    }
    return _nickname;
}

- (NSString *)avatar {
    if ([_avatar isEqual:[NSNull null]]) {
        return nil;
    }
    return _avatar;
}

@end

@implementation XDPostLikeItemModel
MJCodingImplementation

- (NSString *)nickname {
    if ([_nickname isEqual:[NSNull null]]) {
        return nil;
    }
    return _nickname;
}

- (NSString *)avatar {
    if ([_avatar isEqual:[NSNull null]]) {
        return nil;
    }
    return _avatar;
}

@end

@implementation XDPostCommentItemModel

MJCodingImplementation
- (NSString *)created_at {
    
    // 1.获得帖子的发送时间
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:[_created_at integerValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 设置时区，因为中国和美国显示格式不一样，不设置的话下面的createDate会为空
    formatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    NSString *currentStr = [formatter stringFromDate:detaildate];
    NSDate *createdDate = [formatter dateFromString:currentStr];
    
    // 2.判断帖子发送时间 和 现在时间的差距
    if(createdDate.isToday) { // 今天
        if(createdDate.deltaWithNow.hour >= 1) {
            return [NSString stringWithFormat:@"%ld小时前",createdDate.deltaWithNow.hour];
        } else if(createdDate.deltaWithNow.minute >= 1) {
            return [NSString stringWithFormat:@"%ld分钟前",createdDate.deltaWithNow.minute];
        } else {
            return @"刚刚";
        }
    } else if(createdDate.isYesterday) { // 昨天
        formatter.dateFormat = @"昨天 HH:mm";
        return [formatter stringFromDate:createdDate];
    } else if(createdDate.isThisYear) { // 今年
        formatter.dateFormat = @"yyyy-MM-dd";
        return [formatter stringFromDate:createdDate];
    } else { // 其他年份
        formatter.dateFormat = @"yyyy-MM-dd";
        return [formatter stringFromDate:createdDate];
    }
}

- (NSString *)firstUrl {
    if ([_firstUrl isEqual:[NSNull null]]) {
        return nil;
    }
    return _firstUrl;
}

- (NSString *)firstName {
    if ([_firstName isEqual:[NSNull null]]) {
        return nil;
    }
    return _firstName;
}

@end
