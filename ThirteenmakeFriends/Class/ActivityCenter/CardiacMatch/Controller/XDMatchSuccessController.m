//
//  XDMatchSuccessController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/12/14.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDMatchSuccessController.h"
#import "XDMatchRecordController.h"
#import "XDMatchPersonController.h"
#import "XDEditdataController.h"
#import "XDIsMatchingController.h"
#import <RTRootNavigationController.h>

#import "XDMatchProcessView.h"
#import "XDMatchSuccessView.h"
#import "XDMatchCell.h"
#import "XDMatchUserModel.h"

@interface XDMatchSuccessController ()<XDMatchSuccessViewDelegate,UIAlertViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, weak) UIScrollView *contentview;

@property (weak, nonatomic) UICollectionView *collectionView;

@end

@implementation XDMatchSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"匹配成功";
    
    [self setupNavbar];
    [self xdd_setupSubViews];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:XDMatchResultSuccessNotification object:self.user];
}

- (void)xdd_setupSubViews {
    UIScrollView *contentview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_Height)];
    [self.view addSubview:contentview];
    self.contentview = contentview;
    
    XDMatchSuccessView *matchView = [[XDMatchSuccessView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 382)];
    XD_WeakSelf
    matchView.headIconClicked = ^(NSString *user_id) {
        XD_StrongSelf
        [self getUserInfoWithUser_id:user_id];
    };
    matchView.delegate = self;
    matchView.user = self.user;
    [self.contentview addSubview:matchView];
    
    XDMatchProcessView *processView = [[XDMatchProcessView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(matchView.frame), self.view.width, 20)];
    [self.contentview addSubview:processView];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = CGFLOAT_MIN;
    flowLayout.minimumInteritemSpacing = CGFLOAT_MIN;
    flowLayout.itemSize = CGSizeMake(174, 191);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(processView.frame), self.view.frame.size.width, 191) collectionViewLayout:flowLayout];
    [self.contentview addSubview:collectionView];
    self.collectionView = collectionView;
    self.collectionView.delegate             = self;
    self.collectionView.dataSource           = self;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[XDMatchCell class] forCellWithReuseIdentifier:@"XDMatchCellID"];
    
    self.contentview.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(self.collectionView.frame));
}

- (void)chatButtonClicked:(UIButton *)btn {
    
    NSString *user_id = [NSString stringWithFormat:@"%ld",self.user.user_id];
    [self getUserInfoWithUser_id:user_id];
}

- (void)continueButtonClicked:(UIButton *)btn {
    // 重新匹配
    [self checkMatchInfo_isFull];
}

- (void)getUserInfoWithUser_id:(NSString *)user_id {
    XDMatchPersonController *personVC = [[XDMatchPersonController alloc] init];
    personVC.user_id = user_id;
    [self.navigationController pushViewController:personVC animated:YES];
}

#pragma mark - 导航栏
- (void)setupNavbar {
    
    //左边按钮
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [leftBtn setImage:[UIImage imageNamed:@"gray_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -6;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftItem];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightBtn setTitle:@"记录" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitleColor:NormalNavBtnColor forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightItem];
    
}

- (void)leftButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonClicked {
    XDMatchRecordController *recordVC = [[XDMatchRecordController alloc] init];
    [self.navigationController pushViewController:recordVC animated:YES];
}

#pragma mark - layout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XDMatchCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"XDMatchCellID" forIndexPath:indexPath];
    cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"match_step%ld",indexPath.row + 1]];
    return cell;
}

#pragma mark - 匹配报名接口
- (void)match_Registion {
    [self showHudInView:self.view hint:@"匹配报名中..."];
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    [FKL_DataService requestURL:[NSString url_match_Registration] parameters:nil headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"GET" format:@"JSON" complete:^(id result) {
        [self hideHud];
        if ([result[@"code"] integerValue] == 200 || [result[@"code"] integerValue] == 201) {
            XDIsMatchingController *vc = [[XDIsMatchingController alloc] init];
            NSMutableArray<UIViewController *> *childViewControllers = [self.rt_navigationController.rt_viewControllers mutableCopy];
            [childViewControllers replaceObjectAtIndex:childViewControllers.count - 1 withObject:vc];
            if (childViewControllers.count > 1) {
                vc.hidesBottomBarWhenPushed = YES;
            }
            [self.navigationController setViewControllers:childViewControllers animated:NO];
        } else {
            [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
    }];
}

#pragma mark - 查询匹配信息是否完善
- (void)checkMatchInfo_isFull {
    [self showHudInView:self.view hint:@"匹配报名中..."];
    NSString *encryWithPublicKeyStr = [RSAUtil encryptString:[NSString stringWithFormat:@"%@",User_ID] publicKey:kRSA_Public_key];
    [FKL_DataService requestURL:[NSString url_judge_matchInfo_isComplete] parameters:nil headerKey:@"sign" headerValue:encryWithPublicKeyStr withType:@"GET" format:@"JSON" complete:^(id result) {
        [self hideHud];
        if ([result[@"code"] integerValue] == 200) {
            [self match_Registion];
        } else {
            [self alertWithMessage:result[@"message"]];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
    }];
}

#pragma mark - UIActionSheetDelegate
- (void)alertWithMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView cancelButtonIndex] != buttonIndex) {
        XDEditdataController *editVC = [[XDEditdataController alloc] init];
        [self.navigationController pushViewController:editVC animated:YES];
    }
}


@end
