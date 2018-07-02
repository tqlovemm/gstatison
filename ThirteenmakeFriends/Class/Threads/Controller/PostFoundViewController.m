//
//  PostFoundViewController.m
//  ThirteenmakeFriends
//
//  Created by iOS on 23/3/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "PostFoundViewController.h"
#import "PostMessageCollectionViewCell.h"
#import "PostImageCollectionViewCell.h"
#import "NoticeCollectionViewCell.h"
#import "TZImagePickerController.h"
#import "PostTagCollectionViewCell.h"
#import "TZImageManager.h"
//#import "XDPhotoBrowser.h"
#import "ICEPhotoBrowser.h"
#import "XDSendThreadLocationView.h"
#import "XDThreadLocationController.h"
#import "XDNavigationController.h"
#import "UIPlaceHolderTextView.h"
#import "XDTopicModel.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "XDThreadLocation.h"
#import "MBProgressHUD+MJ.h"

#import "UIImage+GIF.h"

#define CollectionPaddingRight 16 //图片选择器距右边距离
#define CollectionCellPadding  16 //section 1 内的collection 上下左右间距都为16
#define ItemSpacing            8 //item间距
#define LineSpacing            16 //行间距

@interface PostFoundViewController ()
<UIAlertViewDelegate,
 UICollectionViewDelegate,
 UICollectionViewDataSource,
 TZImagePickerControllerDelegate,
 XDThreadLocationControllerDelegate
>

@property (nonatomic, strong) TZImagePickerController *imagePickerVc;

@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, strong) NSMutableArray *assetsArray;
@property (nonatomic, assign) CGPoint   lastPressPoint;
@property (nonatomic, assign) NSInteger selectCell;
@property (nonatomic, assign) NSInteger heightForFooter;//section == 3 的footerheight

@property (strong, nonatomic) NSArray * topicArray;

@property (nonatomic, weak) XDSendThreadLocationView *locView;
/**
 *  是否正在切换键盘
 */
@property (nonatomic, assign, getter = isChangingKeyboard) BOOL changingKeyboard;

@end

@implementation PostFoundViewController

- (NSMutableArray *)imagesArray{
    if (!_imagesArray) {
        _imagesArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _imagesArray;
}

- (NSMutableArray *)assetsArray{
    if (!_assetsArray) {
        _assetsArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _assetsArray;
}

- (NSInteger)heightForFooter {
    if (!iPhoneX) {
        _heightForFooter = 44;
    }
    else{
        _heightForFooter = 0;
    }
//    if (self.imagesArray.count <= 3) {
//        _heightForFooter = 10;
//
//    }
//    else if (self.imagesArray.count >3 && self.imagesArray.count <=6) {
//        _heightForFooter = 0;
//    }
//    else if (self.imagesArray.count > 6) {
//        _heightForFooter = 0;
//    }
    return _heightForFooter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultData];
    [self createDefaultNav];
    [self setuplocationView];
    
    [self getAllTags];
    
    // 关闭键盘
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}


-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.view endEditing:YES];
}

- (void)loadDefaultData {
    self.view.backgroundColor = DefaultColor_BG_gray;
    self.title                = @"发现";
    _lastPressPoint           = CGPointZero;
    _selectCell               = -1;
    
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [backButton setTitle:@"取消" forState:UIControlStateNormal];
    [backButton setTitleColor:NormalNavBtnColor forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -12;
    
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,backItem];
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitle:@"发布" forState:UIControlStateNormal];
    [rightBtn setTitleColor:ThemeColor1 forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(didPressedToSend:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,rightItem];
}

