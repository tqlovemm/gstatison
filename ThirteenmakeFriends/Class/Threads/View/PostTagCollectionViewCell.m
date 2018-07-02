//
//  PostTagCollectionViewCell.m
//  ThirteenmakeFriends
//
//  Created by iOS on 27/3/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "PostTagCollectionViewCell.h"

@implementation PostTagCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"PostTagCollectionViewCell" owner:self options:nil]lastObject];
    }
    return self;
}
@end
