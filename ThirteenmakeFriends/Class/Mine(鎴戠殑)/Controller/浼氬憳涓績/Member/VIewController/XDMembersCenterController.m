//
//  XDMembersCenterController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/11.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDMembersCenterController.h"
#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"
#import "XDCardItemView.h"
#import "XDFlowBottomView.h"
#import "XDMemberItemCell.h"
#import "XDmemberHeaderView.h"
#import "XDmemberFooterView.h"
#import "XDUpgradeBottomView.h"
#import "XDCardModel.h"
#import "ProfileUser.h"
#import "XDAccountTool.h"

#import "XDDetailMeberShipController.h"
//#import "ChatViewController.h"

#import "MBProgressHUD+MJ.h"

#if APP_Puppet  // Puppet

#import "XDUpgradeToPayController.h"

#define ProductID_IAP_Month @"com.soubo.www.puppet.40coins" //包月
#define ProductID_IAP_Permanent @"com.soubo.www.puppet.448coins" //初级
#define ProductID_IAP2pGaoduan @"com.soubo.www.puppet.1998coins"//高端
#define ProductID_IAP9pZhizun @"com.soubo.www.puppet.4998coins" //至尊
#elif APP_myPuppet

#import "XDUpgradeToPayController.h"

#define ProductID_IAP_Month @"com.13platform.www.puppet.40coins" //包月
#define ProductID_IAP_Permanent @"com.13platform.www.puppet.448coins" //初级
#define ProductID_IAP2pGaoduan @"com.13platform.www.puppet.1998coins"//高端
#define ProductID_IAP9pZhizun @"com.13platform.www.puppet.4998coins" //至尊
#else // 正常
#define ProductID_IAP_Month @"com.ThirtyOneDay.www.ThirteenmakeFriends.40coins" //包月
#define ProductID_IAP_Permanent @"com.ThirtyOneDay.www.ThirteenmakeFriends.448coins2" //初级
#define ProductID_IAP2pGaoduan @"com.ThirtyOneDay.www.ThirteenmakeFriends.1998coins"//高端
#define ProductID_IAP9pZhizun @"com.ThirtyOneDay.www.ThirteenmakeFriends.4998coins" //至尊
#endif

@interface XDMembersCenterController () <NewPagedFlowViewDelegate, NewPagedFlowViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

/**
 *  会员数组
 */
@property (nonatomic, strong) NSMutableArray *membersArray;
/**
 *  会员数组
 */
@property (nonatomic, strong) NSArray *memberIconsArray;

/**
 *  底层容器
 */
@property (nonatomic, strong) UIScrollView *bottomScrollView;

/**
 *  轮播图
 */
@property (nonatomic, strong) NewPagedFlowView *pageFlowView;

/**
 *  轮播指示图
 */
@property (nonatomic, strong) XDFlowBottomView *bottomView;

/**
 *  UICollectionView
 */
@property (nonatomic, strong) UICollectionView *collectionView;

/**
 *  底部升级视图
 */
@property (nonatomic, strong) XDUpgradeBottomView *upgradeView;

/**
 *  会员过期时间
 */
@property (nonatomic, copy) NSString *vip_deadline;

/**
 *  是否为审核状态
 */
@property (nonatomic, assign, getter = isStatus) BOOL status;
@end

@implementation XDMembersCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"会员入会";
    
    [self getMembersInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(upgradeToPaySucess)
                                                 name:@"upgradeToPaySucess"
                                               object:nil];
}

- (void)upgradeToPaySucess {
    [self getMembersInfo];
}