- (void)createDefaultNav {
    _collectionView.collectionViewLayout = [[UICollectionViewLeftAlignedLayout alloc] init];
    _collectionView.delegate             = self;
    _collectionView.dataSource           = self;
    _collectionView.contentSize          = CGSizeMake(SCREEN_WIDTH, self.view.frame.size.height);
    _collectionView.backgroundColor      = [UIColor whiteColor];
    
    //文字框
    [_collectionView registerClass:[PostMessageCollectionViewCell class] forCellWithReuseIdentifier:@"PostMessageCollectionViewCell"];
    //图片框
    [_collectionView registerNib:[UINib nibWithNibName:@"PostImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PostImageCollectionViewCell"];
    //图片张数
    [_collectionView registerNib:[UINib nibWithNibName:@"NoticeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"NoticeCollectionViewCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"PostTagCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PostTagCollectionViewCell"];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
}

- (void)setuplocationView {
    XDSendThreadLocationView *locView = [[XDSendThreadLocationView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44 - NavigationBar_Height, SCREEN_WIDTH, 44)];
    [self.view addSubview:locView];
    
//    XDSendThreadLocationView *locView = [[XDSendThreadLocationView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44 - NavigationBar_Height, SCREEN_WIDTH, 44)];
//    [self.view addSubview:locView];
    self.locView = locView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locViewClicked:)];
    [locView addGestureRecognizer:tap];
    
    // 监听键盘
    // 键盘的frame(位置)即将改变, 就会发出UIKeyboardWillChangeFrameNotification
    // 键盘即将弹出, 就会发出UIKeyboardWillShowNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 键盘即将隐藏, 就会发出UIKeyboardWillHideNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - network 

/**
 获取所有标签
 */
-(void)getAllTags {
    
    [FKL_DataService requestURL:[NSString url_getThreadLabelInfo] parameters:nil withType:@"GET" format:@"JSON" complete:^(id result) {
        if ([result[@"code"] integerValue] == 200) {
            self.topicArray = [XDTopicModel objectArrayWithKeyValuesArray:result[@"data"]];
            
            [self.collectionView reloadData];
        } else {
            [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
    }];
    
    [self.collectionView reloadData];
}


#pragma mark - UICollectionViewDataSource
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0 || section == 2) return CGSizeMake(SCREEN_WIDTH, 20);
    else if (section == 3) return CGSizeMake(SCREEN_WIDTH, self.heightForFooter);
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
    
    if (kind == UICollectionElementKindSectionFooter) {
        footerview.backgroundColor = RGB(240, 239, 245);
    }
    return footerview;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
        {
            if      (self.imagesArray.count == 0) return 1;
            else if (self.imagesArray.count == 9) return 9;
            else    return self.imagesArray.count + 1;
        }
        case 2:
            return 1;
            break;
        case 3:
            return self.topicArray.count;
            break;
        default:
            return 1;
            break;
    }
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 1) {
        return UIEdgeInsetsMake(CollectionCellPadding, CollectionCellPadding, CollectionCellPadding, CollectionPaddingRight);
    }
    else if (section == 3) {
        if (self.topicArray.count == 0) {
            return UIEdgeInsetsMake(0, 0, 0, 0);
        }
        return UIEdgeInsetsMake(CollectionCellPadding, CollectionCellPadding, CollectionCellPadding, CollectionCellPadding);
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier       = @"PostMessageCollectionViewCell";
    static NSString *CellIdentifierImg    = @"PostImageCollectionViewCell";
    static NSString *CellIdentifierNotice = @"NoticeCollectionViewCell";
    static NSString *CellIdentifierTag    = @"PostTagCollectionViewCell";
    
    static BOOL isImgCellRegister     = NO;
    static BOOL isNoticeCellRegister  = NO;
    static BOOL isTagCellRegister     = NO;
    
    
    switch (indexPath.section) {
        case 0:
        {
            PostMessageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
            return cell;
        }
            break;
        case 1:
        {
            if (!isImgCellRegister) {
                UINib *nib     = [UINib nibWithNibName:@"PostImageCollectionViewCell" bundle:nil];
                isImgCellRegister = YES;
                [collectionView registerNib:nib forCellWithReuseIdentifier:CellIdentifierImg];
            }
            
            PostImageCollectionViewCell *cell = (PostImageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifierImg forIndexPath:indexPath];
            cell.backgroundColor = [UIColor whiteColor];
            cell.tag             = indexPath.row;
            
            cell.imgViewPic.layer.masksToBounds  = YES;
            cell.imgViewPic.layer.cornerRadius   = 5;
            
            WEAKSELF
            cell.cancleBlock = ^(){
                [weakSelf.imagesArray removeObjectAtIndex:indexPath.row];
                [weakSelf.assetsArray removeObjectAtIndex:indexPath.row];
                [weakSelf.collectionView reloadData];
            };
            
            //数据源为0 默认一个加号cell
            //数据源为9 无操作
            if (self.imagesArray.count == 0)
                [self changeCellStyle:cell withBool:YES AtIndexPath:indexPath];
            else if(self.imagesArray.count == 9)
                [self changeCellStyle:cell withBool:NO AtIndexPath:indexPath];
            else {
                //数据源为其他的时候
                //等于个数的时候显示加号
                //不等于的时候显示图片
                if (indexPath.row == self.imagesArray.count)
                    [self changeCellStyle:cell withBool:YES AtIndexPath:indexPath];
                else
                    [self changeCellStyle:cell withBool:NO AtIndexPath:indexPath];
            }
            
            if (indexPath.row != self.imagesArray.count) {
                UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesture:)];
                [cell addGestureRecognizer:longPress];
            }
            return cell;
        }
            break;
        case 2:
        {
            if (!isNoticeCellRegister) {
                UINib *nib           = [UINib nibWithNibName:@"NoticeCollectionViewCell" bundle:nil];
                isNoticeCellRegister = YES;
                [collectionView registerNib:nib forCellWithReuseIdentifier:CellIdentifierNotice];
            }
            NoticeCollectionViewCell *cell = (NoticeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifierNotice forIndexPath:indexPath];
            cell.lblNotice.text            = [NSString stringWithFormat:@"%lu/9张",(unsigned long)self.imagesArray.count];
            return cell;
        }
            break;
        case 3:
        {
            if (!isTagCellRegister) {
                UINib *nib        = [UINib nibWithNibName:@"PostTagCollectionViewCell" bundle:nil];
                isTagCellRegister = YES;
                [collectionView registerNib:nib forCellWithReuseIdentifier:CellIdentifierNotice];
            }
            PostTagCollectionViewCell *cell = (PostTagCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifierTag forIndexPath:indexPath];
            
            cell.lblCell.layer.cornerRadius  = 12;
            cell.lblCell.layer.borderWidth   = 0.5;
            cell.lblCell.layer.masksToBounds = YES;
            if (_selectCell == indexPath.row) {
                [cell.lblCell setTextColor:ThemeColor3];
                cell.lblCell.layer.borderColor = ThemeColor3.CGColor;
            }
            else {
                [cell.lblCell setTextColor:DefaultColor_App_Gray];
                cell.lblCell.layer.borderColor = DefaultColor_App_Gray.CGColor;
            }
            XDTopicModel *topic = [self.topicArray objectAtIndex:indexPath.row];
            cell.lblCell.text = topic.tag_name;
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}

