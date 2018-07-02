//
//  XDLabelSelectController.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/12/14.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "XDLabelSelectController.h"
#import "XDEditLabelSelectCell.h"
#import "UICollectionViewLeftAlignedLayout.h"

NSString *const EditTitleKey = @"EditTitleKey";
NSString *const EditIDKey = @"EditIDKey";

@interface XDLabelSelectController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionViewLeftAlignedLayout *layout;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *unUsingArray;
@property (assign, nonatomic) BOOL needUpdate;

@end

@implementation XDLabelSelectController

- (instancetype)initWithColumnArray:(NSMutableArray *)array allCloumn:(NSArray *)allArray {
    if (self = [self init]) {
        _usingArray = [NSMutableArray arrayWithArray:array];
        _allArray = [allArray copy];
        
        [self reloadData];
    }
    return self;
}
- (void)createUnUsing {
    self.unUsingArray = [NSMutableArray array];
    //    NSArray *usingKey = [self.usingArray valueForKey:EditIDKey];
    //    NSArray *allKey = [self.allArray valueForKey:EditIDKey];
    //
    //    for (NSString *string in allKey) {
    //        if (![usingKey containsObject:string]) {
    //            NSUInteger index = [allKey indexOfObject:string];
    //            [self.unUsingArray addObject:[self.allArray objectAtIndex:index]];
    //        }
    //    }
    
    for (NSString *string in self.allArray) {
        if (![self.usingArray containsObject:string]) {
            [self.unUsingArray addObject:string];
        }
    }
}

- (void)reloadData {
    [self createUnUsing];
    [self.collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.title = @"标签选择";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavBar];
    [self configViews];
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
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:NormalNavBtnColor forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    //    [self.navigationItem setRightBarButtonItem:saveItem];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, saveItem];
    
}

- (void)configViews {
    self.layout = [[UICollectionViewLeftAlignedLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:self.layout];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    self.collectionView.delegate             = self;
    self.collectionView.dataSource           = self;
    self.collectionView.contentSize          = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[XDEditLabelSelectCell class] forCellWithReuseIdentifier:editCollectionCellID];
    [self.collectionView registerClass:[EditSelectedCollectionViewCell class] forCellWithReuseIdentifier:editCollectionSelectCell];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
}


#pragma mark - Action
- (void)doneAction:(UIButton *)sender {
    if (_needUpdate) {
        if ([self.delegate respondsToSelector:@selector(labelSelectDone:usingArray:)]) {
            [self.delegate labelSelectDone:self.title usingArray:[self.usingArray mutableCopy]];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - layout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count;
    if (section == 0) {
        count =  [self.usingArray count];
    } else {
        count = [self.unUsingArray count];
    }
    return count;
}

#pragma mark -
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && self.usingArray.count > 4) {
        [self.view makeToast:@"最多选择五个标签" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    
    if (indexPath.section == 0) {
        [collectionView performBatchUpdates:^{
            [self.unUsingArray addObject:[self.usingArray objectAtIndex:indexPath.item]];
            [collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:(self.unUsingArray.count -1) inSection:1]]];
            
            [self.usingArray removeObjectAtIndex:indexPath.item];
            [collectionView deleteItemsAtIndexPaths:@[indexPath]];
            
        } completion:^(BOOL finished) {
            _needUpdate = YES;
        }];
        
    } else {
        [collectionView performBatchUpdates:^{
            [self.usingArray addObject:[self.unUsingArray objectAtIndex:indexPath.item]];
            [collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:(self.usingArray.count - 1) inSection:0]]];
            
            [self.unUsingArray removeObjectAtIndex:indexPath.item];
            [collectionView deleteItemsAtIndexPaths:@[indexPath]];
        } completion:^(BOOL finished) {
            _needUpdate = YES;
        }];
    }
}

#pragma mark -
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets inset;
    if (section == 0) {
        inset = UIEdgeInsetsMake(10, 10, 10, 10);
    } else {
        inset = UIEdgeInsetsMake(0, 0, 10, 0);
    }
    inset = UIEdgeInsetsMake(10, 10, 10, 10);
    return inset;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    CGFloat spacing;
    if (section == 0) {
        spacing = 10;
    } else {
        spacing = 0;
    }
    spacing = 10;
    return spacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    CGFloat spacing;
    if (section == 0) {
        spacing = 10;
    } else {
        spacing = 0;
    }
    spacing = 10;
    return spacing;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size;
    if (indexPath.section == 0) {
        size = CGSizeMake(70, 30);
    } else {
        size = CGSizeMake(SCREEN_WIDTH, 38);
    }
    //    size = CGSizeMake(70, 30);
    
    NSString *str = nil;
    if (indexPath.section == 0) {
//        str = self.usingArray[indexPath.item][EditTitleKey];
        str = self.usingArray[indexPath.item];
    } else {
//        str = self.unUsingArray[indexPath.item][EditTitleKey];
        str = self.unUsingArray[indexPath.item];
    }
    size = CGSizeMake([self getWidthWithStr:str] + 20, 30);
    return size;
}

