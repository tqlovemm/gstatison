//
//  XDNavigationController.m
//  约high
//
//  Created by Xudongdong on 15/11/10.
//  Copyright © 2015年 ThirtyOneDay. All rights reserved.
//

#import "XDNavigationController.h"

@interface XDNavigationController ()

@end

@implementation XDNavigationController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/**
 *  当导航控制器的view创建完毕就调用
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置UINavigationBarTheme的主题
    [self setupNavigationBarTheme];
    
    // 设置UIBarButtonItem的主题
    [self setupBarButtonItemTheme];

}

///**
// *  当第一次使用这个类的时候调用（只会被调用1次）
// */
//+ (void)initialize
//{
//    // 设置UINavigationBarTheme的主题
//    [self setupNavigationBarTheme];
//    
//    // 设置UIBarButtonItem的主题
//    [self setupBarButtonItemTheme];
//}

/**
 *  设置UINavigationBarTheme的主题
 */
- (void)setupNavigationBarTheme
{
    UINavigationBar *appearance = [UINavigationBar appearance];
    [appearance setBarTintColor:NavigationBarColor];
    
//    [appearance setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [appearance setBackgroundImage:[UIImage imageWithColor:NavigationBarColor] forBarMetrics:UIBarMetricsDefault];
    
    //去除 navigationBar 底部的细线
    appearance.shadowImage = nil;
    
    // 设置文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = kNav_Text_color;
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowOffset = CGSizeZero;
    textAttrs[NSShadowAttributeName] = shadow;
    [appearance setTitleTextAttributes:textAttrs];
}

/**
 *  设置UIBarButtonItem的主题
 */
- (void)setupBarButtonItemTheme
{
    // 通过appearance对象能修改整个项目中所有UIBarButtonItem的样式
    UIBarButtonItem *appearance = [UIBarButtonItem appearance];
    
    /**设置文字属性**/
    // 设置普通状态的文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = NormalNavBtnColor;
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowOffset = CGSizeZero;
    textAttrs[NSShadowAttributeName] = shadow;
    [appearance setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置高亮状态的文字属性
    NSMutableDictionary *highTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    highTextAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [appearance setTitleTextAttributes:highTextAttrs forState:UIControlStateHighlighted];
    
    // 设置不可用状态(disable)的文字属性
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [appearance setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
    
    /**设置背景**/
    // 技巧: 为了让某个按钮的背景消失, 可以设置一张完全透明的背景图片
//    [appearance setBackgroundImage:[UIImage imageWithName:@"navigationbar_button_background"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

/**
 *  能拦截所有push进来的子控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0 && ([viewController isKindOfClass:NSClassFromString(@"MMEmotionDetailViewController")] || [viewController isKindOfClass:NSClassFromString(@"SMDetailViewController")])) { // 判断是不是表情包详情，是就不增加返回按钮
        viewController.navigationItem.leftBarButtonItems = @[];
    } else if (self.viewControllers.count > 0) { // 如果现在push的不是栈底控制器(最先push进来的那个控制器)
        viewController.hidesBottomBarWhenPushed = YES;
        
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [backButton setImage:[UIImage imageNamed:@"gray_back"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -12;
        viewController.navigationItem.leftBarButtonItems = @[negativeSpacer, backItem];
    }
    viewController.rt_disableInteractivePop = NO;
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

@end
