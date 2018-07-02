//
//  XDRankListViewController.m
//  ThirteenmakeFriends
//
//  Created by 空谷凌虚 on 2018/5/22.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDRankListViewController.h"

#import "ContributeCell.h"
#import "XDRankRxMlModel.h"

#import "XDAccountTool.h"
#import "ProfileUser.h"


#import "XDRefreshHeader.h"
#import "MJRefresh.h"
#import "HMSegmentedControl.h"
//#import "XDOtherViewController.h"
#import "XDRankListHeaderView.h"


@interface XDRankListViewController ()<UITableViewDelegate,UITableViewDataSource,XDErrorViewDelegate>{
    XDErrorView *_errorView;
}

@property(nonatomic,strong) XDRankListHeaderView *headerView;

@property (weak, nonatomic) IBOutlet UIImageView *bgBackImg;


@property (weak, nonatomic) IBOutlet UIView *segMentView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;




@property (weak, nonatomic) IBOutlet UILabel *bottomLab1;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImg1;
@property (weak, nonatomic) IBOutlet UILabel *bottomLab2;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImg2;
@property (weak, nonatomic) IBOutlet UILabel *bottomrLab1;
@property (weak, nonatomic) IBOutlet UILabel *bottomrLab2;

@property (weak, nonatomic) IBOutlet UIImageView *bottomimg1Bg;


@property(nonatomic,strong)UIColor *normalColor;
@property(nonatomic,copy)NSString *normalStr;

@property (nonatomic,strong)  NSMutableArray       *dataArr;

//! 分页页码
@property (nonatomic, assign) NSInteger pageIndex;
//! 分页最大页码
@property (nonatomic, assign) NSInteger MaxPage;

@property (nonatomic, strong) HMSegmentedControl *segmentControl;

@end

@implementation XDRankListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"贡献榜";
 
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 70;
    self.tableView.tableFooterView = [self setTabViewFooterView:NO];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
//    [self setupErrorView];

     
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
//    WEAKSELF
//    self.tableView.mj_header = [XDRefreshHeader headerWithRefreshingBlock:^{
//        [weakSelf reloadNewData];
//    }];
//
//    // 马上进入刷新状态
//    [self.tableView.mj_header beginRefreshing];
//
//    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadMoreData)];
    
   
    
    _normalColor = nil;
    _normalStr = nil;
    self.dataArr = [NSMutableArray array];

    if (_rankType == 0 || _rankType == 1) {
        _bgBackImg.image = [UIImage imageNamed:@"bodong-1"];
        self.headerView.bgBackImg1.image = [UIImage imageNamed:@"renxing"];
        
        _normalColor = RGB(97, 60, 187);
        _normalStr = @"消耗钻石";
    }else if (_rankType == 2 || _rankType == 3) {
        _bgBackImg.image = [UIImage imageNamed:@"bodong"];
         self.headerView.bgBackImg1.image = [UIImage imageNamed:@"meili"];
        
        _normalColor = RGB(232, 63, 120);
        _normalStr  = @"获得魅力";
    }
    
    self.segmentControl                 = [[HMSegmentedControl alloc]initWithSectionTitles:@[@"周榜",@"月榜"]];
    self.segmentControl.backgroundColor = [UIColor clearColor];
    self.segmentControl.frame                        = self.segMentView.bounds;
    self.segmentControl.segmentEdgeInset             = UIEdgeInsetsMake(0, 0, 0, 0);
    self.segmentControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.segmentControl.selectedSegmentIndex         = 0;
    self.segmentControl.selectionStyle               = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.segmentControl.selectionIndicatorLocation   = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentControl.selectionIndicatorColor      =  _normalColor ;
    self.segmentControl.selectionIndicatorHeight     = 2;
    
    self.segmentControl.titleTextAttributes          = @{
                                                         NSFontAttributeName : kPingFangBoldFont(14),
                                                         NSForegroundColorAttributeName : RGB(119, 119, 119)
                                                         };
    self.segmentControl.selectedTitleTextAttributes  = @{
                                                         NSFontAttributeName : kPingFangBoldFont(14),
                                                         NSForegroundColorAttributeName : _normalColor
                                                         };
    
    
    XD_WeakSelf
    [self.segmentControl setIndexChangeBlock:^(NSInteger index) {
        XD_StrongSelf
        if (_rankType == 0 || _rankType == 1) {
            _rankType = index==0?0:1;
            
        }else if (_rankType == 2 || _rankType == 3) {
             _rankType = index==0?2:3;
        }
         [self requestData];
//        [self.tableView.mj_header beginRefreshing];
//        [self scrollviewDidScrollWithIndex:index];
//        [self.scrollView setContentOffset:CGPointMake(index * SCREEN_WIDTH, 0)];
    }];
    [self.segMentView addSubview:self.segmentControl];
    
    self.segMentView.layer.cornerRadius = 5;
    self.segMentView.layer.masksToBounds = YES;
    
   

    
    XDRankListHeaderView*headerView = [[[NSBundle mainBundle]loadNibNamed:@"XDRankListHeaderView" owner:self options:nil]lastObject];

    CGFloat width = SCREEN_WIDTH-40;
    headerView.frame = CGRectMake(0, 0,width , 280);
    self.tableView.tableHeaderView = headerView;
    self.headerView = headerView;
    
    [self configRankHeaderView];
    
    [self requestData];
}


