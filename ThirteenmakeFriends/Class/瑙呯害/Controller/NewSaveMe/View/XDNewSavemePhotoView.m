//
//  XDNewSavemePhotoView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/8.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDNewSavemePhotoView.h"
#import "UIImageView+WebCache.h"
#import "XDPhotoBrowser.h"

#define margin 10
#define XDPostPhotosMaxCount 3
#define photoMargin 6
#define kContent_width (SCREEN_WIDTH - 2 * margin)

@implementation XDNewSavemePhotoView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    // 预先创建9个图片控件
    for (int i = 0; i<XDPostPhotosMaxCount; i++) {
        UIImageView *photoView = [[UIImageView alloc] init];
        photoView.clipsToBounds = YES;
        photoView.backgroundColor = [UIColor whiteColor];
        photoView.userInteractionEnabled = YES;
        photoView.contentMode = UIViewContentModeScaleAspectFill;
        photoView.tag = i;
        [self addSubview:photoView];
        
        // 添加手势监听器（一个手势监听器 只能 监听对应的一个view）
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
        [recognizer addTarget:self action:@selector(tapImageView:)];
        [photoView addGestureRecognizer:recognizer];
    }
}

- (void)setPic_urls:(NSArray *)pic_urls {
    _pic_urls = pic_urls;
    
    pic_urls = pic_urls.count > XDPostPhotosMaxCount ? [pic_urls subarrayWithRange:NSMakeRange(0, XDPostPhotosMaxCount)] : pic_urls;
    
    for (int i = 0; i<XDPostPhotosMaxCount; i++) {
        UIImageView *photoView = self.subviews[i];
        
        if (i < pic_urls.count) { // 显示图片
            NSString *photo = pic_urls[i];
            [photoView sd_setImageWithURL:[NSURL URLWithString:photo] placeholderImage:[UIImage imageNamed:@"square_image_placeholder"]];
            photoView.hidden = NO;
        } else { // 隐藏
            photoView.hidden = YES;
        }
    }
    
    /*! 图片创建 */
    CGFloat itemW = 86;
    CGFloat itemH = 86;
    if (self.pic_urls.count > 0)
    {
        [pic_urls enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIImageView *imageView = self.subviews[idx];
            long columnIndex = idx % 3;
            
            imageView.frame = CGRectMake(columnIndex * (itemW + photoMargin), 0, itemW, itemH);
        }];
    }
}

- (void)tapImageView:(UITapGestureRecognizer *)tap
{
    UIView *imageView = tap.view;
    
    XDPhotoBrowser *photoBrowser = [XDPhotoBrowser defaultManager];
    
    [photoBrowser showBrowserWithImages:self.pic_urls andCurrentIndex:imageView.tag fromImageContainer:tap.view];
}

@end
