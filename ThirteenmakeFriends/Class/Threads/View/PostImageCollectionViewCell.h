//
//  PostImageCollectionViewCell.h
//  ThirteenmakeFriends
//
//  Created by iOS on 23/3/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CancleBlock)(void);

@interface PostImageCollectionViewCell : UICollectionViewCell
@property (nonatomic , copy) CancleBlock cancleBlock;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewPic;
@property (weak, nonatomic) IBOutlet UIButton *btnCancle;
@property (weak, nonatomic) IBOutlet UIImageView *imgCancle;

- (IBAction)didPressedToCancle:(UIButton *)sender;

@end
