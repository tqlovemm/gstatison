//
//  CollectionHistoryTableViewCell.m
//  ThirteenmakeFriends
//
//  Created by iOS on 23/5/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "CollectionHistoryTableViewCell.h"

@implementation CollectionHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(CollectionHistoryModel *)model {
    _model            = model;
    self.lblName.text = F(@"%@", _model.title);
    self.lblTime.text = F(@"%@", _model.collection_created_at);
    
    self.avatarView.urlAvatar = F(@"%@", _model.wimg);
    [self.btnPraise setTitle:F(@"%@", _model.like_count) forState:UIControlStateNormal];
}

- (IBAction)didPressedToPraise:(UIButton *)sender {
    if (_clickBlock) {
        _clickBlock(self);
    }
}

/**
 点赞动画
 */
- (void)didPressedToStartPriseAnimation {
    
    CAKeyframeAnimation * animation;
    animation                     = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration            = 0.5;
    animation.removedOnCompletion = YES;
    animation.fillMode            = kCAFillModeForwards;
    NSMutableArray *values        = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values              = values;
    [self.imgPraise.layer addAnimation:animation forKey:nil];
    [self.imgPraise setImage:ImageViewName(@"praise_select")];
    [self.btnPraise setTitleColor:RGB(216, 63, 113) forState:UIControlStateNormal];
    [self.btnPraise setTitle:F(@"%ld",  [_model.like_count integerValue] + 1) forState:UIControlStateNormal];
}
@end
