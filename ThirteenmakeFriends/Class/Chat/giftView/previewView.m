//
//  previewView.m
//  ThirteenmakeFriends
//
//  Created by jie.huang on 2018/4/12.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "previewView.h"
#import "GirftBtn.h"
#import "GiftLable.h"
//#import "MyJCBViewController.h"
#import "ProfileUser.h"
#import "XDAccountTool.h"
#import "XDGiftItemModel.h"
@interface previewView ()<UIScrollViewDelegate>

@property (nonatomic, strong) XDGiftItemModel *giftItemModel;

@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, weak) UIButton *giveBtn;

@end

@implementation previewView


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor =[UIColor whiteColor];
    }
    return self;

}

-(void)layoutSubviews
{
     [super layoutSubviews];
    
    _scrollview = [[UIScrollView alloc] init];
    _scrollview.pagingEnabled = YES;
    _scrollview.showsHorizontalScrollIndicator = NO;
    _scrollview.showsVerticalScrollIndicator = NO;
    _scrollview.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    [self addSubview:_scrollview];
    //列
    int totalloc=4;
    
    CGFloat appvieww=self.frame.size.width/4;
    CGFloat appviewh=self.frame.size.height/2-20;
    CGFloat margin=(self.frame.size.width-totalloc*appvieww)/(totalloc+1);
    
    NSInteger count=self.giftsArr.count;
    for (int i=0; i<count; i++) {
        XDGiftItemModel* model = self.giftsArr[i];
        //       页数
        int index = i/8;
        //        行
        int row = i>=8 ? (i - totalloc * index * 2)/totalloc : (i - totalloc * index)/totalloc;
        //        列
        int loc=i%totalloc;
        //        x
        CGFloat appviewx=(margin+appvieww)*loc;
        //        y
        CGFloat appviewy=(margin+appviewh)*row;
        
        UIView *view=[[UIView alloc]init];
        view.frame= CGRectMake(appviewx + ((i/8)*self.frame.size.width), appviewy ,appvieww, appviewh);
        view.userInteractionEnabled = YES;
        view.tag = i+1;
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
        [view addGestureRecognizer:tapGesture];
        
        UIImageView *backImgView = [[UIImageView alloc] initWithFrame:view.bounds];
        backImgView.image = [UIImage imageNamed:@"rectangle8-1"];
        backImgView.tag = view.tag;
        backImgView.userInteractionEnabled = NO;
        [view addSubview:backImgView];
        
        UIImageView *giftsImgView = [[UIImageView alloc] init];
        [giftsImgView sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@"square_image_placeholder"]];
        [giftsImgView setContentMode:UIViewContentModeScaleAspectFit];
        CGFloat imgWidth = appvieww*0.5;
//        giftsImgView.clipsToBounds = YES;
//        giftsImgView.layer.cornerRadius = imgWidth/2.0;
        [backImgView addSubview:giftsImgView];
        [giftsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(imgWidth, imgWidth));
            make.centerX.mas_equalTo(backImgView);
            make.top.mas_equalTo(backImgView.mas_top).offset(20);
        }];
        
        UILabel *giftsNameLabel = [[UILabel alloc] init];
        giftsNameLabel.text =[NSString stringWithFormat:@"%@", model.name];
        giftsNameLabel.textColor = [UIColor blackColor];
        giftsNameLabel.textAlignment = NSTextAlignmentCenter;
        giftsNameLabel.font = [UIFont systemFontOfSize:12];
        [backImgView addSubview:giftsNameLabel];
        [giftsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(appvieww-10, 12));
            make.centerX.mas_equalTo(backImgView);
            make.top.mas_equalTo(giftsImgView.mas_bottom).offset(5);
        }];
        
        UILabel *lable = [[GiftLable alloc]init];
        lable.backgroundColor = [UIColor clearColor];
        lable.text = [NSString stringWithFormat:@"%@%@",model.price,diamonds_name];
        [backImgView addSubview:lable];
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(appvieww-10, 12));
            make.centerX.mas_equalTo(backImgView);
            make.top.mas_equalTo(giftsNameLabel.mas_bottom).offset(5);
        }];
        
        [_scrollview addSubview:view];
        
        _scrollview.contentSize = CGSizeMake(ceil((count/8))*self.frame.size.width, appviewh);
    }
   
    [self creatTopUP];
    
}

-(void)setGiftsArr:(NSArray *)giftsArr{
    _giftsArr = giftsArr;
}
-(void)click:(UITapGestureRecognizer *)sender{
    
    UIView *view = sender.view;
    for (int i = 0; i< self.scrollview.subviews.count; i++) {
        if (view.tag == 1 + i) {
            UIImageView *backImgView = view.subviews.firstObject;
            backImgView.image = [UIImage imageNamed:@"xuanzhong-1"];
//            view.layer.borderWidth = 1;
//            view.layer.borderColor = RGB(97, 60, 187).CGColor;
            continue;
        }
        
        UIView *vieww = (UIView*)[self.scrollview viewWithTag:i+1];
        UIImageView *backImgView = vieww.subviews.firstObject;
         backImgView.image = [UIImage imageNamed:@"rectangle8-1"];
//        vieww.layer.borderWidth = 0;
//        vieww.layer.borderColor = [UIColor clearColor].CGColor;
    }
  
    self.giveBtn.enabled = YES;
    self.giftItemModel = self.giftsArr[view.tag - 1];
//    if (self.giftsBlock) {
//        self.giftsBlock(view.tag);
//    }
}


-(void)creatTopUP{
    
    UIButton *numBtn = [[UIButton alloc]init];
    numBtn.frame = CGRectMake(10, self.height - 35, self.width/2, 30);
    numBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    numBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [numBtn setTitleColor:RGB(159, 159, 159) forState:UIControlStateNormal];
    ProfileUser *user = [XDAccountTool account];
    [numBtn setTitle:[NSString stringWithFormat:@"剩余%ld%@",(long)user.diamonds,diamonds_name] forState:UIControlStateNormal];
    [self addSubview:numBtn];
    
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(self.width - 80-20, self.height - 35,  76, 30);
////    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
////    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
//    [btn setTitle:@"赠送" forState:UIControlStateNormal];
//    btn.titleLabel.font = [UIFont systemFontOfSize:15];
//    btn.layer.cornerRadius = 15.f;
//    btn.layer.masksToBounds = YES;
    [btn setBackgroundImage:[UIImage imageNamed:@"kaiqi-1"] forState:(UIControlStateNormal)];
    [btn setBackgroundImage:[UIImage imageNamed:@"kaiqi-2"] forState:(UIControlStateDisabled)];
//    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//RGB(97, 60, 187)
//    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    
//    [btn setBackgroundImage:[UIImage imageWithColor:RGB(97, 60, 187)] forState:UIControlStateNormal];
//        [btn setBackgroundImage:[UIImage imageWithColor:RGB(220, 220, 220)] forState:UIControlStateDisabled];
    [btn addTarget:self action:@selector(ToUP) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    btn.enabled = NO;
    self.giveBtn = btn;
    
}

-(void)ToUP
{
    if (self.pushBlock) {
        self.pushBlock(self.giftItemModel);
    }
    self.giveBtn.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.giveBtn.enabled = YES;
    });
}

@end
