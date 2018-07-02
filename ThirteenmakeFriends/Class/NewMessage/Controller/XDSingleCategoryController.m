//
//  XDSingleCategoryController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2018/1/26.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDSingleCategoryController.h"
#import "MJRefresh.h"
#import "XDMsgCategoryModel.h"
#import "NSString+HXAddtions.h"
#import "XDLocalHtmlViewController.h"
//#import "XDOtherViewController.h"

#import "XDSingleImageMsgCell.h"
#import "XDCoinComsumeCell.h"
#import "XDCashTopUpCell.h"
#import "XDSingleGraphicCell.h"
#import "XDMultiGraphicCell.h"
#import "XDBusinessCardCell.h"
#import "XDTemplateMessageCell.h"
#import "XDEmptyView.h"
#import "XDBaseUMShareController.h"
#import "XDSingleCategoryController.h"
#import "XDUMSharedView.h"
#import "ICESharedView.h"
@interface XDSingleCategoryController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,XDUMSharedViewDelegate,ICESharedViewDelegate>

@property (nonatomic ,weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

/** 分页页码 */
@property (nonatomic, assign) NSInteger pageIndex;
/** 分页最大页码 */
@property (nonatomic, assign) NSInteger maxPage;

@property (nonatomic,copy)NSString *titleStr;

@end

@implementation XDSingleCategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.categoryModel.entry_name;
    
    // 创建tableView
    [self xdd_setupTableView];
    
    // 集成刷新控件
    [self xdd_setupRefreshControl];
}

/**
 *  创建tableView
 */
- (void)xdd_setupTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT - NavigationBar_Height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = RGB(226, 226, 226);
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    //设置emptyView
    self.tableView.ly_emptyView = [XDEmptyView diyEmptyView];
}

/**
 *  集成刷新控件
 */
- (void)xdd_setupRefreshControl {
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [XDRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf reloadNewData];
    }];
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadMoreData)];
}

- (void)reloadNewData {
    
    _pageIndex = 1;
    [self requestData];
}

- (void)reloadMoreData {
    if (_pageIndex < self.maxPage) {
        _pageIndex = _pageIndex + 1;

        [self requestData];
    } else {
        // 已经全部加载完毕
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark - 获取消息数据

/**
 *  获得消息数据
 */
- (void)requestData {
    
    [self showHudInView:self.view hint:@"加载中..."];
    [FKL_DataService encryption_requestURL:[NSString url_getSinggleCategoryMessage_withItemID:self.categoryModel.entry_id] parameters:nil withType:@"GET" complete:^(id result) {
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.mj_header endRefreshing];
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.tableView.mj_footer endRefreshing];
        [self hideHud];
        if ([result[@"code"] integerValue] == 200) {
            // 更新未读消息数量
            [[NSNotificationCenter defaultCenter] postNotificationName:@"unreadOtherMessageCount" object:nil];
            
            self.maxPage = [result[@"data"][@"_meta"][@"pageCount"] integerValue];
            if (self.pageIndex == 1) {
                self.dataArray = [NSMutableArray array];
            }
            NSArray *dataArr = [XDNewMessageModel objectArrayWithKeyValuesArray:result[@"data"][@"items"]];
            for (XDNewMessageModel *md in dataArr) {
                NSLog(@"%ld",md.template_id);
                if (md.template_id == 15 || md.template_id == 16) { // 心动币消费,现金消费
                    NSDictionary *dic = [md.extra JsonToArrayOrNSDictionary];
                    md.comsumeModel = [XDNewMessageComsumeModel objectWithKeyValues:dic];
                } else if (md.template_id == 10) { // 10模板消息模板
                    NSDictionary *dic = [md.extra JsonToArrayOrNSDictionary];
                    md.remindModel = [XDNewMessageRemindModel objectWithKeyValues:dic];
                } else if (md.template_id == 21) { // 21纯图片模板
                    NSDictionary *dic = [md.extra JsonToArrayOrNSDictionary];
                    md.imageModel = [XDNewMessageImageModel objectWithKeyValues:dic];
                } else if (md.template_id == 31) { // 31单图文模板
                    NSDictionary *dic = [md.extra JsonToArrayOrNSDictionary];
                    md.graphicModel = [XDNewMessageGraphicModel objectWithKeyValues:dic];
                } else if (md.template_id == 32) { // 32多图文模板
                    NSArray *array = [md.extra JsonToArrayOrNSDictionary];
                    md.graphicArray = [XDNewMessageGraphicModel objectArrayWithKeyValuesArray:array];
                } else if (md.template_id == 35) { // 35小名片模板
                    NSDictionary *dic = [md.extra JsonToArrayOrNSDictionary];
                    md.cardModel = [XDNewMessageCardModel objectWithKeyValues:dic];
                } else {
                    
                }
                md.from_user_url = self.categoryModel.entry_image_url;
                [self.dataArray addObject:md];
            }
            
            [self.tableView reloadData];
            
        } else {
            [self.view showToastMessage:result[@"message"]];
        }
        
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.mj_header endRefreshing];
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.tableView.mj_footer endRefreshing];
        [self hideHud];
        [self.view showToastMessage:error.localizedDescription];
    }];
}

