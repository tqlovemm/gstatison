//
//  XDSeekForGirlViewController.m
//  ThirteenmakeFriends
//
//  Created by iOS on 8/6/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDSeekForGirlViewController.h"
//#import "XDFlopController.h"
#import "Masonry.h"
#import "DateSegment.h"

#import "ICEFloatingWindow.h"
#import "XDEditdataController.h"
#import "ProfileUser.h"
#import "XDAccountTool.h"
//#import "XDFlopScreenController.h"
#import "XDAreaModel.h"

//#import "XDSavemeController.h"
//#import "XDSavemeScreenController.h"
//#import "PublishSaveMeViewController.h"
#import "XDSaveMesController.h"
#import "XDNewSavemeScreenController.h"
#import "XDSendSaveMeController.h"

#import "XDSeekHelpController.h"
#import "XDNavigationController.h"
#import "XDIntroduceModel.h"
#import "XDWomanSeekController.h"
#import "XDWomanSeekScreenController.h"
#import "XDSeekScreenController.h"
#import "CYPromptCover.h"

#import "STPickerSingle.h"
#import "XDMultiSelectView.h"

@interface XDSeekForGirlViewController ()<UIScrollViewDelegate,STPickerSingleDelegate>

//数据源
@property (strong, nonatomic) NSMutableArray * viewControllers;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) DateSegment *segment;

/**
 左右按钮以及小红点
 */
@property (nonatomic, strong) UIButton *rightButton;

//@property (nonatomic, strong) XDFlopController *flopVC;

@property (nonatomic, strong) XDSaveMesController *fireView;

@property (nonatomic, strong) XDWomanSeekController *womanSeekVC;

@property (nonatomic, strong) ICEFloatingWindow *addBtn;

/** 地区数组 */
@property (nonatomic ,strong) NSArray *areaArray;
@property (nonatomic ,strong) NSArray *areaNameArray;
@property (strong, nonatomic) XDAreaModel * areaModel;
@property (copy, nonatomic) NSString * areaModelStr;

@end

@implementation XDSeekForGirlViewController

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

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
    
    // 翻牌
    self.womanSeekVC = [[XDWomanSeekController alloc] init];
    self.womanSeekVC.view.frame = CGRectMake(SCREEN_WIDTH*0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_Height - TabBar_Height);
    self.womanSeekVC.view.backgroundColor = [UIColor yellowColor];
    [self.scrollView addSubview:self.womanSeekVC.view];
    [self addChildViewController:self.womanSeekVC];
    
}

/**
 初始化navigation
 */
- (void)createNavigationitem {
    
    self.navigationItem.title = @"";
    
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 0, 30, 44)];
    [_rightButton setImage:[UIImage imageNamed:@"shaixuan"] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(didPressedToRighStateVC:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -12;
    
    UIButton *helpBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
    [helpBtn addTarget:self action:@selector(helpButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [helpBtn setImage:[UIImage imageNamed:@"seek_question"] forState:UIControlStateNormal];
    
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,saveItem];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:helpBtn];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,leftItem];
    
    XD_WeakSelf
    _segment = [[DateSegment alloc]initWithFrame:CGRectMake(0, 2, 60 * 3, 40)];
    [_segment.segmentControl setIndexChangeBlock:^(NSInteger index) {
        XD_StrongSelf
        [self scrollviewDidScrollWithIndex:index];
    }];
    _segment.isMan                        = NO;
    self.navigationItem.titleView = _segment;
}

