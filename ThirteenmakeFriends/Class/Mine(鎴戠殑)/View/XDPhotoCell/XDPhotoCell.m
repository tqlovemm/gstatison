//
//  XDPhotoCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/8/29.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "XDPhotoCell.h"
#import "XDMovePhotoView.h"
#import "UIImageView+WebCache.h"
#import "XDPhotoBrowser.h"

#define kboldMargin 12
#define DIVIDE_WIDTH 8
//#define DIVIDE_WIDTH 3
//#define SMALLIMAGE_WIDTH (SCREEN_WIDTH - 2 * DIVIDE_WIDTH) / 3.0
#define SMALLIMAGE_WIDTH (SCREEN_WIDTH - 2 * DIVIDE_WIDTH - 2 * kboldMargin) / 3.0
#define BIGIMAGE_WIDTH 2 * SMALLIMAGE_WIDTH + DIVIDE_WIDTH
#define MOVEIMAGE_WIDTH SMALLIMAGE_WIDTH * 0.8
#define Max_count 6

@interface XDPhotoCell ()
{
    //! frame数组
    NSMutableArray *rectArray;
    //! 可见的View数组
    NSMutableArray *viewArray;
    BOOL isLongPress;
    float touchX;
    float touchY;
    CGRect moveInitFrame;
    CGRect moveFinishRect;
    int startPosition;
    // 是否移动结束
    BOOL isChangeEnd;
    BOOL isPerfermMove;
}

//! 可见的imageview数组
@property (retain, nonatomic)NSMutableArray *imgArray;

@end

@implementation XDPhotoCell

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"XDPhotoCellID";
    XDPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[XDPhotoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

- (void)setPhotos:(NSArray *)photos {
    _photos = photos;
    
    [self initRect];
    [self initView:photos];

}

-(void)initRect{
//    NSValue *value0 = [NSValue valueWithCGRect:CGRectMake(0, 0, BIGIMAGE_WIDTH, BIGIMAGE_WIDTH)];
//    NSValue *value1 = [NSValue valueWithCGRect:CGRectMake(BIGIMAGE_WIDTH + DIVIDE_WIDTH, 0, SMALLIMAGE_WIDTH, SMALLIMAGE_WIDTH)];
//    NSValue *value2 = [NSValue valueWithCGRect:CGRectMake(BIGIMAGE_WIDTH + DIVIDE_WIDTH, SMALLIMAGE_WIDTH + DIVIDE_WIDTH, SMALLIMAGE_WIDTH, SMALLIMAGE_WIDTH)];
//    NSValue *value3 = [NSValue valueWithCGRect:CGRectMake(BIGIMAGE_WIDTH + DIVIDE_WIDTH, 2 * (SMALLIMAGE_WIDTH + DIVIDE_WIDTH), SMALLIMAGE_WIDTH, SMALLIMAGE_WIDTH)];
//    NSValue *value4 = [NSValue valueWithCGRect:CGRectMake(SMALLIMAGE_WIDTH + DIVIDE_WIDTH, BIGIMAGE_WIDTH + DIVIDE_WIDTH, SMALLIMAGE_WIDTH, SMALLIMAGE_WIDTH)];
//    NSValue *value5 = [NSValue valueWithCGRect:CGRectMake(0, BIGIMAGE_WIDTH + DIVIDE_WIDTH, SMALLIMAGE_WIDTH, SMALLIMAGE_WIDTH)];
//    rectArray = [NSMutableArray arrayWithObjects:value0,value1,value2,value3,value4,value5,nil];
    
    NSValue *value0 = [NSValue valueWithCGRect:CGRectMake(kboldMargin, kboldMargin, BIGIMAGE_WIDTH, BIGIMAGE_WIDTH)];
    NSValue *value1 = [NSValue valueWithCGRect:CGRectMake(BIGIMAGE_WIDTH + DIVIDE_WIDTH + kboldMargin, kboldMargin, SMALLIMAGE_WIDTH, SMALLIMAGE_WIDTH)];
    NSValue *value2 = [NSValue valueWithCGRect:CGRectMake(BIGIMAGE_WIDTH + DIVIDE_WIDTH + kboldMargin, SMALLIMAGE_WIDTH + DIVIDE_WIDTH + kboldMargin, SMALLIMAGE_WIDTH, SMALLIMAGE_WIDTH)];
    NSValue *value3 = [NSValue valueWithCGRect:CGRectMake(BIGIMAGE_WIDTH + DIVIDE_WIDTH + kboldMargin, 2 * (SMALLIMAGE_WIDTH + DIVIDE_WIDTH) + kboldMargin, SMALLIMAGE_WIDTH, SMALLIMAGE_WIDTH)];
    NSValue *value4 = [NSValue valueWithCGRect:CGRectMake(SMALLIMAGE_WIDTH + DIVIDE_WIDTH + kboldMargin, BIGIMAGE_WIDTH + DIVIDE_WIDTH + kboldMargin, SMALLIMAGE_WIDTH, SMALLIMAGE_WIDTH)];
    NSValue *value5 = [NSValue valueWithCGRect:CGRectMake(0 + kboldMargin, BIGIMAGE_WIDTH + DIVIDE_WIDTH + kboldMargin, SMALLIMAGE_WIDTH, SMALLIMAGE_WIDTH)];
    rectArray = [NSMutableArray arrayWithObjects:value0,value1,value2,value3,value4,value5,nil];
    
}



-(void)initView: (NSArray *)array{
    isChangeEnd = YES;
    [self initBgImageView];
    [self initShowImageView:(NSMutableArray *)array];
    
}

-(void)initBgImageView{ // 添加背景图片
    UIImage *defautImg = [UIImage imageNamed:@"defaultimg"];
    for(int i= 0 ;i< [rectArray count] ;i++){
        XDMovePhotoView *imageView = [[XDMovePhotoView alloc]init];
        imageView.image = defautImg;
        imageView.frame = [[rectArray objectAtIndex:i] CGRectValue];
        imageView.layer.cornerRadius = 10;
        imageView.layer.masksToBounds = YES;
        [self addSubview:imageView];
        
    }
}

-(void)initShowImageView:(NSMutableArray *)array{ // 添加可见图片
    
    viewArray = [[NSMutableArray alloc]init];
    self.imgArray = [NSMutableArray array];
    for(int i= 0 ; i < ([array count] > Max_count ? Max_count : array.count) ; i++){
        //        UIImage *image = [array objectAtIndex:i];
        NSString *imgStr = [array objectAtIndex:i];
        XDMovePhotoView *imageView = [[XDMovePhotoView alloc]init];
        //        imageView.postition = i;
        imageView.tag = i;
        //        imageView.image = image;
        [imageView sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"defaultimg"]];
        imageView.userInteractionEnabled = YES;
        imageView.layer.cornerRadius = 10;
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.frame = [[rectArray objectAtIndex:i] CGRectValue];
        [self addSubview:imageView];
        [viewArray addObject:imageView];
        
        [self.imgArray addObject:imageView.image];
        
        // 添加点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPhoto:)];
        [imageView addGestureRecognizer:tap];
    }
    
}

/**
 *  监听图片的点击
 */
- (void)tapPhoto:(UITapGestureRecognizer *)recognizer
{
    XDPhotoBrowser *photoBrowser = [XDPhotoBrowser defaultManager];
    [photoBrowser showBrowserWithImages:self.photos andCurrentIndex:recognizer.view.tag fromImageContainer:recognizer.view];
}

+ (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 3 * SMALLIMAGE_WIDTH + 2 * DIVIDE_WIDTH + kboldMargin;
}

@end