- (void)getMembersInfo {
    
    [self showHudInView:self.view hint:@"正在加载中"];
    
    [FKL_DataService requestURL:[NSString url_getMembersInfo] parameters:nil withType:@"GET" format:@"JSON" complete:^(id result) {
        [self hideHud];
        if ([result[@"code"] integerValue] == 200) {
            self.vip_deadline = result[@"data"][@"vip_deadline"];
            self.membersArray = [NSMutableArray arrayWithArray:[XDCardModel objectArrayWithKeyValuesArray:result[@"data"][@"member"]]];
            self.memberIconsArray = [XDVipIconModel objectArrayWithKeyValuesArray:result[@"data"][@"vip_icon"]];
            self.status = [result[@"data"][@"is_status"] boolValue];
            
            [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
            
            if (!self.pageFlowView) { // 视图是否加载
                [self setupUI];
                
                [self initCollectionView];
                
                [self setupUpgradeView];
            } else {
                [self.collectionView reloadData];
            }
            
            [self setScrollViewContentSizeWithIndex:0];
            
            // 滚动到当前会员等级
            ProfileUser *user = [XDAccountTool account];
            NSInteger scorllPage = [user.groupid integerValue] > 0 ? [user.groupid integerValue] - 1 : 0;
            [self.pageFlowView scrollToPage:scorllPage animated:NO];
            
        } else {
            [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
    }];
}

- (void)setupUI {
    
    NewPagedFlowView *pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 270)];
    pageFlowView.backgroundColor = RGBA(68, 63, 77, 0.18);
    pageFlowView.delegate = self;
    pageFlowView.dataSource = self;
    pageFlowView.minimumPageAlpha = 0.5;
    pageFlowView.orginPageCount = self.membersArray.count;
    pageFlowView.isOpenAutoScroll = NO;
    
    pageFlowView.leftRightMargin = 30;
    pageFlowView.topBottomMargin = 12;
    
    /****************************
     使用导航控制器(UINavigationController)
     如果控制器中不存在UIScrollView或者继承自UIScrollView的UI控件
     请使用UIScrollView作为NewPagedFlowView的容器View,才会显示正常,如下
     *****************************/
    
    UIScrollView *bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, iPhoneX ? SCREEN_HEIGHT - NavigationBar_Height - 52 - kSafeBottomHeight : SCREEN_HEIGHT - NavigationBar_Height - 52)];
    [pageFlowView reloadData];
    [bottomScrollView addSubview:pageFlowView];
    [self.view addSubview:bottomScrollView];
    
//    [bottomScrollView addSubview:pageFlowView];
    self.bottomScrollView = bottomScrollView;
    
    self.pageFlowView = pageFlowView;
    
    XDFlowBottomView *bottomView = [[XDFlowBottomView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(pageFlowView.frame), SCREEN_WIDTH, 28)];
    bottomView.backgroundColor = RGBA(68, 63, 77, 0.18);
    [bottomScrollView addSubview:bottomView];
    bottomView.itemsArray = self.memberIconsArray;
    self.bottomView = bottomView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pageFlowViewTap:)];
    [pageFlowView addGestureRecognizer:tap];
}


#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    
    return self.membersArray.count;
}

- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    
    PGIndexBannerSubiew *bannerView = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
    if (!bannerView) {
        //        bannerView = [[PGIndexBannerSubiew alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 270)];
        bannerView = [[PGIndexBannerSubiew alloc] initWithFrame:CGRectMake(0, 0, 171, 246)];
//        bannerView.layer.cornerRadius = 8;
//        bannerView.layer.masksToBounds = YES;
        // 设置阴影
        bannerView.layer.shadowColor = RGBA(0, 0, 0, 0.19).CGColor;
        bannerView.layer.shadowOffset = CGSizeMake(0,2);
        bannerView.layer.shadowOpacity = 0.8;
        bannerView.layer.shadowRadius = 4;
        bannerView.clipsToBounds = NO;
    }
    
    //在这里传递数据
    bannerView.mainImageView.is_status = self.status;
    bannerView.mainImageView.cardModel = self.membersArray[index];
    
    return bannerView;
}

- (void)setScrollViewContentSizeWithIndex:(NSInteger)index {
    XDCardModel *cardModel = [self.membersArray objectAtIndex:index];
    
    CGFloat maxCols = 3;
    // 总行数
    int totalRows = (cardModel.memberShip.count + maxCols - 1) / maxCols;
    self.collectionView.height = 27 + 27 + (totalRows * ((SCREEN_WIDTH - 1) / 3.0 + 0.5));
    self.bottomScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.collectionView.frame));
    
    // 设置底部升级按钮状态
    self.upgradeView.cardModel = cardModel;
    self.upgradeView.vip_deadline = self.vip_deadline;
}

#pragma mark - NewPagedFlowView Delegate
- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
    [self setScrollViewContentSizeWithIndex:pageNumber];
    
    [self.bottomView scrollToPage:pageNumber];
    [self.collectionView reloadData];
}

