//
//  XDRankNavViewController.m
//  ThirteenmakeFriends
//
//  Created by 空谷凌虚 on 2018/5/22.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDRankNavViewController.h"
#import "HMSegmentedControl.h"
#import "XDRankListViewController.h"


@interface XDRankNavViewController ()<UIScrollViewDelegate>


@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HMSegmentedControl *segmentControl;

@property (strong, nonatomic) XDRankListViewController *rankListView0;
@property (strong, nonatomic) XDRankListViewController *rankListView1;

@end

@implementation XDRankNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
    UIColor *normalColor = RGB(119, 119, 119);
    UIColor *select1Color =  RGB(97, 60, 187);
    UIColor *select2Color =RGB(232, 63, 120);
    
    
    self.segmentControl                 = [[HMSegmentedControl alloc]initWithSectionTitles:@[@"任性榜",@"魅力榜"]];
    self.segmentControl.backgroundColor = [UIColor clearColor];
    self.segmentControl.frame                        = CGRectMake(0, 0, 120, Normal_Height);
    self.segmentControl.segmentEdgeInset             = UIEdgeInsetsMake(0, 0, 0, 0);
    self.segmentControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.segmentControl.selectedSegmentIndex         = 0;
    self.segmentControl.selectionStyle               = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.segmentControl.selectionIndicatorLocation   = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentControl.selectionIndicatorColor      = select1Color;
    self.segmentControl.selectionIndicatorHeight     = 2;
    self.segmentControl.titleTextAttributes          = @{
                                                         NSFontAttributeName : kPingFangBoldFont(12),
                                                         NSForegroundColorAttributeName :normalColor
                                                         };
    self.segmentControl.selectedTitleTextAttributes  = @{
                                                         NSFontAttributeName : kPingFangBoldFont(14),
                                                         NSForegroundColorAttributeName : select1Color
                                                         };
    

    
    
    XD_WeakSelf
    [self.segmentControl setIndexChangeBlock:^(NSInteger index) {
        XD_StrongSelf
        [self scrollviewDidScrollWithIndex:index];
        [self.scrollView setContentOffset:CGPointMake(index * SCREEN_WIDTH, 0)];
        
        if (index == 0) {
            self.segmentControl.selectionIndicatorColor      = select1Color;
            self.segmentControl.selectedTitleTextAttributes  = @{
                                                                 NSFontAttributeName : kPingFangBoldFont(14),
                                                                 NSForegroundColorAttributeName :select1Color
                                                                 };
        }else{
            self.segmentControl.selectionIndicatorColor      = select2Color;
            self.segmentControl.selectedTitleTextAttributes  = @{
                                                                 NSFontAttributeName : kPingFangBoldFont(14),
                                                                 NSForegroundColorAttributeName :select2Color
                                                                 };
        }
    }];
    self.navigationItem.titleView = self.segmentControl;
    
    [self.scrollView class];
    
    XDRankListViewController *rankView = [[XDRankListViewController alloc] init];
    rankView.rankType = 0;
    rankView.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_Height );
    rankView.view.backgroundColor = HEXCOLOR(0xf0eff5);
    self.rankListView0 = rankView;
   
    [self.scrollView addSubview:rankView.view];
    [self addChildViewController:rankView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)scrollviewDidScrollWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            if (!self.rankListView1) {
                //救我
                XDRankListViewController *rankView = [[XDRankListViewController alloc] init];
                rankView.rankType = 2;
                rankView.view.frame = CGRectMake(SCREEN_WIDTH * 1, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_Height);
                rankView.view.backgroundColor = HEXCOLOR(0xf0eff5);
               
                [self addChildViewController:rankView];
                [self.scrollView addSubview:rankView.view];
                self.rankListView1 = rankView;
            }
        }
            break;
        default:
            break;
    }
}


- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView                                = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_Height )];
        _scrollView.showsVerticalScrollIndicator   = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled                  = YES;
        _scrollView.scrollEnabled                  = YES;
        _scrollView.alwaysBounceHorizontal         = YES;
        _scrollView.delegate                       = self;
        _scrollView.backgroundColor                = HEXCOLOR(0xf0eff5);
        _scrollView.contentSize                    = CGSizeMake(SCREEN_WIDTH * 2, 0);
        [self.view addSubview:_scrollView];
        
    }
    return _scrollView;
}

#pragma mark - scrollDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    int currentPage   = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self scrollviewDidScrollWithIndex:currentPage];
    [self.segmentControl setSelectedSegmentIndex:currentPage animated:YES];
}
@end
