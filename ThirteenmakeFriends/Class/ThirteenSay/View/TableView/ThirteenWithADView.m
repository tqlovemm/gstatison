//
//  ThirteenWithADView.m
//  ThirteenmakeFriends
//
//  Created by iOS on 15/5/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "ThirteenWithADView.h"
#import "SDCycleScrollView.h"
#import "XDErrorView.h"
#import "MJRefresh.h"
#import "ThirteenSayArticlesModel.h"
#import "ThirteenWithVideoCellTableViewCell.h"
#import "ICESharedView.h"
#import <WebKit/WebKit.h>
#import "ShareManager.h"
#import "ICEWebViewController.h"
#import "ThirteenADModel.h"
//#import "XDOtherViewController.h"

@interface ThirteenWithADView ()
<
 UITableViewDelegate,
 UITableViewDataSource,
 SDCycleScrollViewDelegate,
 XDErrorViewDelegate,
 ICEAvatarDelegate,
 ICESharedViewDelegate,
 ICEWebDelegate
>
{
    XDErrorView *_errorView;
}

//! 分页页码
@property (nonatomic, assign) NSInteger      pageIndex;
//! 分页最大页码
@property (nonatomic, assign) NSInteger      MaxPage;

@property (nonatomic, strong) NSMutableArray *seekFrameArray;

@property (nonatomic, strong) SDCycleScrollView *cycleScroll;
@end

@implementation ThirteenWithADView

- (void)setArrAdModel:(NSArray *)arrAdModel {
    NSMutableArray *arr  = [[NSMutableArray alloc]initWithCapacity:0];
    for (ThirteenADModel *model in arrAdModel) {
        [arr addObject:model.thumb];
    }
    
    _cycleScroll.localizationImageNamesGroup = arr;
    _arrAdModel = arrAdModel;
}

- (SDCycleScrollView *)cycleScroll {
    if (!_cycleScroll) {
        _cycleScroll = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2.0) delegate:self placeholderImage:ImageViewName(@"ThirteenSay_ ADPlaceHolder")];
    }
    return _cycleScroll;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadDefaultData];
        [self creatBaseView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate        = self;
        self.dataSource      = self;
        self.backgroundColor = HEXCOLOR(0xf0eff5);
        self.separatorStyle  = UITableViewCellSeparatorStyleNone;
        [self loadDefaultData];
        [self creatBaseView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate        = self;
        self.dataSource      = self;
        self.backgroundColor = HEXCOLOR(0xf0eff5);
        self.separatorStyle  = UITableViewCellSeparatorStyleNone;
        [self loadDefaultData];
        [self creatBaseView];
    }
    return self;
}

- (void)loadDefaultData {
    self.seekFrameArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.pageIndex      = 1;
}

- (void)creatBaseView {
    [self setupErrorView];
    [self p_createRefreshHeaderAndFooter];
}

/**
 初始化错误界面
 */
-(void)setupErrorView {
    _errorView = [XDErrorView errorViewWithSuperView:self Frame:self.bounds];
    _errorView.delegate = self;
}

/**
 上啦下啦刷新
 */
- (void)p_createRefreshHeaderAndFooter {
    WEAKSELF
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.mj_header = [XDRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf reloadNewData];
    }];
    
    // 马上进入刷新状态
    [self.mj_header beginRefreshing];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self
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
        [self.mj_header endRefreshing];
        
        if (self.seekFrameArray.count == 0) {
            // 添加自定义错误(断网)提示
            _errorView = [_errorView addErrorViewWithType:@"error_nonet"];
        }
        return;
    }
    _pageIndex = 1;
    [self requestData];
}

/**
 *  加载更多数据
 */
- (void)reloadMoreData {
    if (_pageIndex < self.MaxPage) {
        _pageIndex ++;
        [self requestData];
    } else {
        // 已经全部加载完毕
        [self.mj_footer endRefreshingWithNoMoreData];
    }
}


/**
 请求数据
 */
- (void)requestData {
    // 判断网络状况
    if (!isNetworking) {
        // 添加自定义错误(断网)提示
        _errorView = [_errorView addErrorViewWithType:error_nonet_flag];
        return;
    }
    
    WEAKSELF
    NSMutableDictionary *paras = [[NSMutableDictionary alloc]initWithCapacity:0];
    paras[@"page"] = @(_pageIndex);
    paras[@"hot"]  = @(1);
    paras[@"uid"]  = @([User_ID integerValue]);
    
    [FKL_DataService requestURL:[NSString url_get13SayList]
                     parameters:paras
                       withType:@"GET"
                         format:@"JSON"
                       complete:^(id result) {
                           [weakSelf.mj_header endRefreshing];
                           [weakSelf.mj_footer endRefreshing];
                           if (result != nil) {
                               if (_pageIndex == 1) {
                                   self.seekFrameArray = [NSMutableArray array];
                                   [self fetchNetWorkAD];
                               }
                               self.MaxPage        = [result[@"_meta"][@"pageCount"] integerValue];
                               NSArray *articleArr = [ThirteenSayArticlesModel objectArrayWithKeyValuesArray:result[@"data"]];
                               
                               if (self.seekFrameArray.count == 0 && articleArr.count == 0) {
                                   _errorView = [_errorView addErrorViewWithType:error_nodata_flag];
                                   return ;
                               }
                               for (ThirteenSayArticlesModel *seek in articleArr) {
                                   [self.seekFrameArray addObject:seek];
                               }
                               _errorView = [_errorView removeErrorView];
                               [self reloadData];
                           }
                           else {
                               [self makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
                               // 无数据
                               _errorView = [_errorView addErrorViewWithType:error_nodata_flag];
                           }
                           
                       } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
                           if (self.seekFrameArray.count == 0)
                               _errorView = [_errorView addErrorViewWithType:error_nodata_flag];
                           [weakSelf makeToast:error.localizedDescription];
                           [weakSelf.mj_header endRefreshing];
                           [weakSelf.mj_footer endRefreshing];
                       }];
}