//cell frame
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return CGSizeMake(SCREEN_WIDTH, 90);
    } else if (indexPath.section == 1) {
        return CGSizeMake(
                          (SCREEN_WIDTH - CollectionCellPadding *2 - 2 * ItemSpacing)/3 ,
                          (SCREEN_WIDTH - CollectionCellPadding *2 - 2 * ItemSpacing)/3
                          );
    } else if (indexPath.section == 2) {
        return CGSizeMake(SCREEN_WIDTH, 20);
    } else if (indexPath.section == 3) {
//        return CGSizeMake(100, 30);
        CGSize labelSize = CGSizeMake([[NSString stringWithFormat:@"%@",[self.topicArray[indexPath.row] tag_name]] sizeWithFont:[UIFont systemFontOfSize:14.f]].width + 19, 25);
        return labelSize;
    } else {
        return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    }
}

//行间距间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return LineSpacing;
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//    return ItemSpacing;
    if (section == 3) {
        return 10;
    } else {
        return ItemSpacing;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == self.imagesArray.count && self.imagesArray.count != 9) {
            //点击加号
            _imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
            if (self.imagesArray.count != 0) {
                _imagePickerVc.selectedAssets = self.assetsArray;
            }
            _imagePickerVc.maxImagesCount            = 9;
            _imagePickerVc.allowPickingVideo         = NO;
            _imagePickerVc.allowTakePicture          = NO;
            _imagePickerVc.doneBtnTitleStr           = @"确定";
            _imagePickerVc.allowPickingImage         = YES;
            _imagePickerVc.allowPickingOriginalPhoto = NO;
            _imagePickerVc.isSelectOriginalPhoto     = YES;
            _imagePickerVc.autoDismiss               = NO;
            WEAKSELF
            [_imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                [weakSelf.imagesArray removeAllObjects];
                [weakSelf.assetsArray removeAllObjects];
                [weakSelf.assetsArray addObjectsFromArray:assets];
                [weakSelf.imagesArray addObjectsFromArray:photos];
                
                [weakSelf.collectionView reloadData];
                [weakSelf.imagePickerVc dismissViewControllerAnimated:YES completion:nil];
       
            }];
            [_imagePickerVc setImagePickerControllerDidCancelHandle:^{
                [weakSelf.imagePickerVc dismissViewControllerAnimated:YES completion:nil];
            }];
            [self presentViewController:_imagePickerVc animated:YES completion:nil];
        }
        else {
            NSMutableArray *photos = [[NSMutableArray alloc]init];
            for (int i = 0; i < self.assetsArray.count; i++) {
                [self judgeGifImage:self.assetsArray[i] completion:^(BOOL isGIF, NSData *data) {
                    if (isGIF) {
                        [photos addObject:[UIImage sd_animatedGIFWithData:data]];
                    }
                    else {
                        [photos addObject:self.imagesArray[i]];
                    }
                    if (photos.count == self.assetsArray.count) {
                        ICEPhotoBrowser *photoBrowser = [ICEPhotoBrowser defaultManager];
                        photoBrowser.superVC          = self;
                        [photoBrowser showBrowserWithImages:photos andCurrentIndex:indexPath.row];
                    }
                }];
            }
        }
    }
    else if (indexPath.section == 3) {
        _selectCell = indexPath.row;
        [self.collectionView reloadData];
    }
}



