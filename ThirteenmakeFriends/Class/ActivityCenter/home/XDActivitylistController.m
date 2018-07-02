//
//  XDActivitylistController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/3/8.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDActivitylistController.h"
#import "HMSegmentedControl.h"

#import "XDMatchHomeController.h"
#import "XDChatupSquareController.h"
#import "XDChatupScreenController.h"
#import "XDMatchRecordController.h"
#import "XDSeekHelpController.h"
#import "XDNavigationController.h"
#import "XDIntroduceModel.h"
#import "XDMultiSelectView.h"

#import "XDAreaModel.h"

@interface XDActivitylistController ()<UIScrollViewDelegate>

//数据源
@property (strong, nonatomic) NSMutableArray * viewControllers;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIImageView *btnImageView;//按钮下面的图片层

@property (nonatomic, strong) XDChatupSquareController *squareVC;
@property (nonatomic, strong) XDMatchHomeController *matchVC;

@property (nonatomic, strong) HMSegmentedControl *segmentControl;

@property (strong, nonatomic) XDAreaModel * areaModel;

@end

@implementation XDActivitylistController

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView                                = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_Height - TabBar_Height)];
        _scrollView.showsVerticalScrollIndicator   = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled                  = YES;
        _scrollView.scrollEnabled                  = YES;
        _scrollView.alwaysBounceHorizontal         = YES;
        _scrollView.delegate                       = self;
        _scrollView.backgroundColor                = HEXCOLOR(0xf0eff5);
        _scrollView.contentSize                    = CGSizeMake(SCREEN_WIDTH * self.segmentControl.sectionTitles.count, 0);
        [self.view addSubview:_scrollView];
        
    }
    return _scrollView;
}

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = DefaultColor_BG_gray;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor blackColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    
    [self xdd_setupNavbar];
    
    [self.scrollView class];

    [self scrollviewDidScrollWithIndex:0];
}

#pragma mark - scrollDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    int currentPage   = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self scrollviewDidScrollWithIndex:currentPage];
    [self.segmentControl setSelectedSegmentIndex:currentPage animated:YES];
}

#pragma mark - Network
/**
 判断女生是否还能发布救我
 
 @param _successBlock block
 */
- (void)judgeCanPostMessage:(void(^)(BOOL successObj))_successBlock {
    [FKL_DataService requestURL:[NSString url_judgeCanRelease_saveme_withUsrID:User_ID] parameters:nil withType:@"GET" format:@"JSON" complete:^(id result) {
        NSLog(@"%@",result);
        if ([[result objectForKey:@"code"] intValue] == 200) {
            if (_successBlock) {
                _successBlock(YES);
            }
        }
        else {
            if (_successBlock) {
                _successBlock(NO);
            }
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
        if (_successBlock) {
            _successBlock(NO);
        }
    }];
}

/**
 移动scrollview
 懒加载tableview
 @param index 页数
 */
- (void)scrollviewDidScrollWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            if (!self.squareVC) {
                XDChatupSquareController *activityVC = [[XDChatupSquareController alloc] init];
                activityVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                [_scrollView addSubview:activityVC.view];
                [self addChildViewController:activityVC];
                self.squareVC = activityVC;
            }
        }
            break;
        case 1:
        {
            if (!self.matchVC) {
                XDMatchHomeController *matchVC = [[XDMatchHomeController alloc] init];
                matchVC.view.frame = CGRectMake(SCREEN_WIDTH * 1, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_Height - TabBar_Height);
                [self addChildViewController:matchVC];
                [self.scrollView addSubview:matchVC.view];
                self.matchVC = matchVC;
            }
        }
            break;
        default:
            break;
    }
    self.scrollView.contentOffset = CGPointMake(SCREEN_WIDTH*index, 0);
    [self changePageEvent:index];
}

/**
 scrollview滚动
 page=2 =3的时候 右按钮显示出来
 其他隐藏
 
 @param page page
 */
- (void)changePageEvent:(NSInteger)page {
    self.leftButton.tag = page;
    self.rightButton.tag = page;
    
    if (page == 0) {
        self.leftButton.hidden = YES;
        [self.rightButton setImage:[UIImage imageNamed:@"shaixuan"] forState:UIControlStateNormal];
        
    } else {
        self.leftButton.hidden = NO;
        [self.rightButton setImage:[UIImage imageNamed:@"navigationBar_activity_record"] forState:UIControlStateNormal];
    }
}

/**
 点击右上角状态
 
 @param sender sender
 */
