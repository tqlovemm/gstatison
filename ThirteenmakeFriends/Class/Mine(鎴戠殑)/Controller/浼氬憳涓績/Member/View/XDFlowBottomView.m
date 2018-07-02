//
//  XDFlowBottomView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/14.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDFlowBottomView.h"
#import "XDCardModel.h"
#import "UIImageView+EMWebCache.h"

@interface XDFlowBottomView ()

@property (nonatomic, strong) NSMutableArray *memberViewsArray;

@property (nonatomic, strong) UIImageView *triangleView;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation XDFlowBottomView

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Override Methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initialize];
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)initialize {
    
}

- (NSMutableArray *)memberViewsArray {
    if (_memberViewsArray == nil) {
        _memberViewsArray = [NSMutableArray array];
    }
    return _memberViewsArray;
}

- (void)setItemsArray:(NSArray *)itemsArray {
    _itemsArray = itemsArray;
    
    CGFloat imgWH = 20;
    CGFloat imgMargin = (self.frame.size.width - itemsArray.count * imgWH) / (itemsArray.count + 1);
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(imgMargin, imgWH / 2, self.size.width - 2 * imgMargin, 1)];
    self.lineView.backgroundColor = RGB(230, 230, 230);
    [self addSubview:self.lineView];
    
    for (XDCardModel *felicityDic in itemsArray) {
        NSInteger index = [itemsArray indexOfObject:felicityDic];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imgMargin + ( imgMargin + imgWH) * index, 0, imgWH, imgWH)];
        [self addSubview:imageView];
        [self.memberViewsArray addObject:imageView];
    }
    
    self.triangleView = [[UIImageView alloc] initWithFrame:CGRectMake(imgMargin, self.frame.size.height-4, 6, 4)];
    self.triangleView.image = [UIImage imageNamed:@"white_triangle"];
    [self addSubview:self.triangleView];
    
    [self scrollToPage:0];
    
}

- (void)scrollToPage:(NSUInteger)pageNumber {
    if (pageNumber < self.itemsArray.count) {
        for (int index = 0; index < self.itemsArray.count; index++) {
            UIImageView *imgView = [self.memberViewsArray objectAtIndex:index];
            
            XDVipIconModel *iconModel = [self.itemsArray objectAtIndex:index];
            if (index == pageNumber) {
                
#if APP_Puppet  // Puppet
                [imgView sd_setImageWithURL:[NSURL URLWithString:iconModel.big_vipIcon] placeholderImage:[UIImage imageNamed:@"square_image_placeholder"]];
#elif APP_myPuppet
                switch (index) {
                    case 0:
                        imgView.image = [UIImage imageNamed:@"member_baoyue"];
                        break;
                    case 1:
                        imgView.image = [UIImage imageNamed:@"member_chuji"];
                        break;
                    case 2:
                        imgView.image = [UIImage imageNamed:@"member_gaoduan"];
                        break;
                    case 3:
                        imgView.image = [UIImage imageNamed:@"member_zhizun"];
                        break;
                    case 4:
                        imgView.image = [UIImage imageNamed:@"member_siren"];
                        break;
                        
                    default:
                        break;
                }
#else // 正常
                [imgView sd_setImageWithURL:[NSURL URLWithString:iconModel.big_vipIcon] placeholderImage:[UIImage imageNamed:@"square_image_placeholder"]];
#endif
            } else {
                [imgView sd_setImageWithURL:[NSURL URLWithString:iconModel.small_vipIcon] placeholderImage:[UIImage imageNamed:@"square_image_placeholder"]];
            }
        }
        
        CGFloat imgWH = 20;
        CGFloat imgMargin = (self.frame.size.width - self.itemsArray.count * imgWH) / (self.itemsArray.count + 1);
        self.triangleView.x = imgMargin + (imgMargin + imgWH) * pageNumber + 7;
    }
}

@end