-(UIView *)setTabViewFooterView:(BOOL)ismore{
    
    if (!ismore) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-40, SCREEN_HEIGHT - 400)];
        view.backgroundColor = UIColor.whiteColor;
        UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer* shape = [[CAShapeLayer alloc] init];
        [shape setPath:rounded.CGPath];
        view.layer.mask = shape;
        return view;
    }
    return [UIView new];
}

-(void)configRankHeaderView{
    
    self.view.backgroundColor = _normalColor;
     self.headerView.rank1NumLab.textColor = _normalColor;
     self.headerView.rank2NumLab.textColor = _normalColor;
     self.headerView.rank3NumLab.textColor = _normalColor;
     self.headerView.rank1SubLab.text = _normalStr;
     self.headerView.rank2SubLab.text = _normalStr;
     self.headerView.rank3SubLab.text = _normalStr;
    
     self.headerView.rank1HeaderImg.layer.cornerRadius = 30.f;
     self.headerView.rank1HeaderImg.layer.masksToBounds = YES;
    
     self.headerView.rank2HeaderImg.layer.cornerRadius = 32.f;
     self.headerView.rank2HeaderImg.layer.masksToBounds = YES;
    
     self.headerView.rank3HeaderImg.layer.cornerRadius = 30.f;
     self.headerView.rank3HeaderImg.layer.masksToBounds = YES;
    

    CGAffineTransform transform= CGAffineTransformMakeRotation(M_PI*0.15);
     self.headerView.huangguanImgView.transform = transform;
}




-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count>3?self.dataArr.count-3:0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ContributeCell *cell = [ContributeCell cellWithTableView:tableView];
    cell.rankingLab.text = [NSString stringWithFormat:@"%ld",indexPath.row+4];
    cell.rankRM = self.dataArr[indexPath.row+3];
    
//    cell.amountLab.textColor = _normalColor;
//    cell.addInfoLab.text =_normalStr;
    cell.rankType = self.rankType;
    return cell;
}

//#pragma mark - 获取数据
//- (void)reloadNewData {
//
//    if (![[AppUpdateInfo sharedInstance] isHavingNetworking]) {
//
//        if (self.dataArr.count == 0) {
//            // 添加自定义错误(断网)提示
//            _errorView = [_errorView addErrorViewWithType:@"error_nonet"];
//        }
//
//        return;
//    }
//
//    _pageIndex = 1;
//
//    [self requestData];
//}
//
//- (void)reloadMoreData {
//    if (_pageIndex < self.MaxPage) {
//        _pageIndex = _pageIndex + 1;
//
//        [self requestData];
//
//    } else {
//        // 已经全部加载完毕
//        [self.tableView.mj_footer endRefreshingWithNoMoreData];
//    }
//}