#pragma mark - NewPagedFlowViewDelegate
-(CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(171, 246);
}

#pragma mark --懒加载
- (NSMutableArray *)membersArray {
    if (_membersArray == nil) {
        _membersArray = [NSMutableArray array];
    }
    return _membersArray;
}


#pragma mark - 底部collectionView
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0.5;
        layout.minimumLineSpacing = 0.5;
        // 设置collectionView的滚动方向，需要注意的是如果使用了collectionview的headerview或者footerview的话， 如果设置了水平滚动方向的话，那么就只有宽度起作用了了
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
//        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        // layout.minimumInteritemSpacing = 10;// 垂直方向的间距
        // layout.minimumLineSpacing = 10; // 水平方向的间距
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bottomView.frame), SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
        _collectionView.backgroundColor = RGB(230, 230, 230);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}

- (void)initCollectionView {
    [self.bottomScrollView addSubview:self.collectionView];
    
    // 注册collectionViewcell:XDmemberItemCellID是我自定义的cell的类型
    [self.collectionView registerClass:[XDmemberItemCell class] forCellWithReuseIdentifier:@"XDmemberItemCellID"];
    
    // 注册collectionview底部的view,需要注意的是这里的view需要继承自UICollectionReusableView
    [self.collectionView registerClass:[XDmemberHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XDmemberHeaderViewID"];
    
    // 注册collectionview底部的view,需要注意的是这里的view需要继承自UICollectionReusableView
    [self.collectionView registerClass:[XDmemberFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"XDmemberFooterViewID"];
}

#pragma mark -- UICollectionViewDataSource
/** 每组cell的个数*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return 9;
    XDCardModel *cardModel = [self.membersArray objectAtIndex:self.pageFlowView.currentPageIndex];
    return cardModel.memberShip.count;
}

/** cell的内容*/
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XDmemberItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XDmemberItemCellID" forIndexPath:indexPath];
    
    XDCardModel *cardModel = self.membersArray[self.pageFlowView.currentPageIndex];
    cell.shipModel = cardModel.memberShip[indexPath.row];
    return cell;
}

/** 总共多少组*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

/** 头部/底部*/
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        // 头部
        XDmemberHeaderView *view =  [collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:@"XDmemberHeaderViewID"   forIndexPath:indexPath];
        return view;
        
    } else {
        // 底部
        XDmemberFooterView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"XDmemberFooterViewID" forIndexPath:indexPath];
        return view;
    }
}

#pragma mark -- UICollectionViewDelegateFlowLayout
/** 每个cell的尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH - 1) / 3.0, (SCREEN_WIDTH - 1) / 3.0);
}

/** 头部的尺寸*/
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(self.view.bounds.size.width, 27);
}

/** 顶部的尺寸*/
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return CGSizeMake(self.view.bounds.size.width, 27);
}

