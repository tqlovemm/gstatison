//
//  XDSixPhotoView.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/8/24.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "XDSixPhotoView.h"
#import "XDMovePhotoView.h"
#import "UIImageView+WebCache.h"

//#define BIGIMAGE_WIDTH 199
//#define DIVIDE_WIDTH 3
//#define SMALLIMAGE_WIDTH (BIGIMAGE_WIDTH - DIVIDE_WIDTH)/2
//#define MOVEIMAGE_WIDTH SMALLIMAGE_WIDTH * 0.8

#define DIVIDE_WIDTH 3
#define SMALLIMAGE_WIDTH (SCREEN_WIDTH - 2 * DIVIDE_WIDTH) / 3.0
#define BIGIMAGE_WIDTH 2 * SMALLIMAGE_WIDTH + DIVIDE_WIDTH
#define MOVEIMAGE_WIDTH SMALLIMAGE_WIDTH * 0.8
#define Max_count 6

@interface XDSixPhotoView ()
{
    //! frame数组
    NSMutableArray *rectArray;
    //! 可见的View数组
    NSMutableArray *viewArray;
    BOOL isLongPress;
    float touchX;
    float touchY;
    CGRect moveInitFrame;
    CGRect moveFinishRect;
    int startPosition;
    // 是否移动结束
    BOOL isChangeEnd;
    BOOL isPerfermMove;
}

//! 可见的imageview数组
//@property (retain, nonatomic)NSMutableArray *imgArray;

@property (strong, nonatomic)XDMovePhotoView *moveImageView;

@end

@implementation XDSixPhotoView

-(instancetype)initWithData : (NSMutableArray *)array{
    if(self == [super init]){
//        self.imgArray = array;
        [self initRect];
        [self initView:array];
    }
    return self;
}

-(void)initRect{
    NSValue *value0 = [NSValue valueWithCGRect:CGRectMake(0, 0, BIGIMAGE_WIDTH, BIGIMAGE_WIDTH)];
    NSValue *value1 = [NSValue valueWithCGRect:CGRectMake(BIGIMAGE_WIDTH + DIVIDE_WIDTH, 0, SMALLIMAGE_WIDTH, SMALLIMAGE_WIDTH)];
    NSValue *value2 = [NSValue valueWithCGRect:CGRectMake(BIGIMAGE_WIDTH + DIVIDE_WIDTH, SMALLIMAGE_WIDTH + DIVIDE_WIDTH, SMALLIMAGE_WIDTH, SMALLIMAGE_WIDTH)];
    NSValue *value3 = [NSValue valueWithCGRect:CGRectMake(BIGIMAGE_WIDTH + DIVIDE_WIDTH, 2 * (SMALLIMAGE_WIDTH + DIVIDE_WIDTH), SMALLIMAGE_WIDTH, SMALLIMAGE_WIDTH)];
    NSValue *value4 = [NSValue valueWithCGRect:CGRectMake(SMALLIMAGE_WIDTH + DIVIDE_WIDTH, BIGIMAGE_WIDTH + DIVIDE_WIDTH, SMALLIMAGE_WIDTH, SMALLIMAGE_WIDTH)];
    NSValue *value5 = [NSValue valueWithCGRect:CGRectMake(0, BIGIMAGE_WIDTH + DIVIDE_WIDTH, SMALLIMAGE_WIDTH, SMALLIMAGE_WIDTH)];
    rectArray = [NSMutableArray arrayWithObjects:value0,value1,value2,value3,value4,value5,nil];
    
}



-(void)initView: (NSMutableArray *)array{
    isChangeEnd = YES;
    [self initBgImageView];
    [self initShowImageView:(NSMutableArray *)array];
    [self initMoveImageView];
    [self blindGestureRecignize];
    
}

-(void)initBgImageView{ // 添加背景图片
    UIImage *defautImg = [UIImage imageNamed:@"defaultimg"];
    for(int i= 0 ;i< [rectArray count] ;i++){
        XDMovePhotoView *imageView = [[XDMovePhotoView alloc]init];
        imageView.image = defautImg;
        imageView.frame = [[rectArray objectAtIndex:i] CGRectValue];
        UITapGestureRecognizer *recongnizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleAddTapPress:)];
        [imageView addGestureRecognizer:recongnizer];
        [self addSubview:imageView];
        
    }
}

-(void)initShowImageView:(NSMutableArray *)array{ // 添加可见图片
    
    viewArray = [[NSMutableArray alloc]init];
//    self.imgArray = [NSMutableArray array];
    for(int i= 0 ; i < ([array count] > Max_count ? Max_count : array.count) ; i++){
//        UIImage *image = [array objectAtIndex:i];
        NSString *imgStr = [array objectAtIndex:i];
        XDMovePhotoView *imageView = [[XDMovePhotoView alloc]init];
        //        imageView.postition = i;
        imageView.tag = i;
//        imageView.image = image;
//        [imageView sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"defaultimg"]];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imgStr]];
        imageView.userInteractionEnabled = YES;
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.frame = [[rectArray objectAtIndex:i] CGRectValue];
        [self addSubview:imageView];
        [viewArray addObject:imageView];
        
//        [self.imgArray addObject:imageView.image];
    }
    
}

