//
//  XDMatchCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/12/18.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDMatchCell.h"

@implementation XDMatchCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imgView = [[UIImageView alloc] init];
        [self addSubview:self.imgView];
        self.backgroundColor = [UIColor whiteColor];
    }return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes: layoutAttributes];
    self.imgView.frame = CGRectMake(0, 0, self.width, self.height);

}

@end