- (void)helpButtonClicked {
    XDSeekHelpController *helpVC = [[XDSeekHelpController alloc] init];
    XDIntroduceModel *seek = [[XDIntroduceModel alloc] init];
    seek.title = @"什么是约会？ ";
    seek.des = [NSString stringWithFormat:@"·平台验证筛选出的男生，通过官方约会的形式展现。\n·您可以进行报名，并扣除一定数量%@。\n·报名成功后，男生的微信二维码通过客服发送给您。",coin_name];
    
    XDIntroduceModel *flop = [[XDIntroduceModel alloc] init];
    flop.title = @"什么是翻牌？ ";
//    flop.des = @"·向右滑动或者点击❤️号表示喜欢，被喜欢的男生将直接收到你的提醒。\n·向左滑动或者点击❌号表示不喜欢，你将不会再看到TA。";
    flop.des = @"·平台的男生档案以翻牌子的形式展现。\n·右滑或者点击❤️表示喜欢此男生。\n·您喜欢的男生将即刻收到消息。";
    
    XDIntroduceModel *saveme = [[XDIntroduceModel alloc] init];
    saveme.title = @"什么是救我？ ";
    saveme.des = @"·男生发布实时约会，经过后台审核发布。\n·您可以报名，男生同意后，成为好友。\n·您也可以发布救我信息。";
    helpVC.dataArray = @[seek,flop,saveme];
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
//            if (!self.flopVC) {
//                //救我
//                XDFlopController *flopVC = [[XDFlopController alloc] init];
//                flopVC.view.frame = CGRectMake(SCREEN_WIDTH * 1, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//                flopVC.view.backgroundColor = [UIColor whiteColor];
//                [self addChildViewController:flopVC];
//                [self.scrollView addSubview:flopVC.view];
//                self.flopVC = flopVC;
//            }
//        }
//            break;
//        case 2:
//        {
            if (!self.fireView) {
                //救我
                XDSaveMesController *fireView = [[XDSaveMesController alloc] init];
                fireView.view.frame = CGRectMake(SCREEN_WIDTH * index, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_Height - TabBar_Height);
                fireView.view.backgroundColor = HEXCOLOR(0xf0eff5);
                [self addChildViewController:fireView];
                [self.scrollView addSubview:fireView.view];
                self.fireView = fireView;
                
                [self addBtnNewbieGuide];
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
    if ([User_Sex isEqualToString:@"1"]) { // 女
        if (page == 1) {
            [self.addBtn showFloatingWindow];
        }
        else {
            [self.addBtn hideFloatingWindow];
        }
    }
    else {
//        [self.addBtn hideFloatingWindow];
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
    
    if (self.rightButton.tag == 1) {
//        XDFlopScreenController *scrennVC = [[XDFlopScreenController alloc] init];
//        scrennVC.delegate = self;
//        scrennVC.areaModel = self.flopVC.areaModel;
//        scrennVC.heat = self.flopVC.heat;
//        [self.navigationController pushViewController:scrennVC animated:YES];
//    }
//    else if (self.rightButton.tag == 2) {
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
//
//        [self.navigationController pushViewController:certScreenVC animated:YES];
        
         [self setupSavemeInfo];
    } else if (self.rightButton.tag == 0) {
//        XDWomanSeekScreenController *seekVC = [[XDWomanSeekScreenController alloc] init];
//        XD_WeakSelf
//        seekVC.downButtonClicked = ^(XDAreaModel *areaModel) {
//            XD_StrongSelf
//            self.womanSeekVC.areaModel = areaModel;
//            [self.womanSeekVC retryNewData];
//        };
//        seekVC.areaModel = self.womanSeekVC.areaModel;
//        [self.navigationController pushViewController:seekVC animated:YES];
//        XDSeekScreenController *certScreenVC = [[XDSeekScreenController alloc] init];
//        certScreenVC.areaModel = self.womanSeekVC.areaModel;
//        XD_WeakSelf
//        certScreenVC.downButtonClicked = ^(XDAreaModel *areaModel) {
//            XD_StrongSelf
//            self.womanSeekVC.areaModel = areaModel;
//            [self.womanSeekVC retryNewData];
//        };
//        [self.navigationController pushViewController:certScreenVC animated:YES];
        
        [self setupAreaInfo:0];
    }
}

//#pragma mark- XDFlopScreenControllerDelegate
//- (void)updateInfoWithArea:(XDAreaModel *)area andHeat:(NSInteger)heat {
//    self.flopVC.areaModel = area;
//    self.flopVC.heat = heat;
//    [self.flopVC retryNewData];
//}

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
    cover0.revealFrame = CGRectMake(self.view.centerX - imgWidth - 25 , kStatusBarHeight, imgWidth, imgHeight);
    cover0.des = @"约会";
    cover0.detailDes = @"官方认证男生";
    
//    CYPromptCoverView *cover1 = [[CYPromptCoverView alloc] initWithRevalView:nil layoutType:CYPromptCoverViewLayoutTypeDown];
//    cover1.revealType = CYPromptCoverViewRevealTypeOval;
//    cover1.insetX = 0;
//    cover1.insetY = 0;
//    cover1.revealFrame = CGRectMake(self.view.centerX - 30 + marginW, kStatusBarHeight, imgWidth, imgHeight);
//    cover1.des = @"翻牌";
//    cover1.detailDes = @"在这里点击❤️，你们就可以开始聊天了";
    
    CYPromptCoverView *cover2 = [[CYPromptCoverView alloc] initWithRevalView:nil layoutType:CYPromptCoverViewLayoutTypeLeftDown];
    cover2.revealType = CYPromptCoverViewRevealTypeOval;
    cover2.insetX = 0;
    cover2.insetY = 0;
    cover2.revealFrame = CGRectMake(self.view.centerX  + 25 , kStatusBarHeight, imgWidth, imgHeight);
    cover2.des = @"救我";
    cover2.detailDes = @"约会自主发布";
    [queue addPromptCoverView:cover0];
//    [queue addPromptCoverView:cover1];
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
        [self showSTPickerSingle:tag];
        
      
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
        self.womanSeekVC.areaModel = self.areaModel;
        [self.womanSeekVC retryNewData];
    }else if (pickerSingle.tag == 1){
        
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
    multiSelectView.XDMultiSelectViewBlock = ^(XDAreaModel *areaModel, NSString * _Nonnull sex, NSString* is_self) {
        XD_StrongSelf
        self.fireView.areaModel = areaModel;
        self.fireView.sex = sex;
        self.fireView.isself = is_self ;
        [self.fireView retryNewData];
    };

    [multiSelectView show];
}
@end
