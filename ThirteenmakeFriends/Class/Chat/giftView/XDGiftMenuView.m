//
//  XDGiftMenuView.m
//  ThirteenmakeFriends
//
//  Created by 空谷凌虚 on 2018/5/9.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDGiftMenuView.h"
#import "GirftBtn.h"
#import "GiftLable.h"
//#import "MyJCBViewController.h"
#import "ProfileUser.h"
#import "XDAccountTool.h"
#import "XDGiftItemModel.h"
#import "CYPromptCoverView.h"
#import "UIImageView+WebCache.h"
@interface XDGiftMenuView ()<UIScrollViewDelegate>

@property (nonatomic, strong) XDGiftItemModel *giftItemModel;
@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, assign) UIView *lineView;

@end

@implementation XDGiftMenuView


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor =[UIColor whiteColor];
        self.layer.cornerRadius = 10.f;
        self.layer.masksToBounds = YES;
    }
    return self;
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    UILabel *title = [[GiftLable alloc]initWithFrame:CGRectMake(0, 10, self.width, 30)];
    title.font = k18Font;
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor blackColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"选择礼物";
    [self addSubview:title];

    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, title.bottom, 50, 2)];
    lineView.centerX = title.centerX;
    lineView.backgroundColor =  RGB(97, 60, 187);
    [self addSubview:lineView];
    self.lineView = lineView;
    
    UIButton *cancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.width - 50, 0, 40, 40)];
//    cancelBtn.backgroundColor =  RGB(97, 60, 187);
//    [cancelBtn setTitle:@"X" forState:UIControlStateNormal];
//    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    cancelBtn.titleLabel.font = k18Font;
    
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"guanbi-2"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(hideGiftsMenuView) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:cancelBtn];
//
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cancelBtn.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(15, 15)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = cancelBtn.bounds;
//    maskLayer.path = maskPath.CGPath;
//    cancelBtn.layer.mask = maskLayer;
//


    _scrollview = [[UIScrollView alloc] init];
    _scrollview.pagingEnabled = YES;
    _scrollview.showsHorizontalScrollIndicator = NO;
    _scrollview.showsVerticalScrollIndicator = NO;
    _scrollview.frame = CGRectMake(0, lineView.bottom+10, self.frame.size.width, self.frame.size.height-(lineView.bottom+10));
    
    [self addSubview:_scrollview];
    
//    //列
    int totalloc=4;

    CGFloat appvieW= (self.frame.size.width-20);
    CGFloat appvieww= appvieW/4;
    CGFloat appviewh=(self.frame.size.height-(lineView.bottom+10+100))/2;
    CGFloat margin= (appvieW-totalloc*appvieww)/(totalloc+1);

//    NSArray *nameArr = @[@"棒棒糖",@"示爱",@"仙女棒",@"口红",@"性感内衣",@"项链",@"蓝色妖姬",@"跑车"];
//    NSArray *iconArr = @[@"6",@"19",@"52",@"99",@"299",@"520",@"999",@"1314"];

    NSInteger count=self.giftArr.count;
    for (int i=0; i<count; i++) {
        XDGiftItemModel* model = self.giftArr[i];
        //       页数
        int index = i/8;
        //        行
        int row = i>=8 ? (i - totalloc * index * 2)/totalloc : (i - totalloc * index)/totalloc;
        //        列
        int loc=i%totalloc;
        //        x
        CGFloat appviewx=(margin+appvieww)*loc+10;
        //        y
        CGFloat appviewy=(margin+appviewh)*row;

        UIView *view=[[UIView alloc]init];
        view.frame= CGRectMake(appviewx + ((i/8)*self.frame.size.width), appviewy ,appvieww, appviewh);
        view.userInteractionEnabled = YES;
        view.tag = i+1;
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
        [view addGestureRecognizer:tapGesture];


        UIImageView *giftsImgView = [[UIImageView alloc] init];
         [giftsImgView sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@"square_image_placeholder"]];

        [giftsImgView setContentMode:UIViewContentModeScaleAspectFit];
        CGFloat imgWidth = appvieww*0.5;
//        giftsImgView.layer.cornerRadius = imgWidth/2.0;
//        giftsImgView.clipsToBounds = YES;
        [view addSubview:giftsImgView];
        [giftsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(imgWidth,imgWidth));
            make.centerX.mas_equalTo(view);
            make.top.mas_equalTo(view.mas_top).offset(20);
        }];

        UILabel *giftsNameLabel = [[UILabel alloc] init];
        giftsNameLabel.text = model.name;
        giftsNameLabel.textColor = [UIColor blackColor];
        giftsNameLabel.textAlignment = NSTextAlignmentCenter;
        giftsNameLabel.font = [UIFont systemFontOfSize:12];
        [view addSubview:giftsNameLabel];
        [giftsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(appvieww-10, 12));
            make.centerX.mas_equalTo(view);
            make.top.mas_equalTo(giftsImgView.mas_bottom).offset(5);
        }];

        UILabel *lable = [[GiftLable alloc]init];
        lable.backgroundColor = [UIColor clearColor];
        lable.text = [NSString stringWithFormat:@"%@%@",model.price,diamonds_name];
        [view addSubview:lable];
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(appvieww-10, 12));
            make.centerX.mas_equalTo(view);
            make.top.mas_equalTo(giftsNameLabel.mas_bottom).offset(5);
        }];

        [_scrollview addSubview:view];

        _scrollview.contentSize = CGSizeMake(ceil((count/8))*self.frame.size.width, appviewh);
    }

    [self creatTopUP];
    
}


