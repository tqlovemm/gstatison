//
//  XHTwitterPaggingViewer.m
//  XHTwitterPagging
//
//  Created by 曾 宪华 on 14-6-20.
//  Copyright (c) 2014年 曾宪华 QQ群: (142557668) QQ:543413507  Gmail:xhzengAIB@gmail.com. All rights reserved.
//

#import "HTPaggingViewer.h"
#import "HTPaggingNavbar.h"
typedef NS_ENUM(NSInteger, XHSlideType) {
    XHSlideTypeLeft = 0,
    XHSlideTypeRight = 1,
};

@interface HTPaggingViewer () <UIScrollViewDelegate>

@property (nonatomic ,strong) UIScrollView *headScrollView;  //  顶部滚动视图
@property (nonatomic ,strong) NSArray *headArray;
/**
 *  显示内容的容器
 */
@property (nonatomic, strong) UIView *centerContainerView;
@property (nonatomic, strong) UIScrollView *paggingScrollView;

/**
 *  显示title集合的容器
 */
@property (nonatomic, strong) HTPaggingNavbar *paggingNavbar;

/**
 *  标识当前页码
 */
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger lastPage;

@property (nonatomic, strong) UIViewController *leftViewController;

@property (nonatomic, strong) UIViewController *rightViewController;

/**
 *  标记 ScrollVeiw offset
 */
@property (nonatomic, assign) CGFloat lastContentOffsetX;
@property (nonatomic, assign) CGFloat lastContentOffset;

@end

@implementation HTPaggingViewer

#pragma mark - Action



#pragma mark - DataSource

- (NSInteger)getCurrentPageIndex {
    return self.currentPage;
}

- (void)setCurrentPage:(NSInteger)currentPage animated:(BOOL)animated {
    if (abs((int)(currentPage-self.currentPage)) >= 2) {
        animated = NO;
    }
    
    self.currentPage = currentPage;
    
    CGFloat pageWidth = CGRectGetWidth(self.paggingScrollView.frame);
    
    CGPoint contentOffset = self.paggingScrollView.contentOffset;
    contentOffset.x = currentPage * pageWidth;
 
    [self.paggingScrollView setContentOffset:contentOffset animated:animated];
}



- (void)reloadData {
    if (!self.viewControllers.count) {
        return;
    }
    
    [self.paggingScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop) {
        [self addChildViewController:viewController];
        [self.paggingScrollView addSubview:viewController.view];
        CGRect contentViewFrame = viewController.view.bounds;
        contentViewFrame.origin.y = 0;
        contentViewFrame.origin.x = idx * CGRectGetWidth(self.view.bounds);
        contentViewFrame.size.width = CGRectGetWidth(self.view.bounds);
        contentViewFrame.size.height = CGRectGetHeight(self.view.bounds);
        viewController.view.frame = contentViewFrame;
    }];
    
    [self.paggingScrollView setContentSize:CGSizeMake(CGRectGetWidth(self.view.bounds) * self.viewControllers.count, 0)];
    
    
    [self.paggingNavbar reloadData];
    
    [self setupScrollToTop];
    [self callBackChangedPage];
}

#pragma mark - Propertys

- (UIColor *)navBarButtonNormalColor {
    if (_navBarButtonNormalColor == nil) {
        return [UIColor whiteColor];
    }
    return _navBarButtonNormalColor;
}

- (UIColor *)navBarButtonSelectedColor {
    if (_navBarButtonSelectedColor == nil) {
        return [UIColor yellowColor];
    }
    return _navBarButtonSelectedColor;
}

- (UIColor *)navBarButtonLineViewColor {
    if (_navBarButtonLineViewColor == nil) {
        return [UIColor whiteColor];
    }
    return _navBarButtonLineViewColor;
}

- (UIView *)centerContainerView {
    if (!_centerContainerView) {
        _centerContainerView = [[UIView alloc] initWithFrame:self.view.bounds];
        _centerContainerView.backgroundColor = self.view.backgroundColor;
        
        [_centerContainerView addSubview:self.paggingScrollView];
        [self.paggingScrollView.panGestureRecognizer addTarget:self action:@selector(panGestureRecognizerHandle:)];
    }
    return _centerContainerView;
}

- (UIScrollView *)paggingScrollView {
    if (!_paggingScrollView) {
        _paggingScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _paggingScrollView.bounces = NO;
        _paggingScrollView.pagingEnabled = YES;
        [_paggingScrollView setScrollsToTop:NO];
        _paggingScrollView.delegate = self;
        _paggingScrollView.showsVerticalScrollIndicator = NO;
        _paggingScrollView.showsHorizontalScrollIndicator = NO;
//        _paggingScrollView.scrollEnabled = YES;
        _paggingScrollView.scrollEnabled = NO;
    }
    return _paggingScrollView;
}

