//
//  XDWomanSeekController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/11/8.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDWomanSeekController.h"
#import "XDWomanSeekCell.h"
#import "XDWomanSeekModel.h"
#import "XDWomanSeekDetailController.h"
#import "XDAreaModel.h"
#import "MJRefresh.h"

@interface XDWomanSeekController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;

//! 分页页码
@property (nonatomic, assign) NSInteger pageIndex;
//! 分页最大页码
@property (nonatomic, assign) NSInteger MaxPage;

@end

@implementation XDWomanSeekController

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = DefaultColor_BG_gray;
    
    [self setupCollectionView];
    
    [self xdd_setupRefreshControl];
}

/**
 *  集成刷新控件
 */
- (void)xdd_setupRefreshControl {
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.collectionView.mj_header = [XDRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf reloadNewData];
    }];
    
    // 马上进入刷新状态
    [self.collectionView.mj_header beginRefreshing];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadMoreData)];
}

#pragma mark - 获取数据
- (void)reloadNewData {
    if (![[AppUpdateInfo sharedInstance] isHavingNetworking]) {
        // 获取缓存数据
        //        [self getCacheDatas];
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.collectionView.mj_header endRefreshing];
        
//        if (self.threadsArray.count == 0) {
//            // 添加自定义错误(断网)提示
//            _errorView = [_errorView addErrorViewWithType:@"error_nonet"];
//        }
        
        return;
    }
    
    _pageIndex = 1;
    
    [self requestData];
}
- (void)reloadMoreData {
    if (_pageIndex < self.MaxPage) {
        _pageIndex = _pageIndex + 1;
        [self requestData];
    } else {
        // 已经全部加载完毕
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }
}
/**
 *  加载数据
 */
- (void)requestData {
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"page"] = @(self.pageIndex);
    paras[@"area"] = self.areaModel.areaID;
    [FKL_DataService requestURL:[NSString url_getWomanSeekList] parameters:paras withType:@"GET" format:@"JSON" complete:^(id result) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if ([result[@"code"] integerValue] == 200) {
            if (_pageIndex == 1) {
                self.dataArray = [NSMutableArray array];
            }
            self.MaxPage = [result[@"data"][@"_meta"][@"pageCount"] integerValue];
            NSArray *usersArray = [XDWomanSeekModel objectArrayWithKeyValuesArray:result[@"data"][@"items"]];
            [self.dataArray addObjectsFromArray:usersArray];
            [self.collectionView reloadData];
        } else {
            [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
    }];
}
/**
 *  获取新数据
 */
- (void)retryNewData {
    // 消除没有更多数据的状态
    [self.collectionView.mj_footer resetNoMoreData];
    [self.collectionView.mj_header beginRefreshing];
}

- (void)setupCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumLineSpacing = 12;
    layout.minimumInteritemSpacing = CGFLOAT_MIN;
//    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    layout.itemSize = CGSizeMake(136, 83);
    // 5.设置四周的内边距
    layout.sectionInset = UIEdgeInsetsMake(12, 12, 12, 12);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate             = self;
    self.collectionView.dataSource           = self;
    self.collectionView.contentSize          = CGSizeMake(SCREEN_WIDTH, self.view.frame.size.height);
    self.collectionView.backgroundColor      = DefaultColor_BG_gray;
    
    [self.collectionView registerClass:[XDWomanSeekCell class] forCellWithReuseIdentifier:@"XDWomanSeekCellID"];
    
    XD_WeakSelf
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.left.right.top.bottom.mas_equalTo(self.view);
    }];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
}

#pragma mark -- UICollectionViewDataSource
/** 总共多少组*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

/** 每组cell的个数*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

/** cell的内容*/
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XDWomanSeekCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XDWomanSeekCellID" forIndexPath:indexPath];
    
    cell.user = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark -- UICollectionViewDelegateFlowLayout
/** 每个cell的尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH - 36) / 2.0, (SCREEN_WIDTH - 36) / 2.0 + 92);
}

#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XDWomanSeekModel *user = self.dataArray[indexPath.row];
    XDWomanSeekDetailController *detailVC = [[XDWomanSeekDetailController alloc] init];
    detailVC.user = user;
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
