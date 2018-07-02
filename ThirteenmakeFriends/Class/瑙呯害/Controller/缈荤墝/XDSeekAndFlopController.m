//
//  XDSeekAndFlopController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/1/10.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDSeekAndFlopController.h"
#import "DateSegment.h"
//#import "XDFlopController.h"
#import "XDExclusiveListController.h"
#import "ICEFloatingWindow.h"
#import "XDSeekController.h"
#import "XDEditdataController.h"
#import "ProfileUser.h"
#import "XDAccountTool.h"
#import "XDAreaModel.h"
#import "XDSeekScreenController.h"
#import "XDScreenExclusiveController.h"

//#import "PublishSaveMeViewController.h"
//#import "XDSavemeController.h"
//#import "XDSavemeScreenController.h"
#import "XDSaveMesController.h"
#import "XDNewSavemeScreenController.h"
#import "XDSendSaveMeController.h"

#import "XDSeekHelpController.h"
#import "XDNavigationController.h"
#import "XDIntroduceModel.h"
#import "CYPromptCover.h"
#import "STPickerSingle.h"
#import "XDMultiSelectView.h"

@interface XDSeekAndFlopController ()<UIScrollViewDelegate,STPickerSingleDelegate>

//数据源
@property (strong, nonatomic) NSMutableArray * viewControllers;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) DateSegment *segment;

/**
 左右按钮以及小红点
 */
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIImageView *btnImageView;//按钮下面的图片层

@property (nonatomic, strong) XDExclusiveListController *viewExclusive;
//@property (nonatomic, strong) XDFlopController *flopVC;
@property (nonatomic, strong) XDSaveMesController *fireView;
@property (strong, nonatomic) XDSeekController *seekVC;

@property (nonatomic, strong) ICEFloatingWindow *addBtn;

/** 地区数组 */
@property (nonatomic ,strong) NSArray *areaArray;
/** 地区名数组 */
@property (nonatomic ,strong) NSArray *areaNameArray;
@property (strong, nonatomic) XDAreaModel * areaModel;
@property (copy, nonatomic) NSString * areaModelStr;

@end

@implementation XDSeekAndFlopController

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
        _scrollView.contentSize                    = CGSizeMake(SCREEN_WIDTH * self.segment.segmentControl.sectionTitles.count, 0);
        [self.view addSubview:_scrollView];

    }
    return _scrollView;
}

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationitem];

    [self.scrollView class];
    
    [self createScrollViewSubViews];
    
    [self newbieGuide];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSInteger currentPage = floor((self.scrollView.contentOffset.x - SCREEN_WIDTH / 2) / SCREEN_WIDTH) + 1;
    [self changePageEvent:currentPage];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    [self.addBtn hideFloatingWindow];
}

#pragma mark - scrollDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    int currentPage   = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self scrollviewDidScrollWithIndex:currentPage];
    [self.segment.segmentControl setSelectedSegmentIndex:currentPage animated:YES];
}

#pragma mark - Network
/**
 判断女生是否还能发布救我

 @param _successBlock block
 */