- (HTPaggingNavbar *)paggingNavbar {
        if (_paggingNavbar == nil) {
//            _paggingNavbar = [[HTPaggingNavbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width -(self.viewControllers.count ==2?120:30), 31) withNumber:self.viewControllers.count withTitles:[self.viewControllers valueForKey:@"title"] NormalColor:self.navBarButtonNormalColor SelectedColor:self.navBarButtonSelectedColor];
            // 根据个数调整宽度
            _paggingNavbar = [[HTPaggingNavbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width -(self.viewControllers.count ==2?200:30), 31) withNumber:self.viewControllers.count withTitles:[self.viewControllers valueForKey:@"title"] NormalColor:self.navBarButtonNormalColor SelectedColor:self.navBarButtonSelectedColor];
            
            _paggingNavbar.backgroundColor = [UIColor clearColor];
            
            __weak typeof(self) weakSelf = self;
            _paggingNavbar.didChangedIndex = ^(NSInteger index) {
                [weakSelf setCurrentPage:index animated:YES];
            };
        }
    return _paggingNavbar;
}

- (UIViewController *)getPageViewControllerAtIndex:(NSInteger)index {
    if (index < self.viewControllers.count) {
        return self.viewControllers[index];
    } else {
        return nil;
    }
}

- (void)setCurrentPage:(NSInteger)currentPage {
    if (_currentPage == currentPage)
        return;
    _lastPage = _currentPage;
    _currentPage = currentPage;
    
    self.paggingNavbar.currentPage = currentPage;
    
    [self callBackChangedPage];
}

#pragma mark - Life Cycle

- (void)setupTargetViewController:(UIViewController *)targetViewController withSlideType:(XHSlideType)slideType {
    if (!targetViewController)
        return;
    
    [self addChildViewController:targetViewController];
    CGRect targetViewFrame = targetViewController.view.frame;
    switch (slideType) {
        case XHSlideTypeLeft: {
            targetViewFrame.origin.x = -CGRectGetWidth(self.view.bounds);
            break;
        }
        case XHSlideTypeRight: {
            targetViewFrame.origin.x = CGRectGetWidth(self.view.bounds) * 2;
            break;
        }
        default:
            break;
    }
    targetViewController.view.frame = targetViewFrame;
    [self.view insertSubview:targetViewController.view atIndex:0];
    [targetViewController didMoveToParentViewController:self];
}

- (instancetype)initWithLeftViewController:(UIViewController *)leftViewController {
    return [self initWithLeftViewController:leftViewController rightViewController:nil];
}

- (instancetype)initWithRightViewController:(UIViewController *)rightViewController {
    return [self initWithLeftViewController:nil rightViewController:rightViewController];
}

