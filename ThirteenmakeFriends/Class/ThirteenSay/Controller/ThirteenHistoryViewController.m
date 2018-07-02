//
//  ThirteenHistoryViewController.m
//  ThirteenmakeFriends
//
//  Created by iOS on 23/5/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "ThirteenHistoryViewController.h"
#import "CollectionHistoryTableViewCell.h"
#import "CollectionHistoryModel.h"
#import "MJRefresh.h"
#import "XDPhotoBrowser.h"
#import "ICEWebViewController.h"

@interface ThirteenHistoryViewController ()
<
 UITableViewDelegate,
 UITableViewDataSource,
 XDErrorViewDelegate,
 ICEAvatarDelegate
>
{
    XDErrorView *_errorView;
}

@property (nonatomic, strong) UITableView    *baseTableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

//! 分页页码
@property (nonatomic, assign) NSInteger      pageIndex;

//! 分页最大页码
@property (nonatomic, assign) NSInteger      MaxPage;

@property (nonatomic, strong) UIButton       *btnRight;
@end

@implementation ThirteenHistoryViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    
    if (_dataArray.count > 0) {
        _btnRight.hidden = NO;
    }
    else {
        _btnRight.hidden = YES;
    }
    return _dataArray;
}

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadDefaultData];
    [self createBaseView];
}

- (void)loadDefaultData {
    self.title      = @"收藏";
    self.pageIndex  = 1;
}

- (void)createBaseView {
    _btnRight = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [_btnRight setTitle:@"清空" forState:UIControlStateNormal];
    [_btnRight.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_btnRight setTitleColor:RGB(31, 31, 31) forState:UIControlStateNormal];
    [_btnRight addTarget:self action:@selector(didPressedToDelete:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item                  = [[UIBarButtonItem alloc]initWithCustomView:_btnRight];
    self.navigationItem.rightBarButtonItem = item;
    
    [self createTableView];
    [self setupErrorView];
    [self p_createRefreshHeaderAndFooter];
}

- (void)createTableView {
    self.baseTableView = [[UITableView alloc]init];
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    [self.baseTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.baseTableView];
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark - p_method
- (void)didPressedToDelete:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"是否删除全部记录?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancle    = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *suer      = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self fetchCollectDelete:@"1" andCid:nil withBlock:^(bool result) {
            if (result) {
                [self.baseTableView.mj_header beginRefreshing];
            }
        }];
    }];
    [alert addAction:cancle];
    [alert addAction:suer];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - ErrorView Delegate
-(void)setupErrorView{
    _errorView          = [XDErrorView errorViewWithSuperView:self.view Frame:self.view.bounds];
    _errorView.delegate = self;
}

#pragma mark - network

/**
 上啦下啦刷新
 */
- (void)p_createRefreshHeaderAndFooter {
    WEAKSELF
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.baseTableView.mj_header = [XDRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf reloadNewData];
    }];
    
    // 马上进入刷新状态
    [self.baseTableView.mj_header beginRefreshing];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    self.baseTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self
                                                          refreshingAction:@selector(reloadMoreData)];
}

/**
 *  加载新数据
 */
- (void)reloadNewData {
    // 判断网络状况
    if (!isNetworking) {
        // 获取缓存数据
//        [self getCacheDatas];
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.baseTableView.mj_header endRefreshing];
        if (self.dataArray.count == 0) {
            // 添加自定义错误(断网)提示
            _errorView = [_errorView addErrorViewWithType:@"error_nonet"];
        }
        return;
    }
    _pageIndex = 1;
    [self fetchNetWork];
}

/**
 *  加载更多数据
 */
- (void)reloadMoreData {
    if (_pageIndex < self.MaxPage) {
        _pageIndex = _pageIndex + 1;
        [self fetchNetWork];
    }
    else {
        // 已经全部加载完毕
        [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
    }
}


- (void)fetchNetWork {
    WEAKSELF
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"page"]             = @(_pageIndex);

    [FKL_DataService requestURL:[NSString url_get13SayCollectionList_withUserId:User_ID] parameters:nil withType:@"GET" format:@"JSON" complete:^(id result) {
        [self.baseTableView.mj_header endRefreshing];
        [self.baseTableView.mj_footer endRefreshing];
        
        if (_pageIndex == 1) {
            self.dataArray    = [NSMutableArray array];
        }
        
        self.MaxPage     = [result[@"_meta"][@"pageCount"] integerValue];
        NSArray *seekArr = [CollectionHistoryModel objectArrayWithKeyValuesArray:result[@"data"]];
        
        if (self.dataArray.count == 0 && seekArr.count == 0) {
            // 无数据
            _errorView = [_errorView addErrorViewWithType:error_nodata_flag];
            return ;
        }

        [self.dataArray addObjectsFromArray:seekArr];
        
        // 有网，移除视图
        _errorView = [_errorView removeErrorView];
        [self.baseTableView reloadData];
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self.baseTableView.mj_header endRefreshing];
        [self.baseTableView.mj_footer endRefreshing];
        [weakSelf.view makeToast:error.localizedDescription duration:1 position:CSToastPositionCenter];
    }];
}


