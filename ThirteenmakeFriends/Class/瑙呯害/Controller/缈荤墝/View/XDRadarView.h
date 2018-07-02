//
//  XDRadarView.h
//  Miai13
//
//  Created by Xudongdong on 16/12/26.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//  自定义雷达动画

#import <UIKit/UIKit.h>

@interface XDRadarView : UIView

/*当前雷达中心缩略图*/
@property (nonatomic,strong)UIImage * thumbnailImage;

-(instancetype)initWithFrame:(CGRect)frame andThumbnail:(NSString *)thumbnailUrl andRaderColor:(UIColor *)raderColor;

@end
