//
//  MineViewController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 15/12/28.
//  Copyright © 2015年 ThirtyOneDay. All rights reserved.
//

#import "MineViewController.h"
#import "HMCommonGroup.h"
#import "HMCommonItem.h"
#import "HMCommonCell.h"
#import "HMCommonArrowItem.h"
#import "HMCommonLabelCustomItem.h"
#import "MineHeaderView.h"
#import "MyModuleView.h"

#import "MyAttitudeViewController.h"
#import "MyFansViewController.h"
#import "MySendPostViewController.h"
//#import "MessageViewController.h"
#import "MJRefresh.h"
#import "ProfileUser.h"
#import "MJExtension.h"
#import "MBProgressHUD+Add.h"
#import "UserProfileManager.h"
#import "AppUpdateInfo.h"

// 客服聊天
//#import "ChatViewController.h"

//#import "MyJCBViewController.h"
//#import "XDCharmViewController.h"
#import "XDMembersCenterController.h"

#import "XDMineSettingController.h"
#import "XDEditdataController.h"
#import "XDAccountTool.h"
#import "TOCropViewController.h"
#import "XDGetCouponView.h"
#import "XDCardPackageController.h"
#import "CYPromptCover.h"
#import "XDLocalHtmlViewController.h"
#import "XDUpdateVersionView.h"
#import "XDAnthoritationModel.h"

@interface MineViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,TOCropViewControllerDelegate>
{
    BOOL isOpendCamera;
}

@property (strong, nonatomic) MineHeaderView *headerView;

@property (strong, nonatomic) ProfileUser *user;

@property (nonatomic, weak) UIButton *rightBtn;

@end

@implementation MineViewController

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (id)init
{
    return [self initWithStyle:UITableViewStylePlain];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //去除 navigationBar 底部的细线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    self.navigationItem.title = nil;
    self.tableView.contentInset = UIEdgeInsetsMake(-NavigationBar_Height, 0, 0, 0);
    self.view.backgroundColor = DefaultColor_BG_gray;
    
    self.user = [XDAccountTool account];
    [self setupTableHeaderView];
    self.tableView.sectionHeaderHeight = 10;
    // 初始化模型数据
    [self setupGroups];
    
    // 集成刷新控件
    [self xdd_setupRefreshControl];
    
    [self setupNav];
    
//    [self newbieGuide];
}

- (void)setupNav {
    
    UIBarButtonItem *leftNegativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
    // leftNegativeSpacer为占位符
    leftNegativeSpacer.width = -10;
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 44)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitle:@"编辑资料" forState:UIControlStateNormal];
    [rightBtn setTitleColor:HEXCOLOR(0xFFFFFF) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(headerClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:RGB(189, 140, 68) forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItems = @[leftNegativeSpacer, rightItem];
    self.rightBtn = rightBtn;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (isOpendCamera != YES) {
        // 获取用户信息
        [self setupData];
    }
}
/**
 *  获取用户信息
 */
- (void)setupData {
    
    [XDRequestHttpTool request_myIndividualInfo_withParameters:nil complete:^(id result) {
        if ([result[@"code"] integerValue] == 200) {
            self.user = [ProfileUser objectWithKeyValues:result[@"data"]];
            // 存储账号
            [XDAccountTool save:self.user];
            [self setupTableHeaderView];
            [self.tableView reloadData];
        } else {
            [self.view makeToast:result[@"message"]
                        duration:2.0
                        position:CSToastPositionCenter];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}

/**
 *  集成刷新控件
 */
- (void)xdd_setupRefreshControl {
    // 1.下拉刷新
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [XDRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf reloadNewData];
    }];
}

- (void)reloadNewData {
    // 拿到当前的下拉刷新控件，结束刷新状态
    [self.tableView.mj_header endRefreshing];
    
    [self setupData];
}

- (void)setupTableHeaderView {
    MineHeaderView *headerView = [[MineHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120 + 5 + NavigationBar_Height)];
    self.tableView.tableHeaderView = headerView;
    self.headerView = headerView;
    ProfileUser *user = [[ProfileUser alloc]init];
    if (!user.user_id) {
        headerView.user = nil;
    } else {
        headerView.user = user;
    }
    
    UITapGestureRecognizer *tapHeaderView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerViewClicked)];
    [self.headerView addGestureRecognizer:tapHeaderView];
    self.headerView.userInteractionEnabled = YES;
    
    // 头像点击
    UITapGestureRecognizer *tapHeader = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headIconClicked)];
    [self.headerView.headIcon addGestureRecognizer:tapHeader];
    self.headerView.headIcon.userInteractionEnabled = YES;
    
    //  视频认证
    UITapGestureRecognizer *autheViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(autheViewTapClicked)];
    [self.headerView.autheView addGestureRecognizer:autheViewTap];
    
