//
//  XDTopicContainerController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/10/27.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDTopicContainerController.h"
#import "HMSegmentedControl.h"
#import "XDTopicListController.h"
#import "XDAllTopicsController.h"

@interface XDTopicContainerController ()<UIScrollViewDelegate>

@property (nonatomic, strong) HMSegmentedControl *segmentControl;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) XDTopicListController *listVC;

@property (nonatomic, strong) XDAllTopicsController *allTopicVC;

@end

@implementation XDTopicContainerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"更多标签";
    
    [self setupSegment];
    [self setupScrollView];
    self.view.backgroundColor = DefaultColor_BG_gray;
    
    [self setupIndex:self.selectIndex];
}

- (void)setupSegment {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Normal_Height)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    self.segmentControl                 = [[HMSegmentedControl alloc]initWithSectionTitles:@[@"推荐",@"全部"]];
    self.segmentControl.backgroundColor = [UIColor clearColor];
    self.segmentControl.frame                        = CGRectMake(0, 0, 120, Normal_Height);
    self.segmentControl.segmentEdgeInset             = UIEdgeInsetsMake(0, 0, 0, 0);
    self.segmentControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.segmentControl.selectedSegmentIndex         = 0;
    self.segmentControl.selectionStyle               = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.segmentControl.selectionIndicatorLocation   = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentControl.selectionIndicatorColor      = ThemeColor3;
    self.segmentControl.selectionIndicatorHeight     = 2;
    self.segmentControl.titleTextAttributes          = @{
                                                         NSFontAttributeName : kPingFangBoldFont(14),
                                                         NSForegroundColorAttributeName : RGB(119, 119, 119)
                                                         };
    self.segmentControl.selectedTitleTextAttributes  = @{
                                                         NSFontAttributeName : kPingFangBoldFont(16),
                                                         NSForegroundColorAttributeName : ThemeColor3
                                                         };
    [bgView addSubview:self.segmentControl];
    
    XD_WeakSelf
    [self.segmentControl setIndexChangeBlock:^(NSInteger index) {
        XD_StrongSelf
        [self scrollviewDidScrollWithIndex:index];
        [self.scrollView setContentOffset:CGPointMake(index * SCREEN_WIDTH, 0)];
    }];
}

- (void)setupScrollView {
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, Normal_Height, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_Height - Normal_Height)];
    self.scrollView.showsVerticalScrollIndicator   = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled                  = YES;
    self.scrollView.scrollEnabled                  = YES;
    self.scrollView.alwaysBounceHorizontal         = YES;
    self.scrollView.delegate                       = self;
    self.scrollView.backgroundColor                = HEXCOLOR(0xf0eff5);
    self.scrollView.contentSize                    = CGSizeMake(SCREEN_WIDTH*2, 0);
    [self.view addSubview:self.scrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    
    self.segmentControl.selectedSegmentIndex = selectIndex;
    [self scrollviewDidScrollWithIndex:selectIndex];
    [self.scrollView setContentOffset:CGPointMake(selectIndex * SCREEN_WIDTH, 0)];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    int currentPage   = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self scrollviewDidScrollWithIndex:currentPage];
    [self.segmentControl setSelectedSegmentIndex:currentPage animated:YES];
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
            if (!self.listVC) {
                self.listVC = [[XDTopicListController alloc] init];
                self.listVC.view.frame = CGRectMake(SCREEN_WIDTH * 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_Height - Normal_Height);
                self.listVC.view.backgroundColor = HEXCOLOR(0xf0eff5);
                [self addChildViewController:self.listVC];
                [self.scrollView addSubview:self.listVC.view];
                
            }
        }
            break;
        case 1:
        {
            if (!self.allTopicVC) {
                self.allTopicVC = [[XDAllTopicsController alloc] init];
                self.allTopicVC.view.frame = CGRectMake(SCREEN_WIDTH * 1, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_Height - Normal_Height);
                self.allTopicVC.view.backgroundColor = HEXCOLOR(0xf0eff5);
                [self addChildViewController:self.allTopicVC];
                [self.scrollView addSubview:self.allTopicVC.view];
                
            }
        }
            break;
        default:
            break;
    }
}

@end