/**
 获取广告页接口
 */
- (void)fetchNetWorkAD {
    [FKL_DataService requestURL:[NSString url_get13SayAD] parameters:nil withType:@"GET" format:@"JSON" complete:^(id result) {
        if ([result[@"code"] integerValue] == 200) {
            NSArray *records = [ThirteenADModel objectArrayWithKeyValuesArray:result[@"data"]];
            self.arrAdModel = records;
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [myAppDelegate.window makeToast:error.localizedDescription duration:1 position:CSToastPositionCenter];
    }];
}

#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ICEWebViewController *vc = [[ICEWebViewController alloc]init];
    ThirteenSayArticlesModel *model = self.seekFrameArray[indexPath.row];
    vc.fromURL               = model.url;
    vc.des = model.title;
    vc.cellIndexPath         = indexPath;
    vc.delegate              = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.cycleScroll;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return SCREEN_WIDTH/2.0;
    }
    return HeightHeadViewZero;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return HeightHeadViewZero;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 灰色view12 + 顶部50 + 底部36 中间图片 宽*(3/5) + 标题内容。+ 标题内容间隔12
    return 12 + 50 + 36 + SCREEN_WIDTH/5.0 * 3 + 12 +[(ThirteenSayArticlesModel *)self.seekFrameArray[indexPath.row] cellHeight];
}

//每个section一个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.seekFrameArray.count;
}

//section count
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ThirteenWithVideoCellTableViewCell";
    ThirteenWithVideoCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell               = [[[NSBundle mainBundle] loadNibNamed:identifier
                                                            owner:nil
                                                          options:nil] firstObject];
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }

    cell.model           = self.seekFrameArray[indexPath.row];
    cell.didPressedEvent = ^(CellClickEvent event,ThirteenWithVideoCellTableViewCell *cell) {
        WEAKSELF
        switch (event) {
//        Praise,
//        Collection,
//        Share,
            case 0:
            {
                cell.btnPraise.userInteractionEnabled = NO;
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
                [dic setObject:F(@"%@", [self.seekFrameArray[indexPath.row] article_id]) forKey:@"aid"];
                [dic setObject:User_ID forKey:@"userid"];
                
                [FKL_DataService requestURL:[NSString url_post13SayLiked] parameters:dic withType:@"POST" format:@"JSON" complete:^(id result) {
                    if ([result[@"code"] integerValue]==200) {
                        [cell didPressedToStartPriseAnimationIncreasePraiseNum:YES];
                        ThirteenSayArticlesModel *model = weakSelf.seekFrameArray[indexPath.row];
                        model.islike = @"1";
                        model.wdianzan = F(@"%ld", [model.wdianzan integerValue] + 1);
                        [weakSelf.seekFrameArray replaceObjectAtIndex:indexPath.row withObject:model];
                    }
                    else if ([result[@"code"] integerValue]==202) {
                        ThirteenSayArticlesModel *model = weakSelf.seekFrameArray[indexPath.row];
                        if ([F(@"%@", model.islike) isEqualToString:@"1"]) {
                            model.islike = @"1";
                            [weakSelf.seekFrameArray replaceObjectAtIndex:indexPath.row withObject:model];
                            [cell didPressedToStartPriseAnimationIncreasePraiseNum:NO];
                        }
                        else {
                            model.islike = @"1";
                            model.wdianzan = F(@"%ld", [model.wdianzan integerValue] + 1);
                            [weakSelf.seekFrameArray replaceObjectAtIndex:indexPath.row withObject:model];
                            [cell didPressedToStartPriseAnimationIncreasePraiseNum:YES];
                        }
                    }
                    [myAppDelegate.window makeToast:result[@"data"] duration:1 position:CSToastPositionCenter title:nil image:nil style:nil completion:^(BOOL didTap) {
                        cell.btnPraise.userInteractionEnabled = YES;
                    }];
                } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
                    [myAppDelegate.window makeToast:error.localizedDescription duration:1 position:CSToastPositionCenter title:nil image:nil style:nil completion:^(BOOL didTap) {
                        cell.btnPraise.userInteractionEnabled = YES;
                    }];
                }];
            }
                break;
            case 1:
            {
                cell.btnShare.userInteractionEnabled = NO;
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
                [dic setObject:F(@"%@", [self.seekFrameArray[indexPath.row] article_id]) forKey:@"aid"];
                [dic setObject:User_ID forKey:@"userid"];
                
                [FKL_DataService requestURL:[NSString url_post13SayCollection] parameters:dic withType:@"POST" format:@"JSON" complete:^(id result) {
                    if ([result[@"code"] integerValue]==200) {
                        [cell didPressedToStartCollectionAnimation];
                        ThirteenSayArticlesModel *model = weakSelf.seekFrameArray[indexPath.row];
                        model.iscollection = @"1";
                        [weakSelf.seekFrameArray replaceObjectAtIndex:indexPath.row withObject:model];
                    }
                    else if ([result[@"code"] integerValue]==202) {
                        [cell didPressedToStartCollectionAnimation];
                        ThirteenSayArticlesModel *model = weakSelf.seekFrameArray[indexPath.row];
                        model.iscollection = @"1";
                        [weakSelf.seekFrameArray replaceObjectAtIndex:indexPath.row withObject:model];
                    }
                    
                    [myAppDelegate.window makeToast:result[@"data"] duration:1 position:CSToastPositionCenter title:nil image:nil style:nil completion:^(BOOL didTap) {
                        cell.btnShare.userInteractionEnabled = YES;
                    }];
                } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
                    [myAppDelegate.window makeToast:error.localizedDescription duration:1 position:CSToastPositionCenter title:nil image:nil style:nil completion:^(BOOL didTap) {
                        cell.btnShare.userInteractionEnabled = YES;
                    }];
                }];
            }
                break;
            case 2:{
                ThirteenSayArticlesModel *model = weakSelf.seekFrameArray[indexPath.row];
                //显示分享面板
                ICESharedView *view = [[ICESharedView alloc]initWithDelegate:self];
                view.sharedURL      = [NSString stringWithFormat:@"%@&isappshared=1",model.url];
                view.sharedTitle    = model.title;
                view.sharedContent  = model.miaoshu;
                view.imagePath      = model.wimg;
                [view show];
            }
                break;
            default:
                break;
        }
    };
    cell.avatarView.delegate = self;
    return cell;
}

