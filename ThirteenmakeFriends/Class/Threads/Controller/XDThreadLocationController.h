//
//  XDThreadLocationController.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/9/27.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "BaseViewController.h"

@class XDThreadLocationController;

@protocol XDThreadLocationControllerDelegate <NSObject>

- (void)areaPickerController:(XDThreadLocationController *)areaSelectController didSelectLocation:(NSString *)location;

@end

@interface XDThreadLocationController : BaseViewController

@property (weak, nonatomic) id<XDThreadLocationControllerDelegate> delegate;

/** 传进来的地区 */
@property (copy, nonatomic) NSString * locArea;

@end
