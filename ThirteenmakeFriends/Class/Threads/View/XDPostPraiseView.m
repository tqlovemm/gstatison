//
//  XDPostPraiseView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/3/24.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDPostPraiseView.h"
#import "XDPostModel.h"
#import "XDPostPraiseController.h"

#define XDPraiseMaxCount 5

@interface XDPostPraiseView ()

@property (strong, nonatomic) NSMutableArray * photosView;

@property (weak, nonatomic) UILabel *praiseLabel;

@end

@implementation XDPostPraiseView

- (NSMutableArray *)photosView {
    if (_photosView == nil) {
        _photosView = [NSMutableArray array];
    }
    return _photosView;
}

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
    for (int i = 0; i<XDPraiseMaxCount; i++) {
        UIImageView *photoView = [[UIImageView alloc] init];
        photoView.clipsToBounds = YES;
        photoView.backgroundColor = [UIColor whiteColor];
        photoView.userInteractionEnabled = YES;
        photoView.tag = i;
        [self addSubview:photoView];
        [self.photosView addObject:photoView];
    }
    
    UILabel *praiseLabel = [[UILabel alloc]init];
    praiseLabel.textColor = RGB(205, 205, 205);
    praiseLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:praiseLabel];
    self.praiseLabel = praiseLabel;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(praiseClicked)];
    [self addGestureRecognizer:tap];
}

- (void)setModel:(XDPostModel *)model {
    _model = model;
    
    for (int i = 0; i<XDPraiseMaxCount; i++) {
        UIImageView *photoView = self.photosView[i];
        
        if (i < (model.likeItemsArray.count > XDPraiseMaxCount ? XDPraiseMaxCount : model.likeItemsArray.count)) { // 显示图片
            XDPostLikeItemModel *photo = model.likeItemsArray[i];
            [photoView sd_setImageWithURL:[NSURL URLWithString:photo.avatar] placeholderImage:[UIImage imageNamed:@"square_image_placeholder"]];
//            imgX = 10 + i * (imgWH + 5);
//            photoView.frame = CGRectMake(imgX, imgY, imgWH, imgWH);
//            photoView.layer.cornerRadius = imgWH / 2.0;
//            photoView.layer.masksToBounds = YES;
//            photoView.hidden = NO;
        } else { // 隐藏
//            photoView.hidden = YES;
        }
    }
    
    self.praiseLabel.text = [NSString stringWithFormat:@"%d人赞",model.likeCount];
    
    [self setNeedsLayout];
    
}

- (void)praiseClicked {
    NSLog(@"点赞视图被点击");
    
    UITabBarController *tabBar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tabBar.selectedViewController;
    
    XDPostPraiseController *praiseVC = [[XDPostPraiseController alloc] init];
    praiseVC.thread_id = self.model.wid;
    [nav pushViewController:praiseVC animated:YES];
}

- (void)layoutSubviews {
    
    CGFloat imgWH = 22;
    CGFloat imgY = 7;
    CGFloat imgX = 0;
    CGFloat imgMargin = 3;
    
    for (int i = 0; i<XDPraiseMaxCount; i++) {
        UIImageView *photoView = self.photosView[i];
        
        imgX = 10 + i * (imgWH + imgMargin);
        photoView.frame = CGRectMake(imgX, imgY, imgWH, imgWH);
        photoView.layer.cornerRadius = imgWH / 2.0;
        photoView.layer.masksToBounds = YES;
        
        if (i < (self.model.likeItemsArray.count > XDPraiseMaxCount ? XDPraiseMaxCount : self.model.likeItemsArray.count)) {
//            imgX = 10 + i * (imgWH + imgMargin);
//            photoView.frame = CGRectMake(imgX, imgY, imgWH, imgWH);
//            photoView.layer.cornerRadius = imgWH / 2.0;
//            photoView.layer.masksToBounds = YES;
            photoView.hidden = NO;
        } else { // 隐藏
            photoView.hidden = YES;
        }
    }
    
    CGFloat imgCount = self.model.likeItemsArray.count > XDPraiseMaxCount ? XDPraiseMaxCount : self.model.likeItemsArray.count;
    
    UIImageView *lastView = nil;
    if (imgCount > 0) {
       lastView = [self.photosView objectAtIndex:imgCount - 1];
    }
    
    CGFloat textMargin = 10;
    self.praiseLabel.x = lastView ? CGRectGetMaxX(lastView.frame) + textMargin : textMargin;
    self.praiseLabel.size = [_praiseLabel.text sizeWithFont:_praiseLabel.font];
    self.praiseLabel.centerY = self.height / 2.0;
    
    if (self.praiseLabel.x + self.praiseLabel.width > self.width) {
        self.praiseLabel.width = self.width - self.praiseLabel.x;
    }
}

@end