//========================================
#pragma mark item拖动 iOS9之前，需要截图等操作
static UIView      *snapedView;              //截图快照
static NSIndexPath *currentIndexPath;   //当前路径
static NSIndexPath *oldIndexPath;       //旧路径

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath willMoveToIndexPath:(NSIndexPath *)destinationIndexPath
{
    
    id objc = [self.imagesArray objectAtIndex:sourceIndexPath.item];
    //从资源数组中移除该数据
    [self.imagesArray removeObject:objc];
    //将数据插入到资源数组中的目标位置上
    [self.imagesArray insertObject:objc atIndex:destinationIndexPath.item];
    
    id objc2 = [self.assetsArray objectAtIndex:sourceIndexPath.item];
    //从资源数组中移除该数据
    [self.assetsArray removeObject:objc2];
    //将数据插入到资源数组中的目标位置上
    [self.assetsArray insertObject:objc2 atIndex:destinationIndexPath.item];
    
}

- (void)action:(UILongPressGestureRecognizer *)longGesture{
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:{//手势开始
            //判断手势落点位置是否在Item上
            oldIndexPath = [self.collectionView indexPathForItemAtPoint:[longGesture locationInView:self.collectionView]];
            if (oldIndexPath == nil) break;
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:oldIndexPath];
            //使用系统截图功能，得到cell的截图视图
            snapedView                 = [cell snapshotViewAfterScreenUpdates:NO];
            snapedView.frame           = cell.frame;
            [self.collectionView addSubview:snapedView];
            
            //截图后隐藏当前cell
            cell.hidden = YES;
            CGPoint currentPoint = [longGesture locationInView:self.collectionView];
            [UIView animateWithDuration:0.25 animations:^{
                snapedView.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
                snapedView.center    = CGPointMake(currentPoint.x, currentPoint.y);
            }];
        }
            break;
        case UIGestureRecognizerStateChanged: {//手势改变
            //当前手指位置 - 截图视图位置移动
            CGPoint currentPoint = [longGesture locationInView:self.collectionView];
            snapedView.center    = CGPointMake(currentPoint.x, currentPoint.y);
            
            //计算截图视图和哪个cell相交
            for (UICollectionViewCell *cell in [self.collectionView visibleCells]) {
                if ([self.collectionView indexPathForCell:cell].row == self.imagesArray.count )
                    continue;
                
                //当前隐藏的cell就不需要交换了，直接continue
                if ([self.collectionView indexPathForCell:cell] == oldIndexPath)
                    continue;
                
                //计算中心距
                CGFloat space = sqrtf(pow(snapedView.center.x - cell.center.x, 2) + powf(snapedView.center.y - cell.center.y, 2));
                //如果相交一半就移动
                if (space <= snapedView.bounds.size.width / 2) {
                    currentIndexPath = [self.collectionView indexPathForCell:cell];
                    //移动 会调用willMoveToIndexPath方法更新数据源
                    [self.collectionView moveItemAtIndexPath:oldIndexPath toIndexPath:currentIndexPath];
                    
                    [self collectionView:self.collectionView itemAtIndexPath:oldIndexPath willMoveToIndexPath:currentIndexPath];
                    //设置移动后的起始indexPath
                    oldIndexPath     = currentIndexPath;
                    break;
                }
            }
        }
            break;
        default:
        {
            //手势结束和其他状态
            UICollectionViewCell *cell                 = [self.collectionView cellForItemAtIndexPath:oldIndexPath];
            //结束动画过程中停止交互，防止出问题
            self.collectionView.userInteractionEnabled = NO;
            //给截图视图一个动画移动到隐藏cell的新位置
            [UIView animateWithDuration:0.25 animations:^{
                snapedView.center    = cell.center;
                snapedView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            } completion:^(BOOL finished) {
                //移除截图视图、显示隐藏的cell并开启交互
                [snapedView removeFromSuperview];
                cell.hidden                                = NO;
                self.collectionView.userInteractionEnabled = YES;
            }];
        }
            break;
    }
}