//    [self.headerView.setting addTarget:self action:@selector(headerClicked) forControlEvents:UIControlEventTouchUpInside];
    // 关注
    UITapGestureRecognizer *attitude = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(attitudeClicked)];
    [self.headerView.attributeCount addGestureRecognizer:attitude];
    // 粉丝
    UITapGestureRecognizer *fans = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fansClicked)];
    [self.headerView.fansCount addGestureRecognizer:fans];
    // 发帖
    UITapGestureRecognizer *sendPost = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendPostClicked)];
    [self.headerView.sendPostCount addGestureRecognizer:sendPost];
    
//    // 心动币
//    UITapGestureRecognizer *coinTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(coinViewClicked)];
//    [self.headerView.coinView addGestureRecognizer:coinTap];
//    // 魅力值
//    UITapGestureRecognizer *charmViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(charmViewClicked)];
//    [self.headerView.charmView addGestureRecognizer:charmViewTap];
//    // 会员等级
//    UITapGestureRecognizer *vipLevelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(vipLevelViewClicked)];
//    [self.headerView.vipLevelView addGestureRecognizer:vipLevelTap];
//    // 约会记录
//    UITapGestureRecognizer *seekRecordTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(seekRecordViewClicked)];
//    [self.headerView.seekRecordView addGestureRecognizer:seekRecordTap];
}

#pragma mark - 头部点击
- (void)headerClicked {
    XDEditdataController *updateVC = [[XDEditdataController alloc]init];
    updateVC.title = kEditDataTitle;
    [self.navigationController pushViewController:updateVC animated:YES];
}

// 关注
- (void)attitudeClicked {
    MyAttitudeViewController *attitudeVC = [[MyAttitudeViewController alloc]init];
    [self.navigationController pushViewController:attitudeVC animated:YES];
}
// 粉丝点击
- (void)fansClicked {
    MyFansViewController *attitudeVC = [[MyFansViewController alloc]init];
    [self.navigationController pushViewController:attitudeVC animated:YES];
}

// 发帖
- (void)sendPostClicked {
    MySendPostViewController *attitudeVC = [[MySendPostViewController alloc]init];
    attitudeVC.user_id = self.user.user_id;
    [self.navigationController pushViewController:attitudeVC animated:YES];
}

/**
 *  初始化模型数据
 */
- (void)setupGroups{

    [self setupGroup0];

    [self setupGroup1];
}

- (void)setupGroup0 {
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    // 2.设置组的所有行数据
    HMCommonArrowItem *video = [HMCommonArrowItem itemWithTitle:@"视频认证" icon:@"my_icon_video_h"];
    HMCommonArrowItem *vip = [HMCommonArrowItem itemWithTitle:@"会员" icon:@"my_icon_vip_h"];
    vip.destVcClass = [XDMembersCenterController class];
    
    HMCommonArrowItem *wallet = [HMCommonArrowItem itemWithTitle:@"钱包" icon:@"my_icon_wallet_h"];
//    wallet.destVcClass = [MyJCBViewController class];
//    wallet.destVcClass = [MyWalletViewController class];
//    HMCommonArrowItem *charm = [HMCommonArrowItem itemWithTitle:@"礼物明细" icon:@"liwumingxi-1"];
//      HMCommonArrowItem *charm = [HMCommonArrowItem itemWithTitle:@"魅力值" icon:@"mine_center_charmValue"];
//    XD_WeakSelf
//    charm.operation = ^{
//        XD_StrongSelf
//        GiftsDetailViewController *svc = [[GiftsDetailViewController alloc]init];
//        [self.navigationController pushViewController:svc animated:YES];
        
//        XDCharmViewController *charmVC = [[XDCharmViewController alloc]init];
//        charmVC.glamorous = self.user.glamorous;
//        [self.navigationController pushViewController:charmVC animated:YES];
//    };
     
//    HMCommonArrowItem *record = [HMCommonArrowItem itemWithTitle:@"约会记录" icon:@"jilu"];
//    record.operation = ^{
//        XD_StrongSelf
//        ManDateHistoryViewController *vc = [[ManDateHistoryViewController alloc]init];
//        [self.navigationController pushViewController:vc animated:YES];
//    };
    
    group.items = @[video,vip, wallet];
}