#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XDCardModel *cardModel = [self.membersArray objectAtIndex:self.pageFlowView.currentPageIndex];
    XDDetailMeberShipController *detailVC = [[XDDetailMeberShipController alloc] init];
    detailVC.shipModel = [cardModel.memberShip objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark - 升级会员按钮
- (void)setupUpgradeView {
    XD_WeakSelf
//    XDUpgradeBottomView *upgradeView = [[XDUpgradeBottomView alloc] initWithFrame:CGRectMake(0, self.view.size.height - 52, self.view.width, 52)];
    XDUpgradeBottomView *upgradeView = [[XDUpgradeBottomView alloc] initWithFrame:CGRectMake(0, iPhoneX ? self.view.size.height - 52 - kSafeBottomHeight : self.view.size.height - 52, self.view.width, iPhoneX ? kSafeBottomHeight + 52 : 52)];
    [self.view addSubview:upgradeView];
    self.upgradeView = upgradeView;
    
    upgradeView.serviceButtonClicked = ^(UIButton *btn) {
        XD_StrongSelf
        NSDictionary *dict = @{@"来源" : @"会员升级"};
        [MobClick event:@"service_source" attributes:dict];
        
//        ChatViewController *chatVC = [[ChatViewController alloc] initWithConversationChatter:kServiceName conversationType:eConversationTypeChat];
//        chatVC.title = kServiceNiceName;
//        [self.navigationController pushViewController:chatVC animated:YES];
    };
    
    upgradeView.upgradeButtonClicked = ^(UIButton *btn) {
        
        
#if APP_Puppet  // Puppet
        XD_StrongSelf
        XDCardModel *cardModel = [self.membersArray objectAtIndex:self.pageFlowView.currentPageIndex];
        if (self.isStatus) {
            ProfileUser *user = [XDAccountTool account];
            if ([user.groupid integerValue] >= cardModel.groupid) {
                [self.view makeToast:@"您已拥有此会员的相关权益，无须再升级了。" duration:2.0 position:CSToastPositionCenter];
            } else {
                [self buy:(int)cardModel.orgPrice];
            }
            
        } else {
            ProfileUser *user = [XDAccountTool account];
            if ([user.groupid integerValue] > cardModel.groupid || ([user.groupid integerValue] == 2 && cardModel.groupid == 2)) {
                [self.view makeToast:@"您已拥有此会员的相关权益，无须再升级了。" duration:2.0 position:CSToastPositionCenter];
            } else if ([user.groupid integerValue] <= 4 && cardModel.groupid == 5) {
                [self.view makeToast:@"您可以去咨询客服去升级该会员。" duration:2.0 position:CSToastPositionCenter];
            } else if ([user.groupid integerValue] == cardModel.groupid && cardModel.allPrice == 0) {
                [self.view makeToast:@"您已拥有此会员的相关权益，暂时无须升级。" duration:2.0 position:CSToastPositionCenter];
            } else {
                XDUpgradeToPayController *payVC = [[XDUpgradeToPayController alloc] init];
                payVC.cardModel = [self.membersArray objectAtIndex:self.pageFlowView.currentPageIndex];
                [self.navigationController pushViewController:payVC animated:YES];
            }
        }
#elif APP_myPuppet
            XD_StrongSelf
            XDCardModel *cardModel = [self.membersArray objectAtIndex:self.pageFlowView.currentPageIndex];
            if (self.isStatus) {
                ProfileUser *user = [XDAccountTool account];
                if ([user.groupid integerValue] >= cardModel.groupid) {
                    [self.view makeToast:@"您已拥有此会员的相关权益，无须再升级了。" duration:2.0 position:CSToastPositionCenter];
                } else {
                    [self buy:(int)cardModel.orgPrice];
                }
                
            } else {
                ProfileUser *user = [XDAccountTool account];
                if ([user.groupid integerValue] > cardModel.groupid || ([user.groupid integerValue] == 2 && cardModel.groupid == 2)) {
                    [self.view makeToast:@"您已拥有此会员的相关权益，无须再升级了。" duration:2.0 position:CSToastPositionCenter];
                } else if ([user.groupid integerValue] <= 4 && cardModel.groupid == 5) {
                    [self.view makeToast:@"您可以去咨询客服去升级该会员。" duration:2.0 position:CSToastPositionCenter];
                } else if ([user.groupid integerValue] == cardModel.groupid && cardModel.allPrice == 0) {
                    [self.view makeToast:@"您已拥有此会员的相关权益，暂时无须升级。" duration:2.0 position:CSToastPositionCenter];
                } else {
                    XDUpgradeToPayController *payVC = [[XDUpgradeToPayController alloc] init];
                    payVC.cardModel = [self.membersArray objectAtIndex:self.pageFlowView.currentPageIndex];
                    [self.navigationController pushViewController:payVC animated:YES];
                }
            }
#else // 正常
        XD_StrongSelf
        XDCardModel *cardModel = [self.membersArray objectAtIndex:self.pageFlowView.currentPageIndex];
        
        ProfileUser *user = [XDAccountTool account];
        if ([user.groupid integerValue] > cardModel.groupid || ([user.groupid integerValue] == 2 && cardModel.groupid == 2)) {
            [self.view makeToast:@"您已拥有此会员的相关权益，无须再升级了。" duration:2.0 position:CSToastPositionCenter];
        } else if ([user.groupid integerValue] == cardModel.groupid && cardModel.allPrice == 0) {
            [self.view makeToast:@"您已拥有此会员的相关权益，暂时无须升级。" duration:2.0 position:CSToastPositionCenter];
        } else {
            [self buy:(int)cardModel.orgPrice];
        }
#endif
    };
}

#pragma mark - pageFlowView 点击
- (void)pageFlowViewTap:(UITapGestureRecognizer *)tap {
    NSLog(@"卡片被点击");
    
    CGPoint point = [tap locationInView:tap.view];
    
    if (point.x > SCREEN_WIDTH / 2.0) {
        NSInteger page = self.pageFlowView.currentPageIndex + 1;
//        NSInteger page = self.pageFlowView.currentPageIndex == self.membersArray.count - 1 ? 0 : self.pageFlowView.currentPageIndex + 1;
        [self.pageFlowView scrollToPage:page animated:YES];
        [self.bottomView scrollToPage:page];
        [self.collectionView reloadData];
    } else {
        NSInteger page = self.pageFlowView.currentPageIndex - 1;
//        NSInteger page = self.pageFlowView.currentPageIndex == 0 ? self.membersArray.count - 1: self.pageFlowView.currentPageIndex - 1;
        [self.pageFlowView scrollToPage:page animated:YES];
        [self.bottomView scrollToPage:page];
        [self.collectionView reloadData];
    }
}

#pragma mark - IAP支付
-(void)buy:(int)type
{
    buyType = type;
    if ([SKPaymentQueue canMakePayments]) {
        NSLog(@"允许程序内付费购买");
        [self RequestProductData];
    }
    else
    {
        NSLog(@"不允许程序内付费购买");
        UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"您的手机没有打开程序内付费购买"
                                                           delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];
        
        [alerView show];
        
        
    }
}

