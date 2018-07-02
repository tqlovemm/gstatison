//
//  XDCollectionReusableView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/15.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDCollectionReusableView.h"
#import "XDCollectionViewLayoutAttributes.h"

@implementation XDCollectionReusableView

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];
    if ([layoutAttributes isKindOfClass:[XDCollectionViewLayoutAttributes class]]) {
        XDCollectionViewLayoutAttributes *attr = (XDCollectionViewLayoutAttributes *)layoutAttributes;
        self.backgroundColor = attr.backgroundColor;
    }
}

@end