- (CGFloat)getWidthWithStr:(NSString *)text
{
    CGFloat width = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 40) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil].size.width;
    return width;
}
#pragma mmark -
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XDEditLabelSelectCell *cell;
    if (indexPath.section == 0) {
        cell  = [collectionView dequeueReusableCellWithReuseIdentifier:editCollectionCellID forIndexPath:indexPath];
//        cell.titleLabel.text = self.usingArray[indexPath.item][EditTitleKey];
        cell.titleLabel.text = self.usingArray[indexPath.item];
        cell.titleLabel.textColor = RGB(119, 119, 119);
        cell.layer.borderColor = RGB(240, 239, 245).CGColor;
        cell.titleLabel.backgroundColor = RGB(240, 239, 245);
        
    } else if (indexPath.section == 1){
        cell  = [collectionView dequeueReusableCellWithReuseIdentifier:editCollectionCellID forIndexPath:indexPath];
//        cell.titleLabel.text = self.unUsingArray[indexPath.item][EditTitleKey];
        cell.titleLabel.text = self.unUsingArray[indexPath.item];
        cell.titleLabel.textColor = RGB(119, 119, 119);
        cell.layer.borderColor = RGB(240, 239, 245).CGColor;
        cell.titleLabel.backgroundColor = RGB(240, 239, 245);
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGFloat height;
    if (section == 0 ) {
        height = 35;
    } else {
        height = 45;
    }
    return CGSizeMake(collectionView.frame.size.width, height);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath ];
        view.backgroundColor = [UIColor whiteColor];
        for (UIView *subView in view.subviews) {
            [subView removeFromSuperview];
        }
        if (indexPath.section == 0) {
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = HEXCOLOR(0xececec);
            [view addSubview:line];
            line.frame = CGRectMake(0, view.frame.size.height-1, view.frame.size.width, 0.5);
            
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.text = @"已选标签";
            titleLabel.font = [UIFont systemFontOfSize:16];
            titleLabel.textColor = HEXCOLOR(0x333333);
            [view addSubview:titleLabel];
            UILabel *mesage = [[UILabel alloc] init];
            mesage.text = @"点击删除";
            mesage.font = [UIFont systemFontOfSize:12];
            mesage.textColor = HEXCOLOR(0x888888);
            
            [view addSubview:titleLabel];
            [view addSubview:mesage];
            titleLabel.frame = CGRectMake(10, 0, [titleLabel sizeThatFits:CGSizeMake(300, 20)].width, view.frame.size.height);
            mesage.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame) + 10, 0, [mesage sizeThatFits:CGSizeMake(300, 20)].width, view.frame.size.height);
        } else {
            // indexPath.section == 1
            UIView *seperateView = [[UIView alloc] init];
            seperateView.backgroundColor = HEXCOLOR(0xf5f5f5);
            [view addSubview:seperateView];
            seperateView.frame = CGRectMake(0, 0, view.frame.size.width, 10);
            
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = HEXCOLOR(0xececec);
            [view addSubview:line];
            line.frame = CGRectMake(0, view.frame.size.height-1, view.frame.size.width, 0.5);
            
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.text = @"可添加的标签";
            titleLabel.font = [UIFont systemFontOfSize:16];
            titleLabel.textColor = HEXCOLOR(0x333333);
            [view addSubview:titleLabel];
            UILabel *mesage = [[UILabel alloc] init];
            
            mesage.text = @"点击添加更多标签";
            mesage.font = [UIFont systemFontOfSize:13];
            mesage.textColor = [UIColor colorWithWhite:0.5 alpha:1];
            [view addSubview:mesage];
            titleLabel.frame = CGRectMake(10, CGRectGetMaxY(seperateView.frame), [titleLabel sizeThatFits:CGSizeMake(300, 20)].width, view.frame.size.height - CGRectGetHeight(seperateView.frame));
            mesage.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame) + 10, titleLabel.frame.origin.y, [mesage sizeThatFits:CGSizeMake(300, 20)].width, titleLabel.frame.size.height);
        }
        return view;
    }
    return nil;
}

@end