- (void)requestData {
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
//    paras[@"page"] = @(_pageIndex);
    NSInteger rank_type = 100;
    if (_rankType == 0 ){
        rank_type = 100;
    }else if (_rankType == 1) {
        rank_type = 200;
    }else if (_rankType == 2) {
        rank_type = 110;
    }else if (_rankType == 3) {
        rank_type = 210;
    }
    paras[@"rank_type"] = @(rank_type);
    
    // 公钥加密
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    [FKL_DataService requestURL:[NSString url_getGiftsRankingLists] parameters:paras headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"GET" format:@"JSON" complete:^(id result) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if ([result[@"code"] integerValue] == 200) {
            self.MaxPage = [result[@"maxpage"] integerValue];
//            if (_pageIndex == 1) {
                self.dataArr = [NSMutableArray array];
//            }
            
             NSArray *records = [XDRankRxMlModel objectArrayWithKeyValuesArray:result[@"data"]];
             [self configBottomView:result[@"otherData"]];
//            if (self.dataArr.count == 0 && records.count == 0) {
//                // 无数据
//                _errorView = [_errorView addErrorViewWithType:error_nodata_flag];
//                return ;
//            }

            [self.dataArr addObjectsFromArray:records];
            self.tableView.tableFooterView = [self setTabViewFooterView:self.dataArr.count>3?YES:NO];
            if (self.dataArr.count >= 3) {
               [self setRank2View:self.dataArr[0]];
               [self setRank1View:self.dataArr[1]];
               [self setRank3View:self.dataArr[2]];
            }else{
                if (self.dataArr.count == 1) {
                    [self setRank2View:self.dataArr[0]];
                    [self setRank1View:nil];
                    [self setRank3View:nil];
                    
                }else  if (self.dataArr.count == 2) {
                       [self setRank2View:self.dataArr[0]];
                       [self setRank1View:self.dataArr[1]];
                       [self setRank3View:nil];
                }else{
                    [self setRank2View:nil];
                    [self setRank1View:nil];
                    [self setRank3View:nil];
                }
            }
           
            // 移除ErrorView
//            _errorView = [_errorView removeErrorView];
            
            [self.tableView reloadData];
        } else {
            [self.view makeToast:result[@"message"]
                        duration:2.0
                        position:CSToastPositionCenter];
        }
        

    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        [self.view makeToast:error.localizedDescription
                    duration:2.0
                    position:CSToastPositionCenter];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}


/**
 *  初始化--错误提示界面
 */
- (void)setupErrorView {
    _errorView = [XDErrorView errorViewWithSuperView:self.view Frame:self.view.bounds];
    _errorView.delegate = self;
}

#pragma mark - XDErrorViewDelegate
- (void)errorViewAddErrorView:(XDErrorView *)errorView {
    self.tableView.scrollEnabled = NO;
}

- (void)errorViewRemoveErrorView:(XDErrorView *)errorView {
    self.tableView.scrollEnabled = YES;
}

- (void)errorViewTapedErrorView:(XDErrorView *)errorView{
    // 请求数据
    [self requestData];
}





-(void)setRank1View:(XDRankRxMlModel*)rankRM{
    [ self.headerView.rank1HeaderImg sd_setImageWithURL:[NSURL URLWithString:rankRM.avatar] placeholderImage:[UIImage imageNamed:@"square_image_placeholder"]];
   
    if (rankRM) {
          self.headerView.rank1sexImg.image = [UIImage imageNamed:rankRM.sex==0?@"male":@"group9"];
    }else{
         self.headerView.rank1sexImg.image = nil;
          self.headerView.rank1ConVer.constant = 0;
    }
     self.headerView.rank1NameLab.text = rankRM.nickname.length?rankRM.nickname:@"暂无";
     self.headerView.rank1NumLab.text = [NSString stringWithFormat:@"%ld",rankRM.diamonds];
    
    if (rankRM) {
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewClicked:)];
         self.headerView.rank1HeaderImg.userInteractionEnabled = YES;
        [ self.headerView.rank1HeaderImg addGestureRecognizer:tap];
    }

}
-(void)setRank2View:(XDRankRxMlModel*)rankRM{
    [ self.headerView.rank2HeaderImg sd_setImageWithURL:[NSURL URLWithString:rankRM.avatar] placeholderImage:[UIImage imageNamed:@"square_image_placeholder"]];
   
    if (rankRM) {
         self.headerView.rank2sexImg.image = [UIImage imageNamed:rankRM.sex==0?@"male":@"group9"];
    }else{
          self.headerView.rank2sexImg.image = nil;
           self.headerView.rank2ConVer.constant = 0;
    }
     self.headerView.rank2NameLab.text =  rankRM.nickname.length?rankRM.nickname:@"暂无";
     self.headerView.rank2NumLab.text = [NSString stringWithFormat:@"%ld",rankRM.diamonds];
    
    if (rankRM) {
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewClicked:)];
         self.headerView.rank2HeaderImg.userInteractionEnabled = YES;
        [ self.headerView.rank2HeaderImg addGestureRecognizer:tap];
    }
}
-(void)setRank3View:(XDRankRxMlModel*)rankRM{
    [ self.headerView.rank3HeaderImg sd_setImageWithURL:[NSURL URLWithString:rankRM.avatar] placeholderImage:[UIImage imageNamed:@"square_image_placeholder"]];
    
    if (rankRM) {
         self.headerView.rank3sexImg.image = [UIImage imageNamed:rankRM.sex==0?@"male":@"group9"];
    }else{
         self.headerView.rank3sexImg.image = nil;
          self.headerView.rank3ConVer.constant = 0;
    }

     self.headerView.rank3NameLab.text =  rankRM.nickname.length?rankRM.nickname:@"暂无";
     self.headerView.rank3NumLab.text = [NSString stringWithFormat:@"%ld",rankRM.diamonds];
    
    if (rankRM) {
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewClicked:)];
          self.headerView.rank3HeaderImg.userInteractionEnabled = YES;
        [ self.headerView.rank3HeaderImg addGestureRecognizer:tap];
    }
}


