//
//  SendGiftsDetailCell.m
//  ThirteenmakeFriends_myPuppet
//
//  Created by 谢超 on 2018/4/17.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "ReceiveGiftsDetailCell.h"

@implementation ReceiveGiftsDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.userHeadImgView.layer.cornerRadius = 27.f;
    self.userHeadImgView.layer.masksToBounds = YES;
    
    
//    CALayer *subLayer=[CALayer layer];
//    CGRect fixframe = self.userHeadImgView.frame;
//    subLayer.frame= fixframe;
//    subLayer.cornerRadius= self.userHeadImgView.width/2.0;
//    subLayer.backgroundColor=  RGB(97, 60, 187).CGColor;
//    subLayer.masksToBounds=NO;
//    subLayer.shadowColor =  RGB(97, 60, 187).CGColor;
//    subLayer.shadowOffset = CGSizeMake(3,3);
//    subLayer.shadowOpacity = 0.5;
//    //    subLayer.shadowRadius = 4;
//    [self.contentView.layer insertSublayer:subLayer below:self.userHeadImgView.layer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)layoutSubviews{
    [super layoutSubviews];
}


@end
