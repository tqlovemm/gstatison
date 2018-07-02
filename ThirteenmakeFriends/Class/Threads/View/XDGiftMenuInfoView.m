//
//  XDGiftMenuInfoView.m
//  ThirteenmakeFriends
//
//  Created by 空谷凌虚 on 2018/5/9.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import "XDGiftMenuInfoView.h"

#import "XD13SayItemCell.h"
#import "XDPostTopModel.h"
#import "XDTopicContainerController.h"
#import "XDPostsController.h"

@interface XDGiftMenuInfoView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/** collectionView */
@property (strong, nonatomic) UICollectionView *collectionView;
@property (weak, nonatomic) UILabel *giftLab;
@end

@implementation XDGiftMenuInfoView

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
    UILabel *lab  = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 20)];
    NSString *str1 = @"她的礼物  ";
    NSString *titleStr = [NSString stringWithFormat:@"%@%d",str1,209];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:titleStr];
    NSRange range = [str1 rangeOfString:titleStr];
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           RGB(97, 60, 187), NSForegroundColorAttributeName, nil];
    [str setAttributes:attrs range:range];
    
    lab.textColor = [UIColor blackColor];
    lab.font = [UIFont systemFontOfSize:18.0f];
    lab.attributedText = str;
    
    self.giftLab = lab;
    [self addSubview:lab];
    
    [self setupCollectionView];
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumLineSpacing = CGFLOAT_MIN;
    layout.minimumInteritemSpacing = CGFLOAT_MIN;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(136, 83);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 30, self.width, self.height-30) collectionViewLayout:layout];
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
    return self.giftArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XD13SayItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XD13SayItemCellID" forIndexPath:indexPath];
    cell.activityModel = self.giftArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XDAcitivityModel *actModel = [self.giftArray objectAtIndex:indexPath.row];
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
    _giftArray = activitiesArray;
    [self.collectionView reloadData];
}

@end