/**
 *  请求可卖商品
 */
-(void)RequestProductData
{
    // 增加提示
    //    [MBProgressHUD showMessage:nil];
    [self showHudInView:self.view hint:@"正在购买，请不要离开..."];
    
    NSLog(@"---------请求对应的产品信息------------");
    NSArray *product = nil;
    switch (buyType) {
        case IAP0pMonth:
            product=[[NSArray alloc] initWithObjects:ProductID_IAP_Month,nil];
            break;
        case IAP0pPpermanent:
            product=[[NSArray alloc] initWithObjects:ProductID_IAP_Permanent,nil];
            break;
        case IAP0pGaoduan:
            product=[[NSArray alloc] initWithObjects:ProductID_IAP2pGaoduan,nil];
            break;
        case IAP1pZhizun:
            product=[[NSArray alloc] initWithObjects:ProductID_IAP9pZhizun,nil];
            break;
            
        default:
            break;
    }
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request=[[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate=self;
    [request start];
    
}

//<SKProductsRequestDelegate> 请求协议
//收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    // 隐藏提示
    [self hideHud];
    NSLog(@"--------------收到产品反馈消息---------------------");
    NSArray *product = response.products;
    if([product count] == 0){
        [self.view makeToast:@"无法获取产品信息，请重试" duration:2.0 position:CSToastPositionCenter];
        NSLog(@"--------------没有商品------------------");
        return;
    }
    
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    NSLog(@"产品付费数量:%lu",(unsigned long)[product count]);
    
    SKProduct *p = nil;
    for (SKProduct *pro in product) {
        NSLog(@"SKProduct 描述信息%@", [pro description]);
        NSLog(@"产品标题 %@", [pro localizedTitle]);
        NSLog(@"产品描述信息: %@", [pro localizedDescription]);
        NSLog(@"价格: %@", [pro price]);
        NSLog(@"Product id: %@", [pro productIdentifier]);
        
        NSString *product_id = nil;
        switch (buyType) {
            case IAP0pMonth:
                product_id = ProductID_IAP_Month;
                p = pro;
                break;
            case IAP0pPpermanent:
                product_id = ProductID_IAP_Permanent;
                p = pro;
                break;
            case IAP0pGaoduan:
                product_id = ProductID_IAP2pGaoduan;
                p = pro;
                break;
            case IAP1pZhizun:
                product_id = ProductID_IAP9pZhizun;
                p = pro;
                break;
                
            default:
                break;
        }
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    
    NSLog(@"发送购买请求");
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

//弹出错误信息
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    // 隐藏提示
    [self hideHud];
    NSLog(@"-------弹出错误信息----------");
    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert",NULL) message:[error localizedDescription]
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"Close",nil) otherButtonTitles:nil];
    [alerView show];
    
}

