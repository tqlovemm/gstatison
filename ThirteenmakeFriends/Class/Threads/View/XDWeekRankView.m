//
//  XDWeekRankView.m
//  ThirteenmakeFriends
//
//  Created by 空谷凌虚 on 2018/6/5.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDWeekRankView.h"

#import "XDRankListModel.h"

@interface XDWeekRankView ()

@property (nonatomic, strong) UIImageView *imagView0;
@property (nonatomic, strong) UIImageView *imagView1;
@property (nonatomic, strong) UIImageView *imagView2;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation XDWeekRankView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.backgroundColor = [UIColor whiteColor];
    
    self.imagView0 = [[UIImageView alloc] init];
    self.imagView0.contentMode = UIViewContentModeScaleAspectFit;
    self.imagView0.clipsToBounds = YES;
    [self addSubview:self.imagView0];
    
    self.imagView1 = [[UIImageView alloc] init];
    self.imagView1.contentMode = UIViewContentModeScaleAspectFit;
    self.imagView1.clipsToBounds = YES;
    [self addSubview:self.imagView1];
    
    
    self.imagView2 = [[UIImageView alloc] init];
    self.imagView2.contentMode = UIViewContentModeScaleAspectFit;
    self.imagView2.clipsToBounds = YES;
    [self addSubview:self.imagView2];
    
    self.tipLabel = [[UILabel alloc] init];
    self.tipLabel.textColor = RGB(170, 170, 170);
    self.tipLabel.font = kPingFangRegularFont(12);
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    self.tipLabel.numberOfLines = 0;
    [self addSubview:self.tipLabel];

}


-(void)setCRankListModel:(XDCustomRankListModel *)cRankListModel{
    _cRankListModel = cRankListModel;
    self.imagView0.frame = CGRectMake(0, 0, 42, 42);
    self.imagView0.center =  CGPointMake(self.contentView.centerX, self.contentView.centerY-5);
    self.imagView0.layer.cornerRadius = self.imagView0.width/2.0;
    
    self.imagView1.frame = CGRectMake(0, 0, 36, 36);
    self.imagView1.center = CGPointMake(self.contentView.centerX, self.contentView.centerY-5);
    self.imagView1.layer.cornerRadius = self.imagView1.width/2.0;
    [self.imagView1 sd_setImageWithURL:[NSURL URLWithString:cRankListModel.rankModel.avatar] placeholderImage:[UIImage imageNamed:@"square_image_placeholder"]];
    self.tipLabel.text = cRankListModel.rankModel.nickname;
    
    self.imagView2.frame = CGRectMake(0, 0, 20, 20);
    self.imagView2.center = CGPointMake(self.imagView0.right-3, self.imagView0.y);
    self.imagView2.layer.cornerRadius = self.imagView2.width/2.0;
    
   
    self.imagView0.image = [UIImage imageNamed:[NSString stringWithFormat:@"mask-%ld",(long)cRankListModel.index]];
    if (cRankListModel.index == 0) {
        self.imagView2.image = [UIImage imageNamed:@"huangguan"];;
        CGAffineTransform transform= CGAffineTransformMakeRotation(M_PI*0.2);
        self.imagView2.transform = transform;
	}else if (cRankListModel.index == 1){
		self.imagView2.image = [UIImage imageNamed:@"yinguan"];
	}else if (cRankListModel.index == 2){
		self.imagView2.image = [UIImage imageNamed:@"tongguan"];
	}
	
	
//    } else if (cRankListModel.index == 1){
        ////            imag = [UIImage imageNamed:@"yinguan"];
        ////        }else if ((cRankListModel.index == 2){
        ////            imag = [UIImage imageNamed:@"tongguan"];;
        ////        }
   
    
    self.tipLabel.frame =CGRectMake(0,self.imagView1.bottom, self.width,  20);
    
}
    
    
@end
