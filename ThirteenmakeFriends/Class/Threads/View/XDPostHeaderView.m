//
//  XDPostHeaderView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/10/20.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDPostHeaderView.h"
#import <SDCycleScrollView.h>
#import "XDRecommendUserView.h"
#import "XDRecommend13SayView.h"
#import "XDPostTopModel.h"
#import "ICEWebViewController.h"
#import "PGBanner.h"

@interface XDPostHeaderView ()<SDCycleScrollViewDelegate,PGBannerDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleScroll;

@property (nonatomic, weak) UIView *rankView;
@property (nonatomic, weak) XDRecommendUserView *userView;
@property (nonatomic, weak) XDRecommendUserView *userView1;
@property (nonatomic, weak) XDRecommendUserView *userView2;

@property (nonatomic, weak) XDRecommend13SayView *sayView;
@property (nonatomic, weak) PGBanner *pgBanner;

@property (nonatomic, strong) NSArray *bannersArray;

@end

@implementation XDPostHeaderView

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
    self.cycleScroll = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 115)];
    self.cycleScroll.delegate = self;
    self.cycleScroll.placeholderImage = [UIImage imageNamed:@"ThirteenSay_ ADPlaceHolder"];
    self.cycleScroll.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.cycleScroll.autoScrollTimeInterval = 5;
    XD_WeakSelf
    self.cycleScroll.clickItemOperationBlock = ^(NSInteger currentIndex) {
        XD_StrongSelf
        XDPostTopModel *actModel = [self.bannersArray objectAtIndex:currentIndex];
        ICEWebViewController *vc = [[ICEWebViewController alloc]init];
        vc.fromURL = actModel.url;
        vc.des = actModel.title;
        [self.navigationController pushViewController:vc animated:YES];
    };
    [self addSubview:self.cycleScroll];
    
    self.cycleScroll.localizationImageNamesGroup = @[@"http://ounw0bp6w.bkt.clouddn.com/uploads/user/files/2017/08/29/zy34659a4d1cf5fb4c59a54f34957da.jpg",@"http://ounw0bp6w.bkt.clouddn.com/uploads/user/avatar/2017/08/30/4158259a65fe87e079.jpg"];
    
    UIView *rankView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cycleScroll.frame), self.width, 77)];
    rankView.userInteractionEnabled = YES;
    self.rankView = rankView;
    [self addSubview:rankView];
    
    

    XDRecommendUserView *view = [[XDRecommendUserView alloc] initWithFrame:CGRectMake(0, 0, rankView.width, 77)];
    view.rankType = rankTypeRX;
    self.userView2 = view;
    
    XDRecommendUserView *userView0 = [[XDRecommendUserView alloc] initWithFrame:CGRectMake(0, 0, rankView.width, 77)];
    userView0.rankType = rankTypeRX;
    self.userView = userView0;
    
    XDRecommendUserView *userView1 = [[XDRecommendUserView alloc]  initWithFrame:CGRectMake(0, 0, rankView.width, 77)];
    userView1.rankType = rankTypeML;
    self.userView1 = userView1;
    
    
    XDRecommendUserView *userView01 = [[XDRecommendUserView alloc] initWithFrame:CGRectMake(0, 0, rankView.width, 77)];
    userView01.rankType = rankTypeRX;
    
    XDRecommendUserView *userView11 = [[XDRecommendUserView alloc]  initWithFrame:CGRectMake(0, 0, rankView.width, 77)];
    userView11.rankType = rankTypeML;
    

    
    PGBanner *banner = [[PGBanner alloc]initViewWithFrame:rankView.bounds ViewList:@[userView11,userView0, userView1,userView01] timeInterval:3];
    banner.delegate = self;
    banner.pageControl.hidden = YES;
    [rankView addSubview:banner];
    self.pgBanner = banner;
    
    XDRecommend13SayView *sayView = [[XDRecommend13SayView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(rankView.frame) + 5, self.width, 88)];
    [self addSubview:sayView];
    self.sayView = sayView;
}

- (void)setBanners:(NSArray *)bannersArray tdstars:(NSArray *)tdstarsArray activitise:(NSArray *)activitiesArray {
    NSMutableArray *imgsArray = [NSMutableArray array];
    for (XDPostTopModel *moded in bannersArray) {
        [imgsArray addObject:moded.wimg];
    }
    self.cycleScroll.localizationImageNamesGroup = imgsArray;
    self.bannersArray = bannersArray;
//    self.userView.usersArray = tdstarsArray;
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:activitiesArray];
    XDAcitivityModel *lastModel = [[XDAcitivityModel alloc] init];
    lastModel.tag_name = @"查看更多    >";
    lastModel.last = YES;
    [tempArr addObject:lastModel];
    self.sayView.activitiesArray = tempArr;
}


-(void)setRankWeekRX:(NSArray *)ranklist{
    self.userView.usersArray = ranklist;
    CGFloat Y = CGRectGetMaxY(self.rankView.frame);
    if(ranklist.count == 0){
//        self.rankView.hidden = YES;
//        Y = CGRectGetMaxY(self.cycleScroll.frame);
		NSMutableArray *tmparr = [NSMutableArray array];
		if (self.userView2) {
			[tmparr addObject:self.userView2];
		}
		if (self.userView1) {
			[tmparr addObject:self.userView1];
		}
		if (self.userView2) {
			[tmparr addObject:self.userView2];
		}
		self.pgBanner.listArr = tmparr;
		
//        self.pgBanner.listArr = @[self.userView2, self.userView1,self.userView2];
        Y = CGRectGetMaxY(self.rankView.frame);
        self.rankView.hidden = NO;
    }else{
        Y = CGRectGetMaxY(self.rankView.frame);
          self.rankView.hidden = NO;
    }
    self.sayView.frame = CGRectMake(0,  Y+ 5, self.width, 88);
     CGFloat headerViewH = ranklist.count?290:(290-77);
    self.height = headerViewH;
}
-(void)setRankWeekML:(NSArray *)ranklist{
    self.userView1.usersArray = ranklist;
    CGFloat Y = CGRectGetMaxY(self.rankView.frame);
    if(ranklist.count == 0){
        if (self.userView.usersArray.count == 0) {
            self.rankView.hidden = YES;
            Y = CGRectGetMaxY(self.cycleScroll.frame);
        }else{
			
			NSMutableArray *tmparr = [NSMutableArray array];
			if (self.userView2) {
				[tmparr addObject:self.userView2];
			}
			if (self.userView) {
				[tmparr addObject:self.userView];
			}
			if (self.userView2) {
				[tmparr addObject:self.userView2];
			}
			self.pgBanner.listArr = tmparr;
			
//             self.pgBanner.listArr = @[self.userView2, self.userView,self.userView2];
            Y = CGRectGetMaxY(self.rankView.frame);
            self.rankView.hidden = NO;
        }
    }else{
        Y = CGRectGetMaxY(self.rankView.frame);
        self.rankView.hidden = NO;
    }

    self.sayView.frame = CGRectMake(0,  Y+ 5, self.width, 88);
    CGFloat headerViewH = ranklist.count?290:(290-77);
    self.height = headerViewH;
}


#pragma mark - PGBannerDelegate
- (void)selectAction:(NSInteger)didSelectAtIndex didSelectView:(id)view {
    NSLog(@"index = %ld  view = %@", didSelectAtIndex, view);
    
}
@end
