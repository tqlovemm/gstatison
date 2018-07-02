//
//  XDPersonPhotosController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/12/15.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "XDPersonPhotosController.h"
//#import "XDThreadPhotoCell.h"
#import "XDPhotoBrowser.h"

#define photoCell @"XDPersonPhotosCell"

@interface XDPersonPhotosController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation XDPersonPhotosController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人照片";
    
    [self setupCollectionViww];
    
    [self setupNavBar];
}

/**
 *  设置导航条内容
 */
- (void)setupNavBar
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -12;
    
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [saveButton setImage:[UIImage imageNamed:@"barbuttonicon_more"] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, saveItem];
    
}

- (void)save {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)setupCollectionViww {
    // 1.流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemWH = (SCREEN_WIDTH - 20) / 3.0;
    // 2.每个cell的尺寸
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    // 3.设置cell之间的水平间距
    layout.minimumInteritemSpacing = 0;
    // 4.设置cell之间的垂直间距
    layout.minimumLineSpacing = 5;
    // 5.设置四周的内边距
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_Height) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.view addSubview:self.collectionView];
    
//    [self.collectionView registerClass:[XDThreadPhotoCell class] forCellWithReuseIdentifier:photoCell];
}

#pragma mark - UICollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    XDThreadPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoCell forIndexPath:indexPath];
//
//    cell.photoUrl = self.photos[indexPath.row];
//
//    return cell;
//}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    XDThreadPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoCell forIndexPath:indexPath];
//    XDPhotoBrowser *photoBrowser = [XDPhotoBrowser defaultManager];
//    [photoBrowser showBrowserWithImages:self.photos andCurrentIndex:indexPath.row fromImageContainer:cell.imgView];
//}

@end
