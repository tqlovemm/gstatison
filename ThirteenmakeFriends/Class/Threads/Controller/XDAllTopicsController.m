//
//  XDAllTopicsController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/10/27.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDAllTopicsController.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "PostTagCollectionViewCell.h"
#import "XDPostTopModel.h"
#import "XDPostsController.h"

#define CollectionPaddingRight 88 //图片选择器距右边距离
#define CollectionCellPadding  16 //section 1 内的collection 上下左右间距都为16
#define ItemSpacing            0 //item间距
#define LineSpacing            10 //行间距

@interface XDAllTopicsController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation XDAllTopicsController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = DefaultColor_BG_gray;
    
    [self setupCollectionView];
    
    [self xdd_setupRefreshControl];
}

/**
 *  集成刷新控件
 */
- (void)xdd_setupRefreshControl {
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.collectionView.mj_header = [XDRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf reloadNewData];
    }];
    
    // 马上进入刷新状态
    [self.collectionView.mj_header beginRefreshing];
    
}

#pragma mark - 获取觅约数据
/**
 *  加载新数据
 */
- (void)reloadNewData {
    
    [self getAllTags];
}


- (void)setupCollectionView {
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[[UICollectionViewLeftAlignedLayout alloc] init]];
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate             = self;
    self.collectionView.dataSource           = self;
    self.collectionView.contentSize          = CGSizeMake(SCREEN_WIDTH, self.view.frame.size.height);
    self.collectionView.backgroundColor      = [UIColor whiteColor];
    
    [self.collectionView registerClass:[PostTagCollectionViewCell class] forCellWithReuseIdentifier:@"ALLTagCollectionViewCell"];
    
    XD_WeakSelf
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        XD_StrongSelf
        make.left.right.top.bottom.mas_equalTo(self.view);
    }];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
}

#pragma mark - network

/**
 获取所有标签
 */
-(void)getAllTags {
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"type"] = @"3"; // 所有标签
    [FKL_DataService requestURL:[NSString url_getdynamicrecommend] parameters:paras withType:@"GET" format:@"JSON" complete:^(id result) {
        [self.collectionView.mj_header endRefreshing];
        if ([result[@"code"] integerValue] == 200) {
            NSArray *dataArray = [XDAcitivityModel objectArrayWithKeyValuesArray:result[@"data"]];
            self.dataArray = [NSMutableArray arrayWithArray:dataArray];
            [self.collectionView reloadData];
        } else {
            [self.view makeToast:result[@"code"] duration:2.0 position:CSToastPositionCenter];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
    }];
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (self.dataArray.count == 0) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return UIEdgeInsetsMake(CollectionCellPadding, CollectionCellPadding, CollectionCellPadding, CollectionCellPadding);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifierTag    = @"ALLTagCollectionViewCell";
    PostTagCollectionViewCell *cell = (PostTagCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifierTag forIndexPath:indexPath];
    
    cell.lblCell.layer.cornerRadius  = 12;
    cell.lblCell.layer.borderWidth   = 0.5;
    cell.lblCell.layer.masksToBounds = YES;
    
    [cell.lblCell setTextColor:ThemeColor3];
    cell.lblCell.layer.borderColor = ThemeColor3.CGColor;
    
    XDAcitivityModel *topic = [self.dataArray objectAtIndex:indexPath.row];
    cell.lblCell.text = topic.tag_name;
    return cell;
}

//cell frame
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGSize labelSize = CGSizeMake([[NSString stringWithFormat:@"%@",[self.dataArray[indexPath.row] tag_name]] sizeWithFont:[UIFont systemFontOfSize:14.f]].width + 19, 25);
    return labelSize;
}

//行间距间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return LineSpacing;
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XDAcitivityModel *tagModel = self.dataArray[indexPath.row];
    XDPostsController *postVC = [[XDPostsController alloc] init];
    postVC.title = tagModel.tag_name;
    postVC.topic = tagModel.tag_name;
    [self.navigationController pushViewController:postVC animated:YES];
}

#pragma mark - UICollectionViewDataSource
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_WIDTH, 10);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    
    if (kind == UICollectionElementKindSectionHeader) {
        footerview.backgroundColor = DefaultColor_BG_gray;
    }
    return footerview;
}

@end
