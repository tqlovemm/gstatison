//
//  NoticeCollectionViewCell.m
//  ThirteenmakeFriends
//
//  Created by iOS on 24/3/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "NoticeCollectionViewCell.h"

@implementation NoticeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"NoticeCollectionViewCell" owner:self options:nil] lastObject];
    }
    return self;
}
@end
