//
//  XDCardModel.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/11.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDCardModel.h"
#import "MJExtension.h"

@implementation XDCardModel

- (NSString *)vipIcon {
#if APP_Puppet  // Puppet
    return _vipIcon;
#elif APP_myPuppet
    switch (self.groupid) {
        case 1:
            _vipIcon = @"member_baoyue";
            break;
        case 2:
            _vipIcon = @"member_chuji";
            break;
        case 3:
            _vipIcon = @"member_gaoduan";
            break;
        case 4:
            _vipIcon = @"member_zhizun";
            break;
        case 5:
            _vipIcon = @"member_siren";
            break;
            
        default:
            break;
    }
    return _vipIcon;
#else // 正常
    return _vipIcon;
#endif
}

- (NSDictionary *)objectClassInArray {
    return @{@"memberShip":[XDMemberShipModel class]};
}

@end

@implementation XDMemberShipModel

@end

@implementation XDVipIconModel

@end
