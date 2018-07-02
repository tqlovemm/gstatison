//
//  XDRecommendUserView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/10/24.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDRecommendUserView.h"
#import "HJCornerRadius.h"
#import "XDPostTopModel.h"
//#import "XDOtherViewController.h"
#import "XDRankListModel.h"

#import "XDRankNavViewController.h"
#import "XDWeekRankView.h"
#import <SDCycleScrollView.h>
#define userCount 3

@interface XDRecommendUserView ()<SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) UIImageView * tipView;
@property (weak, nonatomic) UILabel * tipLabel;
@property (weak, nonatomic) UILabel * tipLabel1;

@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<XDCustomRankListModel *> *dataArray;
@end

@implementation XDRecommendUserView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView *tipView = [[UIImageView alloc] init];
    tipView.image = [UIImage imageNamed:@"group5"];
    [self addSubview:tipView];
    self.tipView = tipView;
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.textColor = RGB(65, 65, 65);
    tipLabel.font = kPingFangBoldFont(14);
    [self addSubview:tipLabel];
    self.tipLabel = tipLabel;
    tipLabel.text = @"本周任性榜";
    
    
    UILabel *tipLabel1 = [[UILabel alloc] init];
    tipLabel1.textColor = RGB(65, 65, 65);
    tipLabel1.font = kPingFangLightFont(12);
    [self addSubview:tipLabel1];
    self.tipLabel1 = tipLabel1;
    tipLabel1.text = @"点击详情 >>";
    
    self.tipView.x = 12;
    self.tipView.size = CGSizeMake(26, 26);
    self.tipView.centerY = self.height / 2.0;
    
    self.tipLabel.x = CGRectGetMaxX(self.tipView.frame) + 5;
    self.tipLabel.size = [self.tipLabel.text sizeWithFont:self.tipLabel.font];
    self.tipLabel.centerY = self.tipView.centerY - 10;
    
    self.tipLabel1.x = CGRectGetMaxX(self.tipView.frame) + 5;
    self.tipLabel1.size = [self.tipLabel1.text sizeWithFont:self.tipLabel1.font];
    self.tipLabel1.centerY = self.tipView.centerY + 10;
    
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTap:)];
    [self addGestureRecognizer:tap];
    
    self.dataArray = [NSMutableArray array];
    [self setupCollectionView];
}



- (void)setUsersArray:(NSArray *)usersArray {
    _usersArray = usersArray;
    for (int i = 0; i<usersArray.count; i++) {
        XDRankListModel *rm =usersArray[i];
        XDCustomRankListModel *crm = [XDCustomRankListModel new];
        crm.rankModel = rm;
        crm.index = i;
        [self.dataArray addObject:crm];
    }
    [self.collectionView reloadData];
}

-(void)setRankType:(rankTypeRX_ML)rankType{
    _rankType = rankType;
    self.tipLabel.text = rankType==rankTypeRX?@"本周任性榜":@"本周魅力榜";
    self.tipView.image = rankType==rankTypeRX?[UIImage imageNamed:@"group5"]:[UIImage imageNamed:@"group5Copy"];
}

- (void)avatarTap:(UITapGestureRecognizer *)tap {
//    NSLog(@"点击了第%ld个",tap.view.tag);
//     XDRankListModel *rank = [_usersArray objectAtIndex:tap.view.tag];
    XDRankNavViewController *rankListVC = [XDRankNavViewController new];
    [self.navigationController pushViewController:rankListVC animated:YES];
}



- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumLineSpacing = CGFLOAT_MIN;
    layout.minimumInteritemSpacing = CGFLOAT_MIN;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(60, self.height);
    
    CGFloat coX = self.width/2.0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(coX, 0, self.width-coX-10, self.height) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self addSubview:self.collectionView];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    // 注册Item
    [self.collectionView registerClass:[XDWeekRankView class] forCellWithReuseIdentifier:@"XDWeekRankView"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 5);
    
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count>=3?userCount:self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XDWeekRankView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XDWeekRankView" forIndexPath:indexPath];
    cell.cRankListModel = self.dataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XDRankNavViewController *rankListVC = [XDRankNavViewController new];
    [self.navigationController pushViewController:rankListVC animated:YES];
}



@end
