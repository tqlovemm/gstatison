//
//  TopupZsCollectionViewCell.m
//  ThirteenmakeFriends_myPuppet
//
//  Created by 谢超 on 2018/4/12.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "TopupZsCollectionViewCell.h"

@implementation TopupZsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"TopupZsCollectionViewCell" owner:self options:nil].lastObject;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