- (void)judgeCanPostMessage:(void(^)(BOOL successObj))_successBlock {
    [FKL_DataService requestURL:[NSString url_judgeCanRelease_saveme_withUsrID:User_ID] parameters:nil withType:@"GET" format:@"JSON" complete:^(id result) {
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

#pragma mark - private-method
/**
 初始化scrollview
 */
- (void)createScrollViewSubViews {
    self.addBtn = [[ICEFloatingWindow alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 78, SCREEN_HEIGHT-78 -TabBar_Height, 54, 54) WithImg:[UIImage imageNamed:@"seek_fire_button"]];
    XD_WeakSelf
    self.addBtn.addBtnclickBlock = ^(UIButton *btn) {
        XD_StrongSelf
        XDSendSaveMeController *sendVC = [[XDSendSaveMeController alloc] init];
        [self.navigationController pushViewController:sendVC animated:YES];
    };
    
    //约会 觅约
    XDSeekController *womanSeekVC      = [[XDSeekController alloc] init];
    womanSeekVC.view.frame           = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    womanSeekVC.view.backgroundColor = HEXCOLOR(0xf0eff5);
    [_scrollView addSubview:womanSeekVC.view];
    [self addChildViewController:womanSeekVC];
    self.seekVC = womanSeekVC;
}

/**
 初始化navigation
 */
- (void)createNavigationitem {
    self.navigationItem.title  = @"";
    _rightButton                       = [[UIButton alloc] initWithFrame:CGRectMake(30, 0, 30, 44)];
    [_rightButton setImage:[UIImage imageNamed:@"shaixuan"] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(didPressedToRighStateVC:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -12;
    
    UIButton *helpBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
    [helpBtn addTarget:self action:@selector(helpButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [helpBtn setImage:[UIImage imageNamed:@"seek_question"] forState:UIControlStateNormal];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:helpBtn];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,leftItem];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,rightItem];
    
    XD_WeakSelf
    _segment = [[DateSegment alloc]initWithFrame:CGRectMake(0, 2, 60 * 3, 40)];
    [_segment.segmentControl setIndexChangeBlock:^(NSInteger index) {
        XD_StrongSelf
        [self scrollviewDidScrollWithIndex:index];
    }];
    
    self.navigationItem.titleView = _segment;
}

- (void)helpButtonClicked {
    XDSeekHelpController *helpVC = [[XDSeekHelpController alloc] init];
    XDIntroduceModel *seek = [[XDIntroduceModel alloc] init];
    seek.title = @"什么是觅约？ ";
    seek.des = [NSString stringWithFormat:@"·平台验证筛选出的女生，通过官方约会的形式展现。\n·高端以上的会员可以报名，并扣除一定量%@。\n·报名成功后，女生的微信二维码通过客服发送给您。",coin_name];
    
    XDIntroduceModel *exclusive = [[XDIntroduceModel alloc] init];
    exclusive.title = @"什么是专属？ ";
    exclusive.des = [NSString stringWithFormat:@"·在觅约的基础上，筛选出质量更高的妹子。\n·至尊以上的会员可以报名，并扣除一定数量%@。\n·报名成功后，女生的微信二维码通过客服发送给您。",coin_name];
    
    XDIntroduceModel *saveme = [[XDIntroduceModel alloc] init];
    saveme.title = @"什么是救我？ ";
    saveme.des = @"·女生发布实时约会，经过后台审核发布。\n·初级以上的会员可以报名，女生同意后，成为好友。\n·您也可以发布救我信息。";
    helpVC.dataArray = @[seek,saveme,exclusive];
    XDNavigationController *nav = [[XDNavigationController alloc] initWithRootViewController:helpVC];
    [self presentViewController:nav animated:YES completion:nil];
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
            
        }
            break;
        case 1:
        {
            if (!self.fireView) {
                //救我
                XDSaveMesController *fireView = [[XDSaveMesController alloc] init];
                fireView.view.frame = CGRectMake(SCREEN_WIDTH * 1, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_Height - TabBar_Height);
                fireView.view.backgroundColor = HEXCOLOR(0xf0eff5);
                [self addChildViewController:fireView];
                [self.scrollView addSubview:fireView.view];
                self.fireView = fireView;
                
                [self addBtnNewbieGuide];
            }
        }
            break;
        case 2:
        {
            if (!self.viewExclusive) {
                //专属
                XDExclusiveListController *viewExclusive = [[XDExclusiveListController alloc] init];
                viewExclusive.view.frame = CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                viewExclusive.view.backgroundColor = HEXCOLOR(0xf0eff5);
                [self addChildViewController:viewExclusive];
                [self.scrollView addSubview:viewExclusive.view];
                self.viewExclusive = viewExclusive;
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
    if ([User_Sex isEqualToString:@"0"]) { // 男
        if (page == 1) {
            [self.addBtn showFloatingWindow];
        }
        else {
            [self.addBtn hideFloatingWindow];
        }
    }
    else {
        if (page == 1) {
            [self.addBtn showFloatingWindow];
        }
        else {
            [self.addBtn hideFloatingWindow];
        }
    }
    
    self.rightButton.tag = page;
}

/**
 点击右上角状态

 @param sender sender
 */
- (void)didPressedToRighStateVC:(UIButton *)sender {
    if (self.rightButton.tag == 0) {
        
//        XDSeekScreenController *certScreenVC = [[XDSeekScreenController alloc] init];
//        certScreenVC.areaModel = self.seekVC.areaModel;
//        XD_WeakSelf
//        certScreenVC.downButtonClicked = ^(XDAreaModel *areaModel) {
//            XD_StrongSelf
//            self.seekVC.areaModel = areaModel;
//            [self.seekVC retryNewData];
//        };
//        [self.navigationController pushViewController:certScreenVC animated:YES];
    
        [self setupAreaInfo:0];
    }
    else if (self.rightButton.tag == 1) {
//        XDNewSavemeScreenController *certScreenVC = [[XDNewSavemeScreenController alloc] init];
//        certScreenVC.areaName = self.fireView.areaName;
//        certScreenVC.areaID = self.fireView.areaID;
//        certScreenVC.sex = self.fireView.sex;
//        certScreenVC.is_self = self.fireView.is_self;
//        XD_WeakSelf
//        certScreenVC.downButtonClicked = ^(NSString *areaID, NSString *areaName, NSString *sex, BOOL is_self) {
//            XD_StrongSelf
//            self.fireView.areaName = areaName;
//            self.fireView.areaID = areaID;
//            self.fireView.sex = sex;
//            self.fireView.is_self = is_self;
//            [self.fireView retryNewData];
//        };
//        [self.navigationController pushViewController:certScreenVC animated:YES];
    
           [self setupSavemeInfo];
    }
    else if (self.rightButton.tag == 2) {
//        XDScreenExclusiveController *certScreenVC = [[XDScreenExclusiveController alloc] init];
//        certScreenVC.areaModel = self.viewExclusive.areaModel;
//        XD_WeakSelf
//        certScreenVC.downButtonClicked = ^(NSString *areaModel) {
//            XD_StrongSelf
//            self.viewExclusive.areaModel = areaModel;
//            [self.viewExclusive retryNewData];
//        };
//        [self.navigationController pushViewController:certScreenVC animated:YES];
        
        [self setupAreaInfoExclusive];
    }
}

#pragma mark - 新手引导
- (void)newbieGuide {
    
    if (!myAppDelegate.newVersion) {
        return;
    }
    
    CGFloat imgWidth = 40;
    CGFloat imgHeight = 40;
    CGFloat marginW = (60 - 40) / 2.0;
    
    CYPromptCoverViewQueue *queue = [[CYPromptCoverViewQueue alloc] init];
    
    CYPromptCoverView *cover0 = [[CYPromptCoverView alloc] initWithRevalView:nil layoutType:CYPromptCoverViewLayoutTypeRightDown];
    cover0.revealType = CYPromptCoverViewRevealTypeOval;
    cover0.insetX = 0;
    cover0.insetY = 0;
    cover0.revealFrame = CGRectMake(self.view.centerX - 30 - 60 + marginW, kStatusBarHeight, imgWidth, imgHeight);
    cover0.des = @"约会";
    cover0.detailDes = @"官方认证女生";
    
    CYPromptCoverView *cover1 = [[CYPromptCoverView alloc] initWithRevalView:nil layoutType:CYPromptCoverViewLayoutTypeRightDown];
    cover1.revealType = CYPromptCoverViewRevealTypeOval;
    cover1.insetX = 0;
    cover1.insetY = 0;
    cover1.revealFrame = CGRectMake(self.view.centerX - 30 + marginW, kStatusBarHeight, imgWidth, imgHeight);
    cover1.des = @"救我";
    cover1.detailDes = @"约会自主发布";
    
    CYPromptCoverView *cover2 = [[CYPromptCoverView alloc] initWithRevalView:nil layoutType:CYPromptCoverViewLayoutTypeLeftDown];
    cover2.revealType = CYPromptCoverViewRevealTypeOval;
    cover2.insetX = 0;
    cover2.insetY = 0;
    cover2.revealFrame = CGRectMake(self.view.centerX + 30 + marginW, kStatusBarHeight, imgWidth, imgHeight);
    cover2.des = @"专属";
    cover2.detailDes = @"官方优质女生";
    
    [queue addPromptCoverView:cover0];
    [queue addPromptCoverView:cover1];
    [queue addPromptCoverView:cover2];
    
    [queue showCoversInView:self.tabBarController.view];
}

/**
 加号引导
 */
- (void)addBtnNewbieGuide {
    
    if (!myAppDelegate.newVersion) {
        return;
    }
    
    CYPromptCoverView *cover0 = [[CYPromptCoverView alloc] initWithRevalView:self.addBtn.window layoutType:CYPromptCoverViewLayoutTypeLeftUP];
    cover0.revealType = CYPromptCoverViewRevealTypeOval;
    cover0.insetX = 8;
    cover0.insetY = 8;
    cover0.des = nil;
    cover0.detailDes = @"点击按钮可自主发布约会消息";
    
    [cover0 showInView:self.tabBarController.view];
}

#pragma mark - 获取地区信息
/**
 *  获取地区信息
 */
- (void)setupAreaInfo:(NSInteger)tag {
    [XDRequestHttpTool request_getSeekAreaInfo_withParameters:nil complete:^(id result) {
        if ([result[@"code"] integerValue] == 200) {
            NSArray *areaArray = [XDAreaModel objectArrayWithKeyValuesArray:result[@"data"]];
            self.areaArray = areaArray;
            NSMutableArray *areaArr = [NSMutableArray array];
            [areaArr addObject:@"不限"];
            for (XDAreaModel *area in areaArray) {
                [areaArr addObject:area.area];
            }
            self.areaNameArray = areaArr;
        } else {
            [self.view makeToast:result[@"message"]
                        duration:2.0
                        position:CSToastPositionCenter];
        }
        if (tag == 0) {
            [self showSTPickerSingle:0];
        }
        if (tag == 1) {
            [self setupSavemeInfo];
        }
        
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeToast:error.localizedDescription
                    duration:2.0
                    position:CSToastPositionCenter];
        
    }];
}


#pragma mark - 获取地区信息
/**
 *  获取地区信息
 */
- (void)setupAreaInfoExclusive {
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"area"] = @"1";
    [FKL_DataService requestURL:[NSString url_getExclusiveRegionInfo] parameters:paras withType:@"GET" format:@"JSON" complete:^(id result) {
        NSLog(@"%@",result);
        NSMutableArray *arr = [NSMutableArray arrayWithArray:result];
        [arr insertObject:@"不限" atIndex:0];
        self.areaNameArray = arr;
        [self showSTPickerSingle:2];
        
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeToast:error.localizedDescription
                    duration:2.0
                    position:CSToastPositionCenter];
    }];
}

#pragma mark - STPickerSingleDelegate
- (void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle{
    NSString *text = [NSString stringWithFormat:@"%@", selectedTitle];
    NSUInteger index = [self.areaNameArray indexOfObject:text];
    if (pickerSingle.tag == 0) {
        if (index > 0) {
            self.areaModel = [self.areaArray objectAtIndex:index-1];
        } else {
            self.areaModel = nil;
        }
        self.seekVC.areaModel = self.areaModel;
        [self.seekVC retryNewData];
    }else  if (pickerSingle.tag == 2) {
        if (index > 0) {
            self.areaModelStr = [self.areaNameArray objectAtIndex:index];
        } else {
            self.areaModelStr = nil;
        }
        self.viewExclusive.areaModel = self.areaModelStr;
        [self.viewExclusive retryNewData];
    }
}

-(void)showSTPickerSingle:(NSInteger)tag{
    if (self.areaNameArray.count == 0) {
        [self.view makeToast:@"觅约地区信息获取失败，请重试"
                    duration:2.0
                    position:CSToastPositionCenter];
        //            [self setupAreaInfo];
        return ;
    }
    
    STPickerSingle *single = [[STPickerSingle alloc]init];

    single.tag    = tag;
    [single setArrayData:(NSMutableArray *)self.areaNameArray];
    [single setTitle:@"请选择地区"];
    [single setTitleUnit:@""];
    [single setDelegate:self];
    [single show];
}

-(void)setupSavemeInfo{
//    if (self.areaNameArray.count == 0) {
//        [self.view makeToast:@"觅约地区信息获取失败，请重试"
//                    duration:2.0
//                    position:CSToastPositionCenter];
//        //            [self setupAreaInfo];
//        return ;
//    }
     XD_WeakSelf
    XDMultiSelectView *multiSelectView = [[XDMultiSelectView alloc] initWithArrayData:self.areaNameArray];
    multiSelectView.areaModel = self.fireView.areaModel;
    multiSelectView.sex = self.fireView.sex;
    multiSelectView.is_self = self.fireView.isself;
    multiSelectView.selectType = saveMeStyle;
    multiSelectView.XDMultiSelectViewBlock = ^(XDAreaModel*area, NSString * _Nonnull sex, NSString* is_self) {
        XD_StrongSelf
        self.fireView.areaModel = area;
        self.fireView.sex = sex;
        self.fireView.isself = is_self;
        [self.fireView retryNewData];
    };
    [multiSelectView show];
}
@end