/**
 collectionview拖动事件

 @param sender sender
 */
- (void)longPressGesture:(UILongPressGestureRecognizer *)sender{
    [self action:sender];
}

/**
 改变cell的样式
 
 @param sender cell
 @param boolVaule bool
 @param indexPath indexpath
 */
- (void)changeCellStyle:(PostImageCollectionViewCell *)sender withBool:(BOOL)boolVaule AtIndexPath:(NSIndexPath *)indexPath{
    if (boolVaule) {
        [sender.imgViewPic setImage:[UIImage imageNamed:@"found_add"]];
    }
    else {
        [sender.imgViewPic setImage:nil];
        [sender.imgViewPic setImage:self.imagesArray[indexPath.row]];
        
        [self judgeGifImage:self.assetsArray[indexPath.row] completion:^(BOOL isGIF, NSData *data) {
            if (isGIF) {
                [sender.imgViewPic setImage:[UIImage sd_animatedGIFWithData:data]];
            }
            else {
                [sender.imgViewPic setImage:self.imagesArray[indexPath.row]];
            }
        }];
    }
    sender.btnCancle.hidden = boolVaule;
    sender.imgCancle.hidden = boolVaule;
}


/**
 判断图片是否是gif

 @param assets assets
 @param gifCompletion 判断的block
 */
