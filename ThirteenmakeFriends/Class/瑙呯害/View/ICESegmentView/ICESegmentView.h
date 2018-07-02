//
//  ICESegmentView.h
//  ThirteenmakeFriends
//
//  Created by iOS on 13/3/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^IndexChangeBlock)(NSInteger index);

@interface ICESegmentView : UIView

@property (nonatomic, copy) IndexChangeBlock indexChangeBlock;
@property (nonatomic , strong) NSArray *sectionImages;
@property (nonatomic , strong) NSArray *sectionSelectedImages;

@end
