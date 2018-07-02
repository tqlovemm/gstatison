//
//  XDUMSharedView.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/18.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UMSocialCore/UMSocialCore.h>

@protocol XDUMSharedViewDelegate <NSObject>
@optional

- (void)didSelectedToShare:(UMSocialPlatformType)clickedType;

@end

@interface XDUMSharedView : UIButton

@property (nonatomic, weak)id <XDUMSharedViewDelegate>delegate;

- (void)show;

@end
