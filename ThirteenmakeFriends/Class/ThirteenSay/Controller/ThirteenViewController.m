//
//  ThirteenViewController.m
//  ThirteenmakeFriends
//
//  Created by iOS on 20/4/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "ThirteenViewController.h"
#import "ThirteenSegment.h"
#import "ThirteenWithADView.h"
#import "ThirteenWithVideoView.h"
#import "ThirteenHistoryViewController.h"
#import "ThirteenADModel.h"

@interface ThirteenViewController ()
<
 UIScrollViewDelegate
>
@property (nonatomic, strong) ThirteenSegment *segmentView;
@property (nonatomic, strong) ThirteenWithADView *tabThirteen;
@property (nonatomic, strong) ThirteenWithVideoView *videoThirteen;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray      *arrSegment; // 选项卡个数

@end

@implementation ThirteenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.edgesForExtendedLayout = UIRectEdgeNone;  //布局从64位开始，控件y值就不用设置为64了.
    [self loadDefaultData];
    UIButton *btn       = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setImage:ImageViewName(@"ThirteenSay_unLike") forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(didPressedToHistory) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -12;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, item];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)didPressedToHistory {
    ThirteenHistoryViewController *vc = [[ThirteenHistoryViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)loadDefaultData {
    self.navigationItem.title = NSLocalizedString(@"title.thirteensay", @"13 said");
    [self fetchNetWork];
}
- (void)createBaseView {
    [self.segmentView class];
    [self.scrollView  class];
    
    for (int i = 0 ; i < self.arrSegment.count; i++) {
        [self createContentTableView:[[self.arrSegment[i]objectForKey:@"tid"] integerValue]
                           withIndex:i+1];
    }
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView                                = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.segmentView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT-self.segmentView.frame.size.height-NavigationBar_Height)];
        _scrollView.showsVerticalScrollIndicator   = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled                  = YES;
        _scrollView.alwaysBounceHorizontal         = YES;
        _scrollView.delegate                       = self;
        _scrollView.backgroundColor                = HEXCOLOR(0xf0eff5);
        NSLog(@"%lu",(unsigned long)self.arrSegment.count);
        _scrollView.contentSize                    = CGSizeMake(SCREEN_WIDTH*(self.arrSegment.count + 1), 0);
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (ThirteenSegment *)segmentView {
    if (!_segmentView) {
        NSMutableArray *mutArr = [[NSMutableArray alloc]initWithCapacity:0];
        for (int i = 0; i < _arrSegment.count; i++) {
            [mutArr addObject:[_arrSegment[i] objectForKey:@"typename"]];
        }
        [mutArr insertObject:@"推荐" atIndex:0];

        _segmentView            = [[ThirteenSegment alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _segmentView.arrSegment = mutArr;
        [self.view addSubview:_segmentView];
        WEAKSELF
        [_segmentView.segmentControl setIndexChangeBlock:^(NSInteger index) {
            [weakSelf.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*index, 0) animated:YES];
            [weakSelf scrollviewDidScrollWithIndex:index];
        }];
    }
    return _segmentView;
}

- (ThirteenWithADView *)tabThirteen {
    if (!_tabThirteen) {
        _tabThirteen = [[ThirteenWithADView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.scrollView.frame.size.height) style:UITableViewStyleGrouped];
        [self.scrollView addSubview:_tabThirteen];
    }
    return _tabThirteen;
}

- (ThirteenWithVideoView *)videoThirteen {
    if (!_videoThirteen) {
        _videoThirteen = [[ThirteenWithVideoView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scrollView.frame.size.height)];
        _videoThirteen.tid = [[self.arrSegment[0]objectForKey:@"tid"] integerValue];
        [self.scrollView addSubview:_videoThirteen];
    }
    return _videoThirteen;
}

#pragma mark - scrollDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    int currentPage   = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self scrollviewDidScrollWithIndex:currentPage];
    [self.segmentView.segmentControl setSelectedSegmentIndex:currentPage animated:YES];
}

#pragma mark - network
/**
 获取选项卡
 */
- (void)fetchNetWork {
    [FKL_DataService requestURL:[NSString url_get13SayTab] parameters:nil withType:@"GET" format:@"JSON" complete:^(id result) {
        if ([result[@"code"] integerValue] == 200) {
            _arrSegment = result[@"data"];
            _arrSegment = [_arrSegment sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                if ([[obj1 objectForKey:@"tid"] integerValue] < [[obj2 objectForKey:@"tid"] integerValue]) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                if ([[obj1 objectForKey:@"tid"] integerValue] > [[obj2 objectForKey:@"tid"] integerValue]) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
            [self createBaseView];
            [self.tabThirteen class];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [myAppDelegate.window makeToast:error.localizedDescription duration:1 position:CSToastPositionCenter];
    }];
}

#pragma mark - p_method
/**
 移动scrollview
 懒加载tableview
 @param index 页数
 */
- (void)scrollviewDidScrollWithIndex:(NSInteger)index {
    switch (index) {
        case 1:
        {
            [self.videoThirteen class];
        } break;
        case 2:
        {
        } break;
        default:
            break;
    }
}

- (void)createContentTableView:(NSInteger)tidNum withIndex:(NSInteger)index{
    ThirteenWithVideoView *videoThirteen = [[ThirteenWithVideoView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * index, 0, SCREEN_WIDTH, self.scrollView.frame.size.height)];
    videoThirteen.tid = tidNum;
    [self.scrollView addSubview:videoThirteen];

    videoThirteen.tag = index;
}

@end
