//
//  XDLabelSelectController.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/12/14.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//  标签选择

#import "BaseViewController.h"

@protocol XDLabelSelectControllerDelegate <NSObject>

- (void)labelSelectDone:(NSString *)title usingArray:(NSArray *)usingArray;

@end

@interface XDLabelSelectController : BaseViewController

@property (nonatomic ,strong) NSMutableArray *usingArray;
@property (nonatomic ,strong) NSArray *allArray;

@property (nonatomic ,weak) id <XDLabelSelectControllerDelegate> delegate;

- (instancetype)initWithColumnArray:(NSMutableArray *)array allCloumn:(NSArray *)allArray;

@end
