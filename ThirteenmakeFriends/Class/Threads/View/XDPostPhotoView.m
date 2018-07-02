//
//  XDPostPhotoView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/3/23.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDPostPhotoView.h"
#import "XDPhotoModel.h"
#import "UIImageView+WebCache.h"
#import "XDPhotoBrowser.h"
#import "XDPhotoModel.h"
#import "KeyboardSingle.h"

#define margin 10
#define XDPostPhotosMaxCount 9
#define photoMargin 5
#define kContent_width (SCREEN_WIDTH - 2 * margin)

@interface XDPostPhotoView ()

@property (nonatomic, strong) NSArray *photosArray;

@end

@implementation XDPostPhotoView

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
    
    self.photosArray = pic_urls.count > XDPostPhotosMaxCount ? [pic_urls subarrayWithRange:NSMakeRange(0, 9)] : pic_urls;
    
    for (int i = 0; i<XDPostPhotosMaxCount; i++) {
        UIImageView *photoView = self.subviews[i];
        
        if (i < pic_urls.count) { // 显示图片
            XDPhotoModel *photo = pic_urls[i];
            [photoView sd_setImageWithURL:[NSURL URLWithString:photo.img_path] placeholderImage:[UIImage imageNamed:@"square_image_placeholder"]];
            photoView.hidden = NO;
        } else { // 隐藏
            photoView.hidden = YES;
        }
    }
    
    /*! 图片创建 */
    CGFloat itemW = 0;
    CGFloat itemH = 0;
    if (self.photosArray.count > 0)
    {
        if (pic_urls.count == 1) {
            XDPhotoModel *photo = pic_urls.firstObject;
            if (photo.img_height == 0) {
                itemW = SCREEN_WIDTH - 2 * margin;
                itemH = SCREEN_WIDTH - 2 * margin;
            } else {
                CGFloat image_w = photo.img_width;
                CGFloat image_h = photo.img_height;
                
                if (image_w > kContent_width)
                {
                    image_w = kContent_width * 0.68;
                    image_h = image_h / photo.img_width * image_w;
                }
                
                if (image_h > image_w)
                {
                    image_w = image_w / image_h * kContent_width;
                    image_h = image_h / image_h * kContent_width;
                }
                
                itemW = image_w;
                itemH = image_h;
            }
        } else if (pic_urls.count == 2) {
            itemW = (SCREEN_WIDTH - 2 * margin - photoMargin) / 2.0;
            itemH = itemW;
            
        } else {
            itemW = (SCREEN_WIDTH - 2 * margin - 2 * photoMargin) / 3.0;
            itemH = itemW;
        }
        
        long perRowItemCount = [self perRowItemCountForPicPathArray:self.photosArray];
        
        [self.photosArray enumerateObjectsUsingBlock:^(XDPhotoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIImageView *imageView = self.subviews[idx];
            long columnIndex = idx % 3;
            long rowIndex = idx / perRowItemCount;
            
            imageView.frame = CGRectMake(columnIndex * (itemW + photoMargin), rowIndex * (itemH + photoMargin), itemW, itemH);
        }];
    }
}

- (NSInteger)perRowItemCountForPicPathArray:(NSArray *)array
{
    if (array.count <= 3)
    {
        return array.count;
    }
    else
    {
        return 3;
    }
}

- (void)tapImageView:(UITapGestureRecognizer *)tap
{
    KeyboardSingle *single = [[KeyboardSingle alloc] init];
    UIViewController *vc = [single getCurrentVC];
    [vc.view endEditing:YES];
    
    UIView *imageView = tap.view;
    
    NSLog(@"图片-%ld-被点击",imageView.tag);
    
    XDPhotoBrowser *photoBrowser = [XDPhotoBrowser defaultManager];
    
    NSMutableArray *picurls = [NSMutableArray array];
    for (XDPhotoModel *photo in self.pic_urls) {
        [picurls addObject:photo.img_path];
    }
    
    [photoBrowser showBrowserWithImages:picurls andCurrentIndex:imageView.tag fromImageContainer:tap.view];
}

+ (CGSize)sizeWithPhotos:(NSArray *)photos
{
    /*! 图片创建 */
    CGFloat itemW = SCREEN_WIDTH - 2 * margin;
    CGFloat itemH = 0;
    if (photos.count == 0) {
        itemH = 0;
    } else if (photos.count == 1) {
        XDPhotoModel *photo = photos.firstObject;
        if (photo.img_height == 0) {
            itemH = SCREEN_WIDTH - 2 * margin;
        } else {
            CGFloat image_w = photo.img_width;
            CGFloat image_h = photo.img_height;
            
            if (image_w > kContent_width)
            {
                image_w = kContent_width * 0.68;
                image_h = image_h / photo.img_width * image_w;
            }
            
            if (image_h > image_w)
            {
                image_w = image_w / image_h * kContent_width;
                image_h = image_h / image_h * kContent_width;
            }
            
            itemW = image_w;
            itemH = image_h;
        }
    } else if (photos.count == 2) {
        CGFloat picW = (SCREEN_WIDTH - 2 * margin - photoMargin) / 2.0;
        itemH = picW;
        
    } else {
        NSInteger count = photos.count > XDPostPhotosMaxCount ? XDPostPhotosMaxCount : photos.count;
        
        CGFloat maxCols = 3;
        // 总行数
        int totalRows = (count + maxCols - 1) / maxCols;
        
        CGFloat picW = (SCREEN_WIDTH - 2 * margin - 2 * photoMargin) / maxCols;
        itemH = totalRows * picW + (totalRows - 1) * photoMargin;
    }
    
    return CGSizeMake(itemW, itemH);
}

@end