#pragma mark - tableviewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ICEWebViewController *vc = [[ICEWebViewController alloc]init];
    CollectionHistoryModel *model = self.dataArray[indexPath.row];
    vc.fromURL = model.url;
    vc.des = model.title;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    WEAKSELF;
    static NSString *identifit           = @"CollectionHistoryTableViewCell";
    CollectionHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifit];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CollectionHistoryTableViewCell" owner:self options:nil] lastObject];
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    cell.backgroundColor     = [UIColor whiteColor];
    cell.model               = self.dataArray[indexPath.row];
    cell.avatarView.delegate = self;
    cell.clickBlock = ^(CollectionHistoryTableViewCell *cell) {
//        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
//        [dic setObject:F(@"%@", [self.dataArray[indexPath.row] article_id]) forKey:@"aid"];
//        [dic setObject:User_ID forKey:@"userid"];
//        
//        [FKL_DataService requestURL:F(@"%@%@", DomainUrl2,ThirteenLike) parameters:dic withType:@"POST" format:@"JSON" complete:^(id result) {
//            if ([result[@"code"] integerValue] == 200) {
//                [cell didPressedToStartPriseAnimation];
//                CollectionHistoryModel *model = weakSelf.dataArray[indexPath.row];
//                model.islike                  = @"1";
//                model.like_count              = F(@"%ld", [model.like_count integerValue] + 1);
//                [weakSelf.dataArray replaceObjectAtIndex:indexPath.row withObject:model];
//            }
//            [myAppDelegate.window makeToast:result[@"data"] duration:1 position:CSToastPositionCenter];
//        } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
//            [myAppDelegate.window makeToast:error.localizedDescription duration:1 position:CSToastPositionCenter];
//        }];
    };
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}


/**
 *  只要实现了这个方法，左滑出现Delete按钮的功能就有了
 *  点击了“左滑出现的Delete按钮”会调用这个方法
 */
//IOS9前自定义左滑多个按钮需实现此方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    NoticeForBoyModel *model = self.arrMessage[indexPath.row];
//    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
//    [paras setObject:F(@"%d", [model.apply_id intValue]) forKey:@"did"];
//    [self fetchToDeleteMessage:paras withBlock:^(bool result) {
//        if (result) {
//            //     删除模型
//            [self.arrMessage removeObjectAtIndex:indexPath.row];
//            // 刷新
//            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
//            \[self.myTableView reloadData];
//        }
//    }];
    [self fetchCollectDelete:nil
                      andCid:F(@"%@", [(CollectionHistoryModel *)self.dataArray[indexPath.row] collectID])
                   withBlock:^(bool result) {
                       if (result) {
                           NSLog(@"yes");
                           [self.dataArray removeObjectAtIndex:indexPath.row];
                           [self.baseTableView reloadData];
                       }
                       else {
                           NSLog(@"no");
                           [self.baseTableView reloadData];
                       }
    }];
}

- (void)fetchCollectDelete:(NSString *)delall andCid:(NSString *)cid withBlock:(void(^)(bool result))_Result{
    //delall	1  （删除全部）
    //cid	帖子id  （删除单条）
    NSString *url ;
    if (delall) {
        url = [NSString url_delete13SayAllCollection_withUserId:User_ID];
    }
    if (cid) {
        url = [NSString url_delete13SayOneCollection_withUserId:User_ID andCollect_id:cid];
    }
    
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    [FKL_DataService requestURL:url parameters:nil headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"DELETE" format:@"JSON" complete:^(id result) {
        [self.view makeToast:result[@"data"] duration:1 position:CSToastPositionCenter];

        if ([result[@"code"] integerValue] == 200) {
            _Result(YES);
        }
        else {
            _Result(NO);
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeToast:error.localizedDescription duration:1 position:CSToastPositionCenter];
        _Result(NO);
    }];
}

/**
 *  修改Delete按钮文字为“删除”
 */
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

/**
 *  XDErrorViewDelegate
 */
- (void)errorViewAddErrorView:(XDErrorView *)errorView {
    self.baseTableView.scrollEnabled = NO;
}

- (void)errorViewRemoveErrorView:(XDErrorView *)errorView {
    self.baseTableView.scrollEnabled = YES;
}

- (void)errorViewTapedErrorView:(XDErrorView *)errorView{
    // 请求数据
    [self fetchNetWork];
}

#pragma mark - iceavatar delegate
-(void)clickAvatar:(ICEAvatar *)avatar {
    CGRect rc              = [avatar.superview convertRect:avatar.frame toView:self.baseTableView];
    NSIndexPath *indexPath = [self.baseTableView indexPathForRowAtPoint:CGPointMake(rc.origin.x+rc.size.width/2, rc.origin.y+rc.size.height/2)];
    NSLog(@"%ld",(long)indexPath.row);
    
    CollectionHistoryModel *model = self.dataArray[indexPath.row];
    
    XDPhotoBrowser *photoBrowser = [XDPhotoBrowser defaultManager];
//    [photoBrowser showBrowserWithImages:@[model.wimg] andCurrentIndex:indexPath.row fromImageContainer:nil];
    [photoBrowser showBrowserWithImages:@[model.wimg] andCurrentIndex:0 fromImageContainer:avatar];

}
@end