#pragma mark - SDCycleScrollView-Delegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if ([[(ThirteenADModel *)self.arrAdModel[index] url] isEqualToString:@"/"]) {
        return;
    }
    else {
        ICEWebViewController *web = [[ICEWebViewController alloc]init];
        web.fromURL               = [(ThirteenADModel *)self.arrAdModel[index] url];
        [self.navigationController pushViewController:web animated:YES];
    }
}

#pragma mark - XDErrorViewDelegate
- (void)errorViewAddErrorView:(XDErrorView *)errorView {
    self.scrollEnabled = NO;
}

- (void)errorViewRemoveErrorView:(XDErrorView *)errorView {
    self.scrollEnabled = YES;
}

- (void)errorViewTapedErrorView:(XDErrorView *)errorView{
    // 请求数据
    [self reloadNewData];
}

#pragma mark -icedelegate
-(void)clickAvatar:(ICEAvatar *)avatar {
    CGRect rc              = [avatar.superview convertRect:avatar.frame toView:self];
    NSIndexPath *indexPath = [self indexPathForRowAtPoint:CGPointMake(rc.origin.x+rc.size.width/2, rc.origin.y+rc.size.height/2)];
    
    ThirteenSayArticlesModel *model = self.seekFrameArray[indexPath.row];
//    XDOtherViewController *otherVC = [[XDOtherViewController alloc] init];
//    otherVC.user_id = [NSString stringWithFormat:@"%ld",model.created_id];
//    [self.navigationController pushViewController:otherVC animated:YES];
}

#pragma mark - ICEWebDelegate
- (void)updateDataSource:(NSIndexPath *)indexPath withUpdataType:(UpdataDataSourceType)type {
    ThirteenSayArticlesModel *model = self.seekFrameArray[indexPath.row];
    switch (type) {
        case 0: {
            model.islike   = @"1";
            model.wdianzan = F(@"%ld", [model.wdianzan integerValue] + 1);
            [self.seekFrameArray replaceObjectAtIndex:indexPath.row withObject:model];
        } break;
         case 1: {
            model.iscollection = @"1";
            [self.seekFrameArray replaceObjectAtIndex:indexPath.row withObject:model];

        } break;
        case 2: {
            model.comment_count = F(@"%ld", [model.comment_count integerValue] + 1);
            [self.seekFrameArray replaceObjectAtIndex:indexPath.row withObject:model];
            
        } break;
        case WebHome: {
//            XDOtherViewController *otherVC = [[XDOtherViewController alloc] init];
//            otherVC.user_id = [NSString stringWithFormat:@"%ld",model.created_id];
//            [self.navigationController pushViewController:otherVC animated:YES];
            
        } break;
        default:
            break;
    }
    [self reloadData];
}

@end