- (void)rightBtnClicked:(UIButton *)sender {
    if (self.rightButton.tag == 0) {
//        XDChatupScreenController *chatupController = [[XDChatupScreenController alloc] init];
//        chatupController.areaModel = self.squareVC.areaModel;
//        chatupController.sex = self.squareVC.sex;
//        chatupController.startAge = self.squareVC.startAge;
//        chatupController.endAge = self.squareVC.endAge;
//        chatupController.is_vip = self.squareVC.is_vip;
//
//        XD_WeakSelf
//        chatupController.downButtonClicked = ^(XDAreaModel *areaModel, NSString *startAge, NSString *endAge, NSString *sex, NSString *is_vip) {
//            XD_StrongSelf
//            self.squareVC.areaModel = areaModel;
//            self.squareVC.startAge = startAge;
//            self.squareVC.endAge = endAge;
//            self.squareVC.sex = sex;
//            self.squareVC.is_vip = is_vip;
//
//            [self.squareVC retryNewData];
//        };
//
//        [self.navigationController pushViewController:chatupController animated:YES];
        [self chatup];
    }
    else {
        XDMatchRecordController *recordVC = [[XDMatchRecordController alloc] init];
        [self.navigationController pushViewController:recordVC animated:YES];
    }
}

- (void)leftBtnClicked:(UIButton *)sender {
    if (self.rightButton.tag == 0) {
        
    } else {
        XDSeekHelpController *helpVC = [[XDSeekHelpController alloc] init];
        XDIntroduceModel *step1 = [[XDIntroduceModel alloc] init];
        step1.title = @"①填写资料 ";
        step1.des = [NSString stringWithFormat:@"·填写资料 展示你独特的一面\n·有选填和必填栏目\n·填的越详细 匹配成功率越大！"];
        
        XDIntroduceModel *step2 = [[XDIntroduceModel alloc] init];
        step2.title = @"②等待匹配";
        step2.des = [NSString stringWithFormat:@"·等待匹配，基于海量会员数据匹配\n·24小时出结果\n·也可申请人工匹配"];
        
        XDIntroduceModel *step3 = [[XDIntroduceModel alloc] init];
        step3.title = @"③匹配成功";
        step3.des = @"·匹配成功后将收到对方名片\n·可查看对方资料或直接加微信";
        
        XDIntroduceModel *step4 = [[XDIntroduceModel alloc] init];
        step4.title = @"④人工客服";
        step4.des = @"·人工客服，一对一在线服务，牵线搭桥\n·客服可协助匹配";
        
        helpVC.dataArray = @[step1,step2,step3,step4];
        XDNavigationController *nav = [[XDNavigationController alloc] initWithRootViewController:helpVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)xdd_setupNavbar {
    
    //左边按钮
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"navBar_activity_question"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -6;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftItem];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [rightBtn setImage:[UIImage imageNamed:@"navigationBar_activity_record"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightItem];
    self.leftButton = leftBtn;
    self.rightButton = rightBtn;
    self.segmentControl = [[HMSegmentedControl alloc]init];
    //self.segmentControl.sectionTitles = @[@"互撩广场",@"心动匹配"];
    self.segmentControl.sectionTitles = @[@"互撩广场"];
    self.segmentControl.backgroundColor = [UIColor clearColor];
    self.segmentControl.frame                        = CGRectMake(0, 0, 180, Normal_Height);
    self.segmentControl.segmentEdgeInset             = UIEdgeInsetsMake(0, 0, 0, 0);
    self.segmentControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.segmentControl.selectedSegmentIndex         = 0;
    self.segmentControl.selectionStyle               = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.segmentControl.selectionIndicatorLocation   = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentControl.selectionIndicatorColor      = ThemeColor1;
    self.segmentControl.selectionIndicatorHeight     = 2;
    self.segmentControl.titleTextAttributes          = @{
                                                         NSFontAttributeName : kPingFangBoldFont(12),
                                                         NSForegroundColorAttributeName : RGB(205, 205, 205)
                                                         };
    self.segmentControl.selectedTitleTextAttributes  = @{
                                                         NSFontAttributeName : kPingFangBoldFont(14),
                                                         NSForegroundColorAttributeName : kNav_Text_color
                                                         };
    
    self.navigationItem.titleView = self.segmentControl;
    
    XD_WeakSelf
    [self.segmentControl setIndexChangeBlock:^(NSInteger index) {
        XD_StrongSelf
        [self scrollviewDidScrollWithIndex:index];
    }];
}

//
-(void)chatup{

    XD_WeakSelf
    XDMultiSelectView *multiSelectView = [[XDMultiSelectView alloc] initWithArrayData:@[]];
    multiSelectView.areaModel = self.squareVC.areaModel;
    multiSelectView.sex = self.squareVC.sex;
    multiSelectView.startAge = self.squareVC.startAge;
    multiSelectView.endAge = self.squareVC.endAge;
    multiSelectView.is_vip = self.squareVC.is_vip;
    multiSelectView.selectType = teaseStyle;
    multiSelectView.XDMultiSelectViewBlock1 = ^(XDAreaModel * _Nonnull area, NSString * _Nonnull sex, NSString * _Nonnull is_vip, NSString * _Nonnull startAge, NSString * _Nonnull endAge) {
        XD_StrongSelf
        self.squareVC.areaModel = area;
        self.squareVC.sex = sex;
        self.squareVC.is_vip = is_vip;
        self.squareVC.startAge = startAge;
        self.squareVC.endAge = endAge;
        [self.squareVC retryNewData];
    };

    [multiSelectView show];
}


@end
