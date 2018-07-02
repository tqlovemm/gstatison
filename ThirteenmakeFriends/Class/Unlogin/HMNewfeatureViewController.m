//
//  HMNewfeatureViewController.m
//  XD-微博
//
//  Created by Xudongdong on 15/10/30.
//  Copyright © 2015年 Xudongdong. All rights reserved.
//

#define HMNewfeatureImageCount 3

#import "HMNewfeatureViewController.h"
//#import "XDUserSelectController.h"
#import "XDLoginSelectController.h"
#import "XDNavigationController.h"

#import "AppDelegate.h"

@interface HMNewfeatureViewController ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIPageControl *pageControl;
@end

@implementation HMNewfeatureViewController

- (UIStatusBarStyle)preferredStatusBarStyle{
    
#if APP_Puppet  // Puppet
    return UIStatusBarStyleLightContent;
#elif APP_myPuppet
    return UIStatusBarStyleLightContent;
#else // 正常
    return UIStatusBarStyleDefault;
#endif
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.添加UISrollView
    [self setupScrollView];
    
    // 2.添加pageControl
    [self setupPageControl];
}

/**
 *  添加UISrollView
 */
- (void)setupScrollView
{
    // 1.添加UISrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    // 2.添加图片
    CGFloat imageW = scrollView.width;
    CGFloat imageH = scrollView.height;
    for (int i = 0; i<HMNewfeatureImageCount; i++) {
        // 创建UIImageView
        UIImageView *imageView = [[UIImageView alloc] init];
        NSString *name = [NSString stringWithFormat:@"new_feature_%d.jpg", i + 1];
        
        imageView.image = [UIImage imageWithName:name];
        [scrollView addSubview:imageView];
        
        // 设置frame
        imageView.y = 0;
        imageView.width = imageW;
        imageView.height = imageH;
        imageView.x = i * imageW;
        
        // 给最后一个imageView添加按钮
        if (i == HMNewfeatureImageCount - 1) {
            [self setupLastImageView:imageView];
        }
    }
    
    // 3.设置其他属性
    scrollView.contentSize = CGSizeMake(HMNewfeatureImageCount * imageW, 0);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = RGB(246, 246, 246);
//#warning 别在scrollView.subviews中通过索引来查找对应的子控件
    //    [scrollView.subviews lastObject];
}

/**
 *  添加pageControl
 */
- (void)setupPageControl
{
    // 1.添加
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = HMNewfeatureImageCount;
    pageControl.centerX = self.view.width * 0.5;
    pageControl.centerY = self.view.height - 30;
    [self.view addSubview:pageControl];
	
    // 2.设置圆点的颜色
//    pageControl.currentPageIndicatorTintColor = ThemeColor1; // 当前页的小圆点颜色
	pageControl.currentPageIndicatorTintColor = RGB(252, 102, 132); // 当前页的小圆点颜色

    pageControl.pageIndicatorTintColor = RGB(189, 189, 189); // 非当前页的小圆点颜色
    self.pageControl = pageControl;
}

/**
 设置最后一个UIImageView中的内容
 */
- (void)setupLastImageView:(UIImageView *)imageView
{
    imageView.userInteractionEnabled = YES;
    
    // 1.添加开始按钮
    [self setupStartButton:imageView];
    
}

/**
 *  添加分享按钮
 */
- (void)setupShareButton:(UIImageView *)imageView
{
    // 1.添加分享按钮
    UIButton *shareButton = [[UIButton alloc] init];
    [imageView addSubview:shareButton];
    
    // 2.设置文字和图标
    [shareButton setTitle:@"分享给大家" forState:UIControlStateNormal];
    [shareButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [shareButton setImage:[UIImage imageWithName:@"new_feature_share_false"] forState:UIControlStateNormal];
    [shareButton setImage:[UIImage imageWithName:@"new_feature_share_true"] forState:UIControlStateSelected];
    // 监听点击
    [shareButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    
    // 3.设置frame
    shareButton.size = CGSizeMake(150, 35);
    shareButton.centerX = self.view.width * 0.5;
    shareButton.centerY = self.view.height * 0.7;

    shareButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
}

/**
 分享
 */
- (void)share:(UIButton *)shareButton
{
    shareButton.selected = !shareButton.isSelected;
}

/**
 *  添加开始按钮
 */
- (void)setupStartButton:(UIImageView *)imageView
{
    // 1.添加开始按钮
    UIButton *startButton = [[UIButton alloc] init];
//	UIColor *showc =RGB(251, 102, 131);
//	[startButton setTitle:@"开始" forState:UIControlStateNormal];
//	[startButton setTitleColor:showc forState:UIControlStateNormal];
//	startButton.layer.cornerRadius = 8;
//	startButton.clipsToBounds = YES;
//	startButton.layer.borderWidth = 2;
//	startButton.layer.borderColor = showc.CGColor;
	
    [imageView addSubview:startButton];
    
    // 2.设置背景图片
//    [startButton setBackgroundImage:[UIImage imageWithName:@"new_feature_finish_button"] forState:UIControlStateNormal];
//    [startButton setBackgroundImage:[UIImage imageWithName:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
    
    // 3.设置frame
//    startButton.size = startButton.currentBackgroundImage.size;
    startButton.size = CGSizeMake(SCREEN_WIDTH, 200);
//	startButton.size = CGSizeMake(100, 50);

    startButton.centerX = self.view.width * 0.5;
    startButton.centerY = self.view.height * 0.9;
    startButton.backgroundColor = [UIColor clearColor];
    
    // 4.设置文字
//    [startButton setTitle:@"点此进入十三交友平台" forState:UIControlStateNormal];
//    [startButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  开始App
 */
- (void)start
{
    if ([[[EaseMob sharedInstance] chatManager] isLoggedIn]) {
        [self logoutAction];
//        //发送自动登陆状态通知
//        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
    } else {
        [UIApplication sharedApplication].statusBarHidden = NO;
        
//        // 显示主控制器
//        XDUserSelectController *loginVC = [[XDUserSelectController alloc]init];
//        XDNavigationController *nav = [[XDNavigationController alloc]initWithRootViewController:loginVC];
        
        XDLoginSelectController *loginController = [[XDLoginSelectController alloc] init];
        XDNavigationController *nav = [[XDNavigationController alloc] initWithRootViewController:loginController];
        
        // 切换控制器
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window.rootViewController = nav;
    }
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 获得页码
    CGFloat doublePage = scrollView.contentOffset.x / scrollView.width;
    int intPage = (int)(doublePage + 0.5);
    
    // 设置页码
    self.pageControl.currentPage = intPage;
}

- (void)dealloc
{
    NSLog(@"新版本dealloc-------");
}

#pragma mark - 退出登录
- (void)logoutAction
{
    // 公钥加密
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    
    [FKL_DataService requestURL:[NSString url_loginout_clearCidWithUserId:User_ID] parameters:nil headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"DELETE" format:@"JSON" complete:^(id result) {
        if ([result[@"code"] integerValue] == 200) { // 删除成功
            
        } else if ([result[@"code"] integerValue] == 201) { // 不存在
            
        } else if ([result[@"code"] integerValue] == 202) { // 删除失败
            
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
    
    EMError *error = nil;
    [[EaseMob sharedInstance].chatManager logoffWithUnbindDeviceToken:YES error:&error];
    if (!error) {
        NSLog(@"退出成功");
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    }
}

@end
