//
//  SendGiftsCell.m
//  ThirteenmakeFriends_myPuppet
//
//  Created by 谢超 on 2018/4/18.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "SendGiftsCell.h"

@implementation SendGiftsCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"SendGiftsCell" owner:self options:nil].lastObject;
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
