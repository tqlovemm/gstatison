//
//  XDCardPackageController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/18.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDCardPackageController.h"
#import "XDSegmentView.h"
#import "HMSegmentedControl.h"
#import "XDDiscountCardController.h"

@interface XDCardPackageController ()<UIScrollViewDelegate>

@property (nonatomic, strong) XDSegmentView *segmentView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) XDDiscountCardController * hasUsedVC;

@property (nonatomic, strong) XDDiscountCardController * unUsedVC;
@end

@implementation XDCardPackageController

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView                                = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.segmentView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - _segmentView.frame.size.height -NavigationBar_Height)];
        _scrollView.showsVerticalScrollIndicator   = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled                  = YES;
        _scrollView.alwaysBounceHorizontal         = YES;
        _scrollView.delegate                       = self;
        _scrollView.backgroundColor                = HEXCOLOR(0xf0eff5);
        _scrollView.contentSize                    = CGSizeMake(SCREEN_WIDTH*2, 0);
    }
    return _scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"折扣券";
    
    [self.view addSubview:self.segmentView];
    
    [self.view addSubview:self.scrollView];
    WEAKSELF
    [self.segmentView.segmentControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf scrollviewDidScrollWithIndex:index];
    }];
    
    _hasUsedVC                      = [[XDDiscountCardController alloc] init];
    _hasUsedVC.title                = @"未使用";
    _hasUsedVC.view.frame           = CGRectMake(0, 0, SCREEN_WIDTH, self.scrollView.frame.size.height);
    _hasUsedVC.view.backgroundColor = HEXCOLOR(0xf0eff5);
    [self.scrollView addSubview:_hasUsedVC.view];
    [self addChildViewController:_hasUsedVC];

}

- (XDSegmentView *)segmentView {
    if (!_segmentView) {
        _segmentView            = [[XDSegmentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _segmentView.arrSegment = @[@"未使用",@"已使用"];
    }
    return _segmentView;
}

- (void)scrollviewDidScrollWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
            break;
        case 1:
        {
            if (!self.unUsedVC) {
                //未使用
                self.unUsedVC = [[XDDiscountCardController alloc]init];
                self.unUsedVC.view.frame = CGRectMake(SCREEN_WIDTH*index, 0, SCREEN_WIDTH, self.scrollView.frame.size.height - 44);
                self.unUsedVC.view.backgroundColor = HEXCOLOR(0xf0eff5);
                [self.scrollView addSubview:self.unUsedVC.view];
                [self addChildViewController:self.unUsedVC];
            }
        }
            break;
            
        default:
            break;
    }
    self.scrollView.contentOffset = CGPointMake(SCREEN_WIDTH*index, 0);
}

#pragma mark - scrollDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    int currentPage   = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self scrollviewDidScrollWithIndex:currentPage];
    [self.segmentView.segmentControl setSelectedSegmentIndex:currentPage animated:YES];
}

@end