#pragma mark -TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDNewMessageModel *model = self.dataArray[indexPath.row];
    
    if (model.template_id == 15) { // 15心动币消费模板
        XDCoinComsumeCell *cell = [XDCoinComsumeCell cellWithTableView:tableView];
        cell.model = model;
        return cell;
    } else if (model.template_id == 10) { // 10模板消息模板
        XDTemplateMessageCell *cell = [XDTemplateMessageCell cellWithTableView:tableView];
        cell.model = model;
        return cell;
    } else if (model.template_id == 16) { // 16现金消费模板
        XDCashTopUpCell *cell = [XDCashTopUpCell cellWithTableView:tableView];
        cell.model = model;
        return cell;
    } else if (model.template_id == 32) { // 32多图文模板
        XDMultiGraphicCell *cell = [XDMultiGraphicCell cellWithTableView:tableView];
        XD_WeakSelf
        cell.didSelectMessageItemBlock = ^(NSString *url) {
            XD_StrongSelf
            XDLocalHtmlViewController *htmlVC = [XDLocalHtmlViewController localHtmlViewControllerWithHtmlTitle:nil HtmlString:url];
            [self.navigationController pushViewController:htmlVC animated:YES];
        };
        cell.model = model;
        return cell;
    } else if (model.template_id == 31) { // 31单图文模板
        XDSingleGraphicCell *cell = [XDSingleGraphicCell cellWithTableView:tableView];
        cell.model = model;
        return cell;
    } else if (model.template_id == 35) { // 35小名片模板
        XDBusinessCardCell *cell = [XDBusinessCardCell cellWithTableView:tableView];
        cell.model = model;
        return cell;
    } else {
        // 创建cell
        XDSingleImageMsgCell *cell = [XDSingleImageMsgCell cellWithTableView:tableView];
        cell.model = self.dataArray[indexPath.row];
        if (model.imageModel.img_url.length > 0) {
            _titleStr = cell.model.imageModel.img_url;
        }
        else{
          _titleStr = cell.model.msg_description;
        }
        XD_WeakSelf
        [cell setDidSelectLinkTextOperationBlock:^(NSString *link, MLEmojiLabelLinkType type) {
            if (type == MLEmojiLabelLinkTypeURL) {
                XD_StrongSelf
                XDLocalHtmlViewController *htmlVC = [XDLocalHtmlViewController localHtmlViewControllerWithHtmlTitle:nil HtmlString:link];
                [self.navigationController pushViewController:htmlVC animated:YES];
            }
        }];
        UILongPressGestureRecognizer * longPressGesture =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
        
        longPressGesture.minimumPressDuration=0.8f;//设置长按 时间
        [cell addGestureRecognizer:longPressGesture];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XDNewMessageModel *model = self.dataArray[indexPath.row];
    
    if (model.template_id == 15 || model.template_id == 16) { // 15心动币消费模板,16现金消费模板
        XDLocalHtmlViewController *htmlVC = [XDLocalHtmlViewController localHtmlViewControllerWithHtmlTitle:nil HtmlString:model.comsumeModel.url];
        [self.navigationController pushViewController:htmlVC animated:YES];
    } else if (model.template_id == 10) { // 10模板消息模板
        XDLocalHtmlViewController *htmlVC = [XDLocalHtmlViewController localHtmlViewControllerWithHtmlTitle:nil HtmlString:model.remindModel.url];
        [self.navigationController pushViewController:htmlVC animated:YES];
    } else if (model.template_id == 32) { // 32多图文模板
        
    } else if (model.template_id == 31) { // 31单图文模板
        XDLocalHtmlViewController *htmlVC = [XDLocalHtmlViewController localHtmlViewControllerWithHtmlTitle:nil HtmlString:model.graphicModel.url];
        [self.navigationController pushViewController:htmlVC animated:YES];
    } else if (model.template_id == 35) { // 35小名片模板
        
        if (model.cardModel.url.length > 0) {
            XDLocalHtmlViewController *htmlVC = [XDLocalHtmlViewController localHtmlViewControllerWithHtmlTitle:nil HtmlString:model.cardModel.url];
            [self.navigationController pushViewController:htmlVC animated:YES];
        } else {
//            XDOtherViewController *otherVC = [[XDOtherViewController alloc] init];
//            otherVC.user_id = [NSString stringWithFormat:@"%ld",model.cardModel.user_id];
//            [self.navigationController pushViewController:otherVC animated:YES];
        }
    } else {
        
    }
}