-(void)initMoveImageView{
    _moveImageView = [[XDMovePhotoView alloc]init];
    [_moveImageView setHidden:YES];
    _moveImageView.userInteractionEnabled = YES;
    _moveImageView.clipsToBounds = YES;
    _moveImageView.contentMode = UIViewContentModeScaleAspectFill;
    _moveImageView.frame = CGRectMake(0, 0, MOVEIMAGE_WIDTH, MOVEIMAGE_WIDTH);
    [self addSubview:_moveImageView];
}


-(void)blindGestureRecignize{ // 给可见图片添加手势（长按拖拽，点击删除）
    for(int i = 0 ; i < [viewArray count] ; i++){
        XDMovePhotoView *view = [viewArray objectAtIndex:i];
        
        UILongPressGestureRecognizer *longPress =[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(hanldleLongPress:)];
        longPress.delegate = self;
        longPress.minimumPressDuration = 0.3f;
        [view addGestureRecognizer:longPress];
        view.tag = i;
        UITapGestureRecognizer *tapPress = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDeleteTapPress:)];
        
        [view addGestureRecognizer:tapPress];
        
    }
}


-(void)handleAddTapPress : (id)sender{ // 增加图片手势
    NSLog(@"添加");
    if(self.delegate){
        [self.delegate OnAddPhotoPress];
    }
}

-(void)handleDeleteTapPress : (id)sender{ // 删除图片手势
    UITapGestureRecognizer *recognizer = sender;
    XDMovePhotoView *view = (XDMovePhotoView *)recognizer.view;
    NSLog(@"删除");
    if(self.delegate){
        [self.delegate OnDeletePhotoPress:view.tag];
    }
}

-(void)hanldleLongPress : (id)sender{
    UILongPressGestureRecognizer *longPress = sender;
    XDMovePhotoView *selectImageView = (XDMovePhotoView *)longPress.view;
    CGPoint location = [longPress locationInView:self];
    touchX = location.x;
    touchY = location.y;
    
    
    if ([longPress state] == UIGestureRecognizerStateBegan) {
        if(isChangeEnd){
            isChangeEnd = NO;
            NSLog(@"长按开始");
            [selectImageView setHidden:YES];
            moveInitFrame = selectImageView.frame;
            _moveImageView.center = selectImageView.center;
            
            [_moveImageView setHidden:NO];
            _moveImageView.image = selectImageView.image;
            
            startPosition = (int)selectImageView.tag;
            
            NSLog(@"开始位置->%d",startPosition);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.3f];
            _moveImageView.center = CGPointMake(touchX, touchY);
            [UIView commitAnimations];
        }
    }
    else if ([longPress state] == UIGestureRecognizerStateEnded) {
        NSLog(@"长按结束");
        [selectImageView setHidden:NO];
        selectImageView.center = _moveImageView.center;
        [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            selectImageView.frame = moveFinishRect;
        } completion:nil];
        
        [self blindGestureRecignize];
        [_moveImageView setHidden:YES];
        
        
    }
    
    _moveImageView.center = CGPointMake(touchX, touchY);
    NSInteger count = [viewArray count];
    if(count > 5){
        [self StepArea5];
    }
    
    if(count > 4){
        [self StepArea4];
    }
    if(count > 3){
        [self StepArea3];
    }
    if(count > 2){
        [self StepArea2];
    }
    if(count > 1){
        [self StepArea1];
    }
    
    if(count > 0){
        [self StepArea0];
    }
}


-(void)StepArea0{
    BOOL condition1 = touchX > 0 && touchX < BIGIMAGE_WIDTH;
    BOOL condition2 = touchY > 0 && touchY < BIGIMAGE_WIDTH;
    if((condition1 && condition2) || isPerfermMove){
        NSLog(@"进入0区域");
        moveFinishRect = [[rectArray objectAtIndex:0] CGRectValue];
        [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self changePosition:startPosition end:0];
        } completion:nil];
    }
}

-(void)StepArea1{
    BOOL condition1 = touchX > BIGIMAGE_WIDTH + DIVIDE_WIDTH && touchX < BIGIMAGE_WIDTH + DIVIDE_WIDTH + SMALLIMAGE_WIDTH;
    BOOL condition2 = touchY > 0 && touchY < SMALLIMAGE_WIDTH;
    if((condition1 && condition2) || isPerfermMove){
        NSLog(@"进入1区域");
        moveFinishRect = [[rectArray objectAtIndex:1] CGRectValue];
        [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self changePosition:startPosition end:1];
        } completion:nil];
    }
}

-(void)StepArea2{
    BOOL condition1 = touchX > BIGIMAGE_WIDTH + DIVIDE_WIDTH && touchX < BIGIMAGE_WIDTH + DIVIDE_WIDTH + SMALLIMAGE_WIDTH;
    BOOL condition2 = touchY > SMALLIMAGE_WIDTH + DIVIDE_WIDTH && touchY <  BIGIMAGE_WIDTH;
    if((condition1 && condition2) || isPerfermMove){
        NSLog(@"进入2区域");
        moveFinishRect =  [[rectArray objectAtIndex:2] CGRectValue];;
        [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self changePosition:startPosition end:2];
        } completion:nil];
    }
}

