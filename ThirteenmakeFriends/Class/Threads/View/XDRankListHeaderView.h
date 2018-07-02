//
//  XDRankListHeaderView.h
//  ThirteenmakeFriends
//
//  Created by 空谷凌虚 on 2018/6/13.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDRankListHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *bgBackImg1;

@property (weak, nonatomic) IBOutlet UIView *rank1;
@property (weak, nonatomic) IBOutlet UIImageView *rank1HeaderImg;
@property (weak, nonatomic) IBOutlet UIImageView *rank1sexImg;
@property (weak, nonatomic) IBOutlet UILabel *rank1NameLab;
@property (weak, nonatomic) IBOutlet UILabel *rank1NumLab;
@property (weak, nonatomic) IBOutlet UILabel *rank1SubLab;

@property (weak, nonatomic) IBOutlet UIView *rank2;
@property (weak, nonatomic) IBOutlet UIImageView *rank2HeaderImg;
@property (weak, nonatomic) IBOutlet UIImageView *rank2sexImg;
@property (weak, nonatomic) IBOutlet UILabel *rank2NameLab;
@property (weak, nonatomic) IBOutlet UILabel *rank2NumLab;
@property (weak, nonatomic) IBOutlet UILabel *rank2SubLab;

@property (weak, nonatomic) IBOutlet UIView *rank3;
@property (weak, nonatomic) IBOutlet UIImageView *rank3HeaderImg;
@property (weak, nonatomic) IBOutlet UIImageView *rank3sexImg;
@property (weak, nonatomic) IBOutlet UILabel *rank3NameLab;
@property (weak, nonatomic) IBOutlet UILabel *rank3NumLab;
@property (weak, nonatomic) IBOutlet UILabel *rank3SubLab;

@property (weak, nonatomic) IBOutlet UIImageView *huangguanImgView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rank1ConVer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rank2ConVer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rank3ConVer;


@end
