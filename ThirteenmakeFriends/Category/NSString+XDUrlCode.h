//
//  NSString+XDUrlCode.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/11/9.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XDUrlCode)

//URLEncode
+(NSString*)encodeString:(NSString*)unencodedString;

//URLDEcode
+(NSString *)decodeString:(NSString*)encodedString;

@end
