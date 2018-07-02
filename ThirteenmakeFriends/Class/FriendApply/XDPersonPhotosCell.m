//
//  XDPersonPhotosCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/12/13.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "XDPersonPhotosCell.h"
#import "UIImageView+WebCache.h"
#import "ShiSanUser.h"

@implementation XDPersonPhotosCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 创建子视图
        [self setupSubViews];
        self.layer.masksToBounds = YES;
    }
    return self;
}

/**
 创建子视图
 */
- (void)setupSubViews {
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 6, 90, 20)];
    nameLabel.text = @"个人照片";
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textColor = [UIColor grayColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.numberOfLines = 0;
    [self.contentView addSubview:nameLabel];
    
    int count = (SCREEN_WIDTH - 50) / (45 + 7.0);
    
    CGFloat imgWH = 45;
    CGFloat imgY = 33;
    CGFloat imgX = 0;
    for (int i = 0; i < count; i++) {
        UIImageView *imgView = [[UIImageView alloc]init];
        imgX = 15 + i * (imgWH + 7);
        imgView.frame = CGRectMake(imgX, imgY, imgWH, imgWH);
        imgView.image = [UIImage imageNamed:@"square_image_placeholder"];
        imgView.tag = 999;
        imgView.layer.cornerRadius = 5;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.layer.masksToBounds = YES;
        [self.contentView addSubview:imgView];
    }
    
    UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 24, 33, 12, 12)];
    arrowView.image = [UIImage imageNamed:@"common_icon_arrow"];
    [self.contentView addSubview:arrowView];
    arrowView.centerY = imgY + imgWH / 2.0;
}

- (void)setUser:(ShiSanUser *)user {
    _user = user;
    
    NSMutableArray *imgViewArray = [NSMutableArray array];
    for (UIView *object in self.contentView.subviews) { //获取所有的imgView
        if ([object isKindOfClass:[UIImageView class]] && object.tag == 999) {
            [imgViewArray addObject:object];
        }
    }
    
    for (int i = 0; i < imgViewArray.count; i++) {
        UIImageView *imgView = [imgViewArray objectAtIndex:i];
        if (i < self.user.photos.count) {
            imgView.hidden = NO;
            [imgView sd_setImageWithURL:[NSURL URLWithString:[self.user.photos objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
        } else {
            imgView.hidden = YES;
        }
    }

}

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"XDPersonPhotosCellID";
    XDPersonPhotosCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[XDPersonPhotosCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

@end