-(void)click:(UITapGestureRecognizer *)sender{
    
    UIView *view = sender.view;
    for (int i = 0; i< self.scrollview.subviews.count; i++) {
        if (view.tag == 1 + i) {
            view.layer.borderWidth = 1;
            view.layer.borderColor = RGB(97, 60, 187).CGColor;
            continue;
        }
        UIView *vieww = (UIView*)[self.scrollview viewWithTag:i+1];
        vieww.layer.borderWidth = 0;
        vieww.layer.borderColor = [UIColor clearColor].CGColor;
    }
    
    self.giveBtn.enabled = YES;
    self.giftItemModel = self.giftArr[view.tag - 1];

}

-(void)setGiftArr:(NSArray *)giftArr{
    _giftArr = giftArr;
//    [_scrollview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
   
}
-(void)creatTopUP{
    
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(0, self.height - 80,  250, 56);
    btn.centerX = self.width/2.0;
    //    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    //    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [btn setTitle:@"赠送礼物" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
//    btn.layer.cornerRadius = 22.f;
//    btn.layer.masksToBounds = YES;
    //    [btn setBackgroundImage:[UIImage imageNamed:@"chongzhi"] forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//RGB(97, 60, 187)
//    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
//
//    [btn setBackgroundImage:[UIImage imageWithColor:RGB(97, 60, 187)] forState:UIControlStateNormal];
//    [btn setBackgroundImage:[UIImage imageWithColor:RGB(220, 220, 220)] forState:UIControlStateDisabled];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"sendgift_s"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"btn-hui"] forState:UIControlStateDisabled];
    [btn addTarget:self action:@selector(ToUP) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    btn.enabled = NO;
    self.giveBtn = btn;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self sendGiftGuide];
        [self addBtnNewbieGuide];
    });
    
}


/**
 送礼物引导
 */
- (void)sendGiftGuide {
    
//    if (!myAppDelegate.newVersion) {
//        return;
//    }
    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
    CYPromptCoverView *cover0 = [[CYPromptCoverView alloc] initWithRevalView:self.giveBtn layoutType:CYPromptCoverViewLayoutTypeDown];
    cover0.revealType = CYPromptCoverViewRevealTypeRect;
    
    ////   btn.frame = CGRectMake(0, self.height - 80,  self.width - 80, 44);
    //    CGFloat height = 44;
    //    CGFloat width =  self.giftView.width - 80;
    ////    CGRect rc = [self.giftView convertRect:self.giftView.frame toView:appWindow];
    //    CGFloat y = self.giftView.bottom - 80 ;
    //    CGFloat x = 0;
    //    cover0.revealFrame = CGRectMake(x, y, width , height);
    
    cover0.des = nil;
    cover0.detailDes = @"送礼后,若对方14天内不接受您的礼物,系统将自动退还钻石哦~";
    [cover0 showInView:appWindow];
}


/**
 打招呼引导
 */
- (void)addBtnNewbieGuide {
    
    
    BOOL  isPilot = [[NSUserDefaults standardUserDefaults]boolForKey:PilotString2];
    if (isPilot) {
        return;
    }
    //    if (!myAppDelegate.newVersion) {
    //        return;
    //    }

    UIView *view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    view.backgroundColor =  [[UIColor blackColor]colorWithAlphaComponent:0.6];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideNewbieGuide:)];
    gesture.numberOfTapsRequired = 1;
    gesture.cancelsTouchesInView = NO;
    [view addGestureRecognizer:gesture];
    
    CGRect frame = [self convertRect:self.giveBtn.frame toView:view];

    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds cornerRadius:0];
    [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:0]bezierPathByReversingPath]];

    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    fillLayer.opacity = 0.6;
    [view.layer addSublayer:fillLayer];
    
    

    UIImageView *imagView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 301, 143)];
    imagView.y = frame.origin.y+frame.size.height+10;
    imagView.centerX = frame.origin.x + (frame.size.width/2.0);
    imagView.image = [UIImage imageNamed:@"group12"];
    [view addSubview:imagView];
}

-(void)hideNewbieGuide:(UITapGestureRecognizer*)tap{
    [tap.view removeFromSuperview];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:PilotString2];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)ToUP{
    if (self.giftsBlock) {
        self.giftsBlock(self.giftItemModel);
    }
}

-(void)hideGiftsMenuView{
    if (_hideGiftMenuViewBlock) {
        _hideGiftMenuViewBlock();
    }
}
@end
