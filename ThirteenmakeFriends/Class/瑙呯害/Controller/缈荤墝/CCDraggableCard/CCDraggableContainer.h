//
//  CCDraggableContainer.h
//  CCDraggableCard-Master
//
//  Created by jzzx on 16/7/6.
//  Copyright © 2016年 Zechen Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CCDraggableConfig.h"
#import "CCDraggableCardView.h"
#import "CustomCardView.h"

extern CGFloat const flopDurationTime;

@class CCDraggableContainer;

//  -------------------------------------------------
//  MARK: Delegate
//  -------------------------------------------------

@protocol CCDraggableContainerDelegate <NSObject>

//- (void)draggableContainer:(CCDraggableContainer *)draggableContainer
//        draggableDirection:(CCDraggableDirection)draggableDirection
//                widthRatio:(CGFloat)widthRatio
//               heightRatio:(CGFloat)heightRatio;

- (void)draggableContainer:(CCDraggableContainer *)draggableContainer
                  cardView:(CCDraggableCardView *)cardView
           didCurrentIndex:(NSInteger)currentIndex
        draggableDirection:(CCDraggableDirection)draggableDirection
                widthRatio:(CGFloat)widthRatio
               heightRatio:(CGFloat)heightRatio;

- (void)draggableContainer:(CCDraggableContainer *)draggableContainer
                  cardView:(CCDraggableCardView *)cardView
            didSelectIndex:(NSInteger)didSelectIndex;

- (void)draggableContainer:(CCDraggableContainer *)draggableContainer
 finishedDraggableLastCard:(BOOL)finishedDraggableLastCard;


/**
 新增(喜欢或不喜欢)
 */
- (void)flopfinishedWithCardView:(UIView *)cardView didCurrentIndex:(NSInteger)currentIndex direction:(CCDraggableDirection)direction;

/**
 *  新增(增加喜欢不喜欢遮罩)
 */
- (void)draggableCardView:(CustomCardView *)draggableCardView
        draggableDirection:(CCDraggableDirection)draggableDirection
                widthRatio:(CGFloat)widthRatio
               heightRatio:(CGFloat)heightRatio;

@end

//  -------------------------------------------------
//  MARK: DataSource
//  -------------------------------------------------

@protocol CCDraggableContainerDataSource <NSObject>

@required
- (CCDraggableCardView *)draggableContainer:(CCDraggableContainer *)draggableContainer
                               viewForIndex:(NSInteger)index;

- (NSInteger)numberOfIndexs;

@end

//  -------------------------------------------------
//  MARK: CCDraggableContainer
//  -------------------------------------------------

@interface CCDraggableContainer : UIView

@property (nonatomic, weak) IBOutlet id <CCDraggableContainerDelegate>delegate;
@property (nonatomic, weak) IBOutlet id <CCDraggableContainerDataSource>dataSource;

@property (nonatomic) CCDraggableStyle     style;
@property (nonatomic) CCDraggableDirection direction;

- (instancetype)initWithFrame:(CGRect)frame style:(CCDraggableStyle)style;
- (void)removeFormDirection:(CCDraggableDirection)direction;
- (void)reloadData;

/**
 返回上一张卡片
 */
- (void)backToFrontCard;

@end