- (void)judgeGifImage:(id)assets completion:(void (^)(BOOL isGIF,NSData *data))gifCompletion {
    PHAsset *asset = assets;
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = (PHAsset *)asset;
        if (phAsset.mediaType == PHAssetMediaTypeImage) {
            // Gif
            if ([[phAsset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
                [[TZImageManager manager] getOriginalPhotoDataWithAsset:assets completion:^(NSData *data, NSDictionary *info, BOOL isDegraded) {
                    if (!isDegraded) {
                        gifCompletion(YES,data);
                    }
                    else {
                        gifCompletion(NO,data);
                    }
                }];
            }
            else {
                gifCompletion(NO,nil);
            }
        }
    }
}

#pragma mark - 导航栏
- (void)back:(UIButton *)backBtn {
    
    PostMessageCollectionViewCell *cell = (PostMessageCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    UITextView *textView = cell.text.txtView;
    
//    if ([textView isFirstResponder] && (textView.text.length > 0 || self.imagesArray.count > 0)) {
//        // 防止键盘关闭期间返回按钮可以一直点击
//        backBtn.enabled = NO;
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你确定要退出此次编辑吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//            
//            [alert show];
//            backBtn.enabled = YES;
//        });
//    } else {
//        [self.view endEditing:YES];
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
    if (textView.text.length > 0 || self.imagesArray.count > 0) {
        if ([textView isFirstResponder]) {
            [textView resignFirstResponder];
            // 防止键盘关闭期间返回按钮可以一直点击
            backBtn.enabled = NO;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你确定要退出此次编辑吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                
                [alert show];
                backBtn.enabled = YES;
            });
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你确定要退出此次编辑吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            
            [alert show];
        }
    } else {
        [self.view endEditing:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

/**
 点击发送

 @param sender sender
 */
- (void)didPressedToSend:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    PostMessageCollectionViewCell *cell = (PostMessageCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    UIPlaceHolderTextView *textView = cell.text;
    
    NSString *str = [textView.txtView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
    
    if (str.length == 0 && self.imagesArray.count == 0) {
        [self.view makeToast:@"发帖文字和图片不能全部为空" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    
    NSMutableString *imageStr = [NSMutableString string];
    
    for (UIImage *image in self.imagesArray) {
        NSData *data = [image wxImageSize:image];

        NSString *dataStr = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
        
        [imageStr appendString:dataStr];
        [imageStr appendString:@"@"];
    }
    if (self.imagesArray.count > 0) {
        NSUInteger location = [imageStr length]-1;
        NSRange range = NSMakeRange(location, 1);
        [imageStr replaceCharactersInRange:range withString:@""];
    }
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"content"] = str;
//    paras[@"content"] = textView.txtView.text;
//    paras[@"access-token"] = [GeTuiSdk clientId];
    paras[@"user_id"] = User_ID;
    paras[@"sex"] = User_Sex;
    if (_selectCell >= 0) {
        paras[@"tag"] = [[self.topicArray objectAtIndex:_selectCell] tag_name];
    }
    paras[@"base64Images"] = imageStr;
    
    if (self.locView.address) {
        XDThreadLocation *loc = [[XDThreadLocation alloc] init];
        paras[@"lat_long"] = [NSString stringWithFormat:@"%@,%@",@(loc.coordinate.latitude),@(loc.coordinate.longitude)];
        paras[@"address"] = self.locView.address;
    } else {
        paras[@"lat_long"] = nil;
        paras[@"address"] = nil;
    }
    
    [self showHudInView:self.view hint:@"发送中..."];
    sender.enabled = NO;
    
    [XDRequestHttpTool request_sendThreads_withParameters:paras complete:^(id result) {
        [self hideHud];
        sender.enabled = YES;
        if ([result[@"code"] integerValue] == 200) {
//            [self.view makeToast:@"发送成功" duration:2.0 position:CSToastPositionCenter];
            [MBProgressHUD showSuccess:@"发送成功" toView:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
            if (self.sendPostSuccessBlock) {
                self.sendPostSuccessBlock();
            }
        } else {
            [self.view makeToast:result[@"message"] duration:2.0 position:CSToastPositionCenter];
        }
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        sender.enabled = YES;
        [self.view endEditing:YES];
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
    }];
}

#pragma mark - 所在位置点击
- (void)locViewClicked:(UITapGestureRecognizer *)tap {
    XDThreadLocationController *locVC = [[XDThreadLocationController alloc] init];
    locVC.delegate = self;
    locVC.locArea = self.locView.address;
    XDNavigationController *nav = [[XDNavigationController alloc] initWithRootViewController:locVC];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - XDThreadLocationControllerDelegate
- (void)areaPickerController:(XDThreadLocationController *)areaSelectController didSelectLocation:(NSString *)location {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    self.locView.address = location;
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - 键盘处理
/**
 *  键盘即将隐藏
 */
- (void)keyboardWillHide:(NSNotification *)note
{
    if (self.isChangingKeyboard) return;
    
    // 1.键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        
        self.locView.transform = CGAffineTransformIdentity;
    }];
}

/**
 *  键盘即将弹出
 */
- (void)keyboardWillShow:(NSNotification *)note
{
    // 1.键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        // 取出键盘高度
        CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyboardH = keyboardF.size.height;
        self.locView.transform = CGAffineTransformMakeTranslation(0, - keyboardH);
    }];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([alertView cancelButtonIndex] != buttonIndex) {
        [self.view endEditing:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
