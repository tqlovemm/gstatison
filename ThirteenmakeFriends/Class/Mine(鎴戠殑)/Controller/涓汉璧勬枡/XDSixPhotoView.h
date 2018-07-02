//
//  XDSixPhotoView.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/8/24.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XDSixPhotoViewDelegate <NSObject>

-(void)OnAddPhotoPress;

-(void)OnDeletePhotoPress : (NSInteger)tag;

@end

@interface XDSixPhotoView : UIView <UIGestureRecognizerDelegate>


@property (weak, nonatomic) id<XDSixPhotoViewDelegate> delegate;

-(instancetype)initWithData : (NSMutableArray *)imgArray;

/**
 * 获取新的排序
 */
-(NSMutableArray *)getNewOrder;

/**
 * 添加一张图片
 */
-(void)addImage : (UIImage *)image;

/**
 * 删除一张图片
 */
-(void)deleteImage : (int)tag;

/**
 * 替换一张图片
 */
-(void)replaceImage : (UIImage *)image
                tag : (int)tag;

@end