- (void)setupGroup1
{
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    // 2.设置组的所有行数据
    HMCommonArrowItem *setting = [HMCommonArrowItem itemWithTitle:@"设置" icon:@"my_icon_set_h"];
    setting.destVcClass = [XDMineSettingController class];

 NSString *shortVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    HMCommonLabelCustomItem *about = [HMCommonLabelCustomItem itemWithTitle:@"关于" icon:@"my_icon_about-h"];
    about.text = shortVersion;
    XD_WeakSelf
    about.operation = ^{
        XD_StrongSelf
        NSString *url = [NSString stringWithFormat:@"http://13loveme.com/apphtml/suggestion/about?version=%@", shortVersion];
        XDLocalHtmlViewController *htmlVC = [XDLocalHtmlViewController localHtmlViewControllerWithHtmlTitle:nil HtmlString:url];
        [self.navigationController pushViewController:htmlVC animated:YES];
    };
    
     //客服
        HMCommonArrowItem *kefu = [HMCommonArrowItem itemWithTitle:@"客服" icon:@"my_icon_video_service-h"];
        kefu.operation = ^{
//            XD_StrongSelf
//            NSDictionary *dict = @{@"来源" : @"个人中心"};
//            [MobClick event:@"service_source" attributes:dict];
//            ChatViewController *chatVC = [[ChatViewController alloc] initWithConversationChatter:kServiceName conversationType:eConversationTypeChat];
//            chatVC.title = kServiceNiceName;
//            [self.navigationController pushViewController:chatVC animated:YES];
        };
    
//    HMCommonArrowItem *suggest = [HMCommonArrowItem itemWithTitle:@"意见与建议" icon:@"combinedShape"];
//    suggest.operation = ^{
//        XD_StrongSelf
//        NSString *url = [NSString stringWithFormat:@"http://13loveme.com/apphtml/suggestion?id=%@",User_ID];
//        XDLocalHtmlViewController *htmlVC = [XDLocalHtmlViewController localHtmlViewControllerWithHtmlTitle:nil HtmlString:url];
//        [self.navigationController pushViewController:htmlVC animated:YES];
//    };
    
    group.items = @[setting,about,kefu];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

#pragma mark - 头像点击
- (void)headIconClicked {
    if (!isNetworking) {
        [MBProgressHUD showError:@"网络连接失败,请确认连接网络后在重试" toView:nil];
        return;
    }
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"修改头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    [sheet showInView:self.view];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 取出选中的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    TOCropViewController *cropViewController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleCircular image:image];
    cropViewController.delegate = self;
    [picker pushViewController:cropViewController animated:YES];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }];
}

#pragma mark - 四大块
- (void)coinViewClicked {
    
//    MyJCBViewController *coinVC = [[MyJCBViewController alloc] init];
//    [self.navigationController pushViewController:coinVC animated:YES];
}

//- (void)charmViewClicked {
//    XDCharmViewController *charmVC = [[XDCharmViewController alloc]init];
//    charmVC.glamorous = self.user.glamorous;
//    [self.navigationController pushViewController:charmVC animated:YES];
//}

- (void)vipLevelViewClicked {    
    XDMembersCenterController *memberVC = [[XDMembersCenterController alloc] init];
    [self.navigationController pushViewController:memberVC animated:YES];
    
//    XDGetCouponView *likeView = [[XDGetCouponView alloc] init];
//    likeView.couponButtonClicked = ^(UIButton *btn) {
//        XDCardPackageController *packageVC = [[XDCardPackageController alloc] init];
//        
//        [self.navigationController pushViewController:packageVC animated:YES];
//    };
//    [likeView show:YES];
}

-(void)autheViewTapClicked{
    [self.view makeToast:@"该功能尚未开放，敬请期待!"
                duration:2.0
                position:CSToastPositionCenter];
    
//    [self girlIsAllCerts];
}