- (instancetype)initWithLeftViewController:(UIViewController *)leftViewController rightViewController:(UIViewController *)rightViewController {
    self = [super init];
    if (self) {
        self.leftViewController = leftViewController;
        
        self.rightViewController = rightViewController;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Ensure that the paggingScrollView is the correct height.
    // This facilitates situations where the XHTwitterPaggingViewer is shown within
    // a UITabBarController.
    CGRect scrollViewFrame = self.paggingScrollView.frame;
    scrollViewFrame.size.height = self.view.frame.size.height;
    self.paggingScrollView.frame = scrollViewFrame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
//    [self setupNavigationBarForTitleView];
    [self setupNavigationBarForRightView];
    [self setupViews];
    
    [self reloadData];
}

- (void)setupNavigationBarForRightView {
//     UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.paggingNavbar];
     self.navigationItem.titleView = self.paggingNavbar;
}


- (void)setupViews {
    [self.view addSubview:self.centerContainerView];
    
    [self setupTargetViewController:self.leftViewController withSlideType:XHSlideTypeLeft];
    [self setupTargetViewController:self.rightViewController withSlideType:XHSlideTypeRight];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    _paggingScrollView.delegate = nil;
    _paggingScrollView = nil;
    
    _paggingNavbar = nil;
    
    _viewControllers = nil;
    
    _didChangedPageCompleted = nil;
}

#pragma mark - PanGesture Handle Method

- (void)panGestureRecognizerHandle:(UIPanGestureRecognizer *)panGestureRecognizer {
    /*
    CGPoint contentOffset = self.paggingScrollView.contentOffset;
    
    CGSize contentSize = self.paggingScrollView.contentSize;
    
    CGFloat baseWidth = CGRectGetWidth(self.paggingScrollView.bounds);
    
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint translationPoint = [panGestureRecognizer translationInView:panGestureRecognizer.view];
            if (contentOffset.x <= 0) {
                // 滑动到最左边
                
                CGRect centerContainerViewFrame = self.centerContainerView.frame;
                centerContainerViewFrame.origin.x += translationPoint.x;
                self.centerContainerView.frame = centerContainerViewFrame;
                
                CGRect leftMenuViewFrame = self.leftViewController.view.frame;
                leftMenuViewFrame.origin.x += translationPoint.x;
                self.leftViewController.view.frame = leftMenuViewFrame;
                
                [panGestureRecognizer setTranslation:CGPointZero inView:panGestureRecognizer.view];
            } else if (contentOffset.x >= contentSize.width - baseWidth) {
                // 滑动到最右边
                [panGestureRecognizer setTranslation:CGPointZero inView:panGestureRecognizer.view];
            }
            break;
        }
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            // 判断是否打开或关闭Menu
            break;
        }
        default:
            break;
    }
    */
}

#pragma mark - Block Call Back Method

- (void)callBackChangedPage {
    UIViewController *fromViewController = [self.viewControllers objectAtIndex:self.lastPage];
    UIViewController *toViewController = [self.viewControllers objectAtIndex:self.currentPage];

    [fromViewController viewWillDisappear: true];
    [fromViewController viewDidDisappear: true];
    [toViewController viewWillAppear: true];
    [toViewController viewDidAppear: true];

    if (self.didChangedPageCompleted) {
        self.didChangedPageCompleted(self.currentPage, [[self.viewControllers valueForKey:@"title"] objectAtIndex:self.currentPage]);
    }
    
   
}

#pragma mark - TableView Helper Method

- (void)setupScrollToTop {
   
}

#pragma mark - View Helper Method

- (UIView *)subviewWithClass:(Class)cuurentClass onView:(UIView *)view {
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:cuurentClass]) {
            return subView;
        }
    }
    return nil;
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.paggingNavbar.contentOffset = scrollView.contentOffset;
//    /** 判断 scrollView 滚动方向**/
//    ScrollDirection scrollDirection = ScrollDirectionLeft;
//    if (self.lastContentOffset > scrollView.contentOffset.x)
//        scrollDirection = ScrollDirectionRight;
//    else if (self.lastContentOffset < scrollView.contentOffset.x)
//        scrollDirection = ScrollDirectionLeft;
//    self.lastContentOffset = scrollView.contentOffset.x;
//    //逻辑处理
//    CGFloat xOffset = scrollView.contentOffset.x;
//    CGFloat mainScreenWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
//    NSInteger nowIndex = xOffset/mainScreenWidth;
//    NSInteger toIndex = 0;
//    if (scrollDirection == ScrollDirectionLeft) {
//        // scrollview 向左滚动 pageIndex++
//        toIndex = (nowIndex + 1 >= self.viewControllers.count-1) ?  self.viewControllers.count-1 : nowIndex + 1;
//        EZBBaseViewController *fromController = [self.viewControllers objectAtIndex:nowIndex];
//        EZBBaseViewController *toController = [self.viewControllers objectAtIndex:toIndex];
//        if (fromController.mainModalView.hidden || toController.mainModalView.hidden)
//        {
//            toController.mainModalView.hidden = NO;
//            fromController.mainModalView.hidden = NO;
//        }
//        CGFloat progress =  xOffset/mainScreenWidth;
//        if (progress > 1.0f) {
//            progress -= 1;
//        }
//        fromController.mainModalView.alpha = progress;
//        toController.mainModalView.alpha = 1.0- progress;
//        if (progress >= 1.0f || progress <= 0.0f) {
//            toController.mainModalView.hidden = YES;
//            fromController.mainModalView.hidden = YES;
//        }
//    }else if (scrollDirection == ScrollDirectionRight){
//        // scrollview 向右滚动 pageIndex--
//        nowIndex += 1;
//        toIndex = (nowIndex - 1 >= self.viewControllers.count-1) ?  self.viewControllers.count-1: nowIndex - 1;
//        if (nowIndex > self.viewControllers.count-1) {
//            return;
//        }
//        EZBBaseViewController *fromController = [self.viewControllers objectAtIndex:nowIndex];
//        EZBBaseViewController *toController = [self.viewControllers objectAtIndex:toIndex];
//        if (fromController.mainModalView.hidden || toController.mainModalView.hidden)
//        {
//            toController.mainModalView.hidden = NO;
//            fromController.mainModalView.hidden = NO;
//        }
//        CGFloat progress =  xOffset/mainScreenWidth;
//        if (progress > 1.0f) {
//            progress -= 1;
//        }
//        fromController.mainModalView.alpha = 1.0-progress;
//        toController.mainModalView.alpha = progress;
//        if (progress >= 1.0f || progress <= 0.0f) {
//            toController.mainModalView.hidden = YES;
//            fromController.mainModalView.hidden = YES;
//        }
//    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 得到每页宽度
    CGFloat pageWidth = CGRectGetWidth(self.paggingScrollView.frame);
    
    // 根据当前的x坐标和页宽度计算出当前页数
    self.currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
}


@end
