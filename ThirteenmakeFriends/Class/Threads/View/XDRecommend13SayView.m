//
//  XDRecommend13SayView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/10/24.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDRecommend13SayView.h"
#import "XD13SayItemCell.h"
#import "XDPostTopModel.h"
#import "XDTopicContainerController.h"
#import "XDPostsController.h"

@interface XDRecommend13SayView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/** collectionView */
@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation XDRecommend13SayView

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
    [self setupCollectionView];
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumLineSpacing = CGFLOAT_MIN;
    layout.minimumInteritemSpacing = CGFLOAT_MIN;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(136, 83);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self addSubview:self.collectionView];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    // 注册Item
    [self.collectionView registerClass:[XD13SayItemCell class] forCellWithReuseIdentifier:@"XD13SayItemCellID"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 5);
    
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.activitiesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XD13SayItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XD13SayItemCellID" forIndexPath:indexPath];
    cell.activityModel = self.activitiesArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XDAcitivityModel *actModel = [self.activitiesArray objectAtIndex:indexPath.row];
    if (actModel.isLasted) {
        XDTopicContainerController *top = [[XDTopicContainerController alloc] init];
        top.selectIndex = 0;
        [self.navigationController pushViewController:top animated:YES];
    } else {
        XDPostsController *topicVC = [[XDPostsController alloc] init];
        topicVC.topic = actModel.tag_name;
        topicVC.title = actModel.tag_name;
        [self.navigationController pushViewController:topicVC animated:YES];
    }
}

-(void)setActivitiesArray:(NSArray *)activitiesArray
{
    _activitiesArray = activitiesArray;
    [self.collectionView reloadData];
}

@end