#pragma mark - 左滑删除消息
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    //    return NO;
    // 左滑删除
    return YES;
}

//设置滑动时显示多个按钮
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XDNewMessageModel *model = self.dataArray[indexPath.row];
    
    if (model.to_user_id == 10000) { // 不允许删除
        UITableViewRowAction *otherRowAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleNormal) title:@" ⓘ " handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            
            [self.view makeToast:@"哎呀！消息很重要,不能删除哟"
                        duration:2.0
                        position:CSToastPositionCenter];
            tableView.editing = false;
        }];
        
        return @[otherRowAction];
    } else {
        //添加一个删除按钮
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            
            [self applyCellDeleteFriendAtIndexPath:indexPath];
            
        }];
        //删除按钮颜色
        deleteAction.backgroundColor = [UIColor redColor];
        
        //将设置好的按钮方到数组中返回
        return @[deleteAction];
    }
    
}
//cell长按手势
-(void)cellLongPress:(UILongPressGestureRecognizer *)longRecognizer{
    if (longRecognizer.state==UIGestureRecognizerStateBegan) {
        //成为第一响应者，需重写该方法
        [self becomeFirstResponder];
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"复制",@"分享", nil];
        [sheet showInView:self.view];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        if (buttonIndex != actionSheet.cancelButtonIndex) {
            if (buttonIndex == actionSheet.firstOtherButtonIndex) {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = _titleStr;
                [self showHint:@"复制成功!"];
            } else if (buttonIndex == actionSheet.firstOtherButtonIndex + 1) {
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5/*延迟执行时间*/ * NSEC_PER_SEC));
                
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    XDUMSharedView *view = [[XDUMSharedView alloc] init];
                    view.delegate = self;
                    [view show];
                });
                
            }
        }
    }
}


#pragma mark - 删除某个好友申请消息
- (void)applyCellDeleteFriendAtIndexPath:(NSIndexPath *)indexPath {
    XDNewMessageModel *model = self.dataArray[indexPath.row];
    [self showHudInView:self.view hint:nil];
    [FKL_DataService encryption_requestURL:[NSString url_deleteSingleMessage_withMessageId:model.single_msg_id] parameters:nil withType:@"DELETE" complete:^(id result) {
        [self hideHud];
        if ([result[@"code"] integerValue] == 200) { // 删除成功
            [self.dataArray removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        } else {
            [self.view showToastMessage:result[@"message"]];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        [self.view showToastMessage:error.localizedDescription];
    }];
}

#pragma mark - XDUMSharedView Delegate
- (void)didSelectedToShare:(UMSocialPlatformType)clickedType {
    XDBaseUMShareController *svc = [XDBaseUMShareController new];
    svc.UMS_Text = self.titleStr;
    [svc shareTextToPlatformType:clickedType];
}


@end