-(void)configBottomView:(NSDictionary*)dic{
    
     ProfileUser *user = [XDAccountTool account];
    
    self.bottomLab1.text   = dic[@"self_rank"];
//    self.bottomimg1Bg.image = [UIImage imageNamed:@""];

     [self.bottomImg1 sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"square_image_placeholder"]];
   
    self.bottomLab2.text = user.nickname;
    self.bottomImg2.image = [UIImage imageNamed:user.sex==0?@"male":@"group9"];
    
    self.bottomrLab1.text = [NSString stringWithFormat:@"%@",dic[@"self_diamonds"]];
    self.bottomrLab1.textColor = _normalColor;
    self.bottomrLab2.text = _normalStr;
    
    
    if (dic) {
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewClicked:)];
        self.bottomImg1.userInteractionEnabled = YES;
        [self.bottomImg1 addGestureRecognizer:tap];
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    XDRankRxMlModel *model = self.dataArr[indexPath.row+3];
//    XDOtherViewController *personVC = [[XDOtherViewController alloc] init];
//    personVC.user_id  = model.user_id;
//    personVC.username = model.nickname;
//    [self.navigationController pushViewController:personVC animated:YES];
}

-(void)headerViewClicked:(UITapGestureRecognizer*)tap{
    NSString *user_id = nil;
    NSString *nickname = nil;
    
    if (tap.view ==  self.headerView.rank1HeaderImg) {
        XDRankRxMlModel *rm =  self.dataArr[1];
        user_id = rm.user_id;
        nickname = rm.nickname;
    }else if (tap.view ==  self.headerView.rank2HeaderImg){
        XDRankRxMlModel *rm =  self.dataArr[0];
        user_id = rm.user_id;
        nickname = rm.nickname;
    }else if (tap.view ==  self.headerView.rank3HeaderImg){
        XDRankRxMlModel *rm =  self.dataArr[2];
        user_id = rm.user_id;
        nickname = rm.nickname;
    }else if (tap.view == self.bottomImg1){
         ProfileUser *user = [XDAccountTool account];
        user_id = user.user_id;
        nickname = user.username;
    }
//    XDOtherViewController *personVC = [[XDOtherViewController alloc] init];
//    personVC.user_id  = user_id;
//    personVC.username = nickname;
//    [self.navigationController pushViewController:personVC animated:YES];
}

@end