-(void)StepArea3{
    BOOL condition1 = touchX > BIGIMAGE_WIDTH + DIVIDE_WIDTH && touchX < BIGIMAGE_WIDTH + DIVIDE_WIDTH + SMALLIMAGE_WIDTH;
    BOOL condition2 = touchY > BIGIMAGE_WIDTH + DIVIDE_WIDTH && touchY < BIGIMAGE_WIDTH + DIVIDE_WIDTH + SMALLIMAGE_WIDTH;
    if((condition1 && condition2) || isPerfermMove){
        NSLog(@"进入3区域");
        moveFinishRect =  [[rectArray objectAtIndex:3] CGRectValue];;
        [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self changePosition:startPosition end:3];
        } completion:nil];
    }
}

-(void)StepArea4{
    BOOL condition1 = touchX > SMALLIMAGE_WIDTH + DIVIDE_WIDTH && touchX < BIGIMAGE_WIDTH ;
    BOOL condition2 = touchY > BIGIMAGE_WIDTH  + DIVIDE_WIDTH && touchY < BIGIMAGE_WIDTH + DIVIDE_WIDTH + SMALLIMAGE_WIDTH;
    if((condition1 && condition2) || isPerfermMove){
        NSLog(@"进入4区域");
        moveFinishRect =  [[rectArray objectAtIndex:4] CGRectValue];;
        [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self changePosition:startPosition end:4];
        } completion:nil];
    }
}

-(void)StepArea5{
    BOOL condition1 = touchX > 0 && touchX < SMALLIMAGE_WIDTH;
    BOOL condition2 = touchY > BIGIMAGE_WIDTH + DIVIDE_WIDTH && touchY < BIGIMAGE_WIDTH + DIVIDE_WIDTH + SMALLIMAGE_WIDTH;
    if((condition1 && condition2) || isPerfermMove){
        NSLog(@"进入5区域");
        moveFinishRect =  [[rectArray objectAtIndex:5] CGRectValue];;
        [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self changePosition:startPosition end:5];
        } completion:nil];
        
    }
}

-(void)changePosition : (int)start
                  end : (int)end{
    NSLog(@"开始->%d",start);
    
    if(start - end < 0){
        for(int i = start ;i < end ; i++){
            ((XDMovePhotoView *)[viewArray objectAtIndex:i+1]).frame = [[rectArray objectAtIndex:i] CGRectValue];
        }
        for(int i = start ;i < end ; i++){
            [viewArray exchangeObjectAtIndex:i+1 withObjectAtIndex:i];
        }
    }
    else{
        for(int i = start ;i > end ; i--){
            ((XDMovePhotoView *)[viewArray objectAtIndex:i-1]).frame = [[rectArray objectAtIndex:i] CGRectValue];
        }
        for(int i = start ;i > end ; i--){
            [viewArray exchangeObjectAtIndex:i-1 withObjectAtIndex:i];
        }
    }
    startPosition = end;
    isChangeEnd = YES;
    NSLog(@"开始位置->%d",startPosition);
    
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"动画结束");
}

-(NSMutableArray *)getNewOrder{
    NSMutableArray *result = [[NSMutableArray alloc]init];
//    for(UIImage *image in _imgArray){
//        [result addObject:image];
//    }
    for(UIImageView *imageview in viewArray){
//        [result addObject:imageview.image];
        if (imageview.image) { // 解决有url图片路径，图片却找不到的bug
            [result addObject:imageview.image];
        }
    }
    return result;
}

-(void)addImage : (UIImage *)image{
//    [self.imgArray addObject:image];
//    int i = (int)[_imgArray count]-1;
    int i = (int)[viewArray count];
    XDMovePhotoView *imageView = [[XDMovePhotoView alloc]init];
    imageView.tag = i;
    imageView.image = image;
    imageView.userInteractionEnabled = YES;
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.frame = [[rectArray objectAtIndex:i] CGRectValue];
    [self addSubview:imageView];
    [viewArray addObject:imageView];
    [self blindGestureRecignize];
}

-(void)deleteImage : (int)tag{
    XD_WeakSelf
//    [self.imgArray removeObjectAtIndex:tag];
    XDMovePhotoView *view = [viewArray objectAtIndex:tag];
    [view removeFromSuperview];
    [viewArray removeObjectAtIndex:tag];
    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        for(int i = tag ;i < [viewArray count] ; i++){
            ((XDMovePhotoView *)[viewArray objectAtIndex:i]).frame = [[rectArray objectAtIndex:i] CGRectValue];
        }
    } completion:^(BOOL finished) {
        XD_StrongSelf
        [self blindGestureRecignize];
    }];
}
-(void)replaceImage:(UIImage *)image tag:(int)tag{
//    [self.imgArray replaceObjectAtIndex:tag withObject:image];
    XDMovePhotoView *view = [viewArray objectAtIndex:tag];
    view.image = image;
    [self blindGestureRecignize];
}

@end