-(void)requestDidFinish:(SKRequest *)request
{
    // 隐藏提示
    [self hideHud];
    NSLog(@"----------反馈信息结束--------------");
    
}

//<SKPaymentTransactionObserver> 千万不要忘记绑定，代码如下：
//----监听购买结果
//[[SKPaymentQueue defaultQueue] addTransactionObserver:self];

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions//交易结果
{
    NSLog(@"-----paymentQueue--------");
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:{//交易完成
                [self completeTransaction:transaction];
                NSLog(@"-----交易完成 --------");
                //购买成功后进行验证
                [self verifyPurchaseWithPaymentTransaction];
                
            } break;
            case SKPaymentTransactionStateFailed://交易失败
            {
                [self failedTransaction:transaction];
                NSLog(@"-----交易失败 --------");
                
            }break;
            case SKPaymentTransactionStateRestored://已经购买过该商品
                [self restoreTransaction:transaction];
                NSLog(@"-----已经购买过该商品 --------");
            case SKPaymentTransactionStatePurchasing:      //商品添加进列表
                NSLog(@"-----商品添加进列表 --------");
                [self.view makeToast:@"正在请求付费信息，请稍后" duration:1.5 position:CSToastPositionCenter];
                break;
            default:
                break;
        }
    }
}

/**
 *  验证购买，避免越狱软件模拟苹果请求达到非法购买问题
 *
 */
- (void)verifyPurchaseWithPaymentTransaction {
    //从沙盒中获取交易凭证并且拼接成请求体数据
    NSURL *receiptUrl=[[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData=[NSData dataWithContentsOfURL:receiptUrl];
    
    NSString *receiptString=[receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];//转化为base64字符串
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"apple_receipt"] = receiptString;
    paras[@"user_id"] = User_ID;
    paras[@"number"] = @(buyType);
    if (buyType == IAP0pGaoduan) {
        paras[@"level"] = @"3";
    } else if (buyType == IAP1pZhizun) {
        paras[@"level"] = @"4";
    } else if (buyType == IAP0pMonth) {
        paras[@"level"] = @"1";
    } else if (buyType == IAP0pPpermanent) {
        paras[@"level"] = @"2";
    } else {
        paras[@"level"] = @"0";
    }
    
    __weak __typeof__(self) weakSelf = self;
    
    [FKL_DataService requestURL:[NSString url_IAPPurchase_validate] parameters:paras withType:@"POST" format:@"JSON" complete:^(id result) {
        if ([result[@"code"] integerValue] == 200) {
            ProfileUser *user = [XDAccountTool account];
            user.groupid = result[@"data"][@"groupid"];
            [XDAccountTool save:user];
            [MBProgressHUD showSuccess:@"购买成功"];
            [weakSelf.collectionView reloadData];
        } else {
            [MBProgressHUD showMessage:result[@"message"]];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction

{
    NSLog(@"-----completeTransaction--------");
    // Your application should implement these two methods.
    NSString *product = transaction.payment.productIdentifier;
    if ([product length] > 0) {
        
        NSArray *tt = [product componentsSeparatedByString:@"."];
        NSString *bookid = [tt lastObject];
        if ([bookid length] > 0) {
            [self recordTransaction:bookid];
            [self provideContent:bookid];
        }
    }
    
    // Remove the transaction from the payment queue.
    // 来允许你从支付队列中移除交易
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

//记录交易
-(void)recordTransaction:(NSString *)product{
    NSLog(@"-----记录交易--------");
}

//处理下载内容
-(void)provideContent:(NSString *)product{
    NSLog(@"-----下载--------");
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction{
    if(transaction.error.code != SKErrorPaymentCancelled) {
        UIAlertView *alerView2 =  [[UIAlertView alloc] initWithTitle:@"提示"
                                                message:transaction.error.localizedDescription
                                                            delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];
        
        [alerView2 show];
    } else {
        [self.view makeToast:@"交易取消成功" duration:1.5 position:CSToastPositionCenter];
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

-(void) paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentTransaction *)transaction{
    
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@" 交易恢复处理");
    
}

-(void) paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    NSLog(@"-------paymentQueue----");
}

-(void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];//解除监听
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end
