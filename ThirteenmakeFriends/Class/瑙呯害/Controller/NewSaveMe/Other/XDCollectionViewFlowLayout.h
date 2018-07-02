//
//  XDCollectionViewFlowLayout.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/15.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICollectionViewLeftAlignedLayout.h"

@protocol XDCollectionViewDelegateFlowLayout <UICollectionViewDelegateFlowLayout>

- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout backgroundColorForSection:(NSInteger)section;

@end

@interface XDCollectionViewFlowLayout : UICollectionViewLeftAlignedLayout

@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *decorationViewAttrs;

@end
