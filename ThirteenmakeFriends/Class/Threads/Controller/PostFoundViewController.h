//
//  PostFoundViewController.h
//  ThirteenmakeFriends
//
//  Created by iOS on 23/3/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface PostFoundViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;;

/**
 帖子发送完成
 */
@property (copy, nonatomic) void (^sendPostSuccessBlock)(void);
@end