- (void)girlIsAllCerts {
    
    // 公钥加密
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    [FKL_DataService requestURL:[NSString url_getGirlIsAllCerts] parameters:nil headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"GET" format:@"JSON" complete:^(id result) {
        [self.tableView.mj_header endRefreshing];
        if ([result[@"code"] integerValue] == 200) {
            
            
            XDAnthoritationModel *video = [[XDAnthoritationModel alloc] init];
            video.title = @"视频认证";
            //            video.des = [NSString stringWithFormat:@"视频认证用户每日登录可获得80%@",coin_name];
            video.imgName = @"video_ authentication";
            video.backImgNaem = @"video_backgroud";
            
            video.is_auth = [result[@"data"][@"video_auth"][@"is_auth"] integerValue];
            video.content = result[@"data"][@"video_auth"][@"content"];
            
            //            XDAnthoritationModel *weichat = [[XDAnthoritationModel alloc] init];
            //            weichat.title = @"微信认证";
            ////            weichat.des = [NSString stringWithFormat:@"微信认证用户每日登录可获得200%@",coin_name];
            //            weichat.imgName = @"wechat_ authentication";
            //            weichat.backImgNaem = @"wechat_backgroud";
            //
            //            weichat.is_auth = [result[@"data"][@"wx_auth"][@"is_auth"] integerValue];
            //            weichat.customer_qrc = result[@"data"][@"wx_auth"][@"customer_qrc"];
            
            
            // 更新用户的is_renzheng
            
            if (video.is_auth == 3) {
                [self.view makeToast:@"已经认证通过了！" duration:2 position:CSToastPositionCenter];
            } else if (video.is_auth == 1) {
                [self.view makeToast:@"正在审核中！" duration:2 position:CSToastPositionCenter];
            } else {
//                PersonalAuthenticationViewController *vc = [[PersonalAuthenticationViewController alloc]init];
//                vc.strNotice =  video.content;
//                [self.navigationController pushViewController:vc animated:YES];
            }
            
            if (video.is_auth == 3 ) {//|| weichat.is_auth == 3
                ProfileUser *user = [XDAccountTool account];
                user.is_renzheng = 1;
                [XDAccountTool save:user];
            }
            self.user = [XDAccountTool account];
            [self setupTableHeaderView];
            
        } else {
            [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
    }];
}

//- (void)seekRecordViewClicked {
//    ManDateHistoryViewController *vc = [[ManDateHistoryViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        if (buttonIndex != actionSheet.cancelButtonIndex) {
            if (buttonIndex == actionSheet.firstOtherButtonIndex) {
                [self openCamera];
            } else if (buttonIndex == actionSheet.firstOtherButtonIndex + 1) {
                [self openAlbum];
            }
        }
    }
}

- (void)openAlbum {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    
    isOpendCamera = NO;
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    // 接管控制状态栏的外观
    ipc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    ipc.navigationBar.translucent = NO;
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    ipc.allowsEditing = YES;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

- (void)openCamera {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;
    
    isOpendCamera = YES;
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark - TOCropViewController Delegate
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToCircularImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    
    [cropViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    
    [self hideHud];
    [self showHudInView:self.view hint:NSLocalizedString(@"setting.uploading", @"uploading...")];
    self.headerView.headIcon.image = image;
    __weak typeof(self) weakSelf = self;
    if (image) {
//        NSData *data = UIImageJPEGRepresentation(image, 0.000001);
        NSData *data = [image wxImageSize:image];
        NSString *imageStr = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
        NSMutableDictionary *paras = [NSMutableDictionary dictionary];
        paras[@"new_avatar"] = imageStr;
        // 公钥加密
        NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
        [FKL_DataService requestURL:[NSString url_changeAvatar] parameters:paras headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"POST" format:@"JSON" complete:^(id result) {
            [weakSelf hideHud];
            isOpendCamera = NO;
            if ([result[@"code"] integerValue] == 200) {
                // 头像昵称
                [weakSelf showHint:NSLocalizedString(@"setting.uploadSuccess", @"uploaded successfully")];
                [UserProfileManager saveInfo:self.user.username imgUrl:result[@"data"] nickName:self.user.nickname];
                weakSelf.user.avatar = result[@"data"];
                weakSelf.headerView.headIcon.image = image;
            } else {
                [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
            }
        } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
            [weakSelf hideHud];
            isOpendCamera = NO;
            [weakSelf showHint:NSLocalizedString(@"setting.uploadFail", @"uploaded failed")];
        }];
    } else {
        [self hideHud];
        [self showHint:NSLocalizedString(@"setting.uploadFail", @"uploaded failed")];
    }
}
- (void)cropViewController:(nonnull TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled {
    if (isOpendCamera) {
        [cropViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    } else {
        [cropViewController.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - 新手引导
- (void)newbieGuide {
    if (!myAppDelegate.newVersion) {
        return;
    }
    CYPromptCoverView *cover0 = [[CYPromptCoverView alloc] initWithRevalView:self.rightBtn layoutType:CYPromptCoverViewLayoutTypeLeftDown];
    cover0.insetX = 0;
    cover0.insetY = 0;
    cover0.des = @"编辑资料";
    cover0.detailDes = @"更多的资料和照片，\n才会让Ta对你产生兴趣";
    [cover0 showInView:self.tabBarController.view];
}

//-(void)headerViewClicked{
//    XDOtherViewController *personVC = [[XDOtherViewController alloc] init];
//    personVC.user_id = self.user.user_id;
//    personVC.username = self.user.nickname;
//    [self.navigationController pushViewController:personVC animated:YES];
//}
@end
