//
//  XDActivityCenterCell.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/10.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDActivityCenterCell.h"

@interface XDActivityCenterCell ()

@property (nonatomic, weak) UIImageView *imgView;

@end

@implementation XDActivityCenterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupSubviews];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)setupSubviews
{
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    [self.contentView addSubview:imgView];
    self.imgView = imgView;
    
    XD_WeakSelf
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.left.mas_equalTo(6);
        make.right.mas_equalTo(-6);
        make.top.mas_equalTo(6);
        make.height.mas_equalTo(self.imgView.mas_width).multipliedBy(198/371.0);
        make.bottom.mas_equalTo(self.contentView).offset(-6);
    }];
}

- (void)setImg_Name:(NSString *)img_Name {
    _img_Name = img_Name;
    
    self.imgView.image = [UIImage imageNamed:img_Name];
}

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"XDActivityCenterCellID";
    XDActivityCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[XDActivityCenterCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DScale(transform, 1, 1, 1);//由小变大
    self.layer.transform = transform;
    
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.layer.transform = CATransform3DScale(transform, 1.2, 1.2, 1);//由小变大
    } completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.layer.transform = CATransform3DIdentity;
    } completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.layer.transform = CATransform3DIdentity;
    } completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
}

@end
