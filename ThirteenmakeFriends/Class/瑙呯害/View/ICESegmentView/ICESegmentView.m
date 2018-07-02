//
//  ICESegmentView.m
//  ThirteenmakeFriends
//
//  Created by iOS on 13/3/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "ICESegmentView.h"
#import "Masonry.h"

@interface ICESegmentView ()

@property (nonatomic , strong) UIScrollView *scTop;

@end

@implementation ICESegmentView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createDeafultView];
    }
    return self;
}

- (void)createDeafultView {
    if (!_scTop) {
        _scTop = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height)];
        _scTop.backgroundColor = [UIColor whiteColor];
        _scTop.pagingEnabled = NO;
        _scTop.scrollEnabled = NO;
        _scTop.alwaysBounceHorizontal         = YES;
        _scTop.showsVerticalScrollIndicator   = NO;
        _scTop.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scTop];
    }
}

- (void)OnTapNameBtn:(UIButton *)sender {
    for (UIView *view in _scTop.subviews) {
        for (UIButton *btn in view.subviews) {
            [btn setImage:[UIImage imageNamed:_sectionImages[btn.tag - 10]] forState:UIControlStateNormal];
            if (btn.tag == sender.tag) {
                [btn setImage:[UIImage imageNamed:_sectionSelectedImages[sender.tag - 10]] forState:UIControlStateNormal];
            }
        }
    }
    
    if (_indexChangeBlock) {
        _indexChangeBlock(sender.tag-10);
    }
}

#pragma mark - getter && setter 
- (void)setSectionImages:(NSArray *)sectionImages {
    if (sectionImages.count > 0) {
        _sectionImages = [sectionImages copy];
        
        for (int i = 0; i < self.sectionImages.count; i++) {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4.0*i, 0, SCREEN_WIDTH/4.0, self.frame.size.height)];
            view.backgroundColor = [UIColor whiteColor];
            [_scTop addSubview:view];
            
            UIButton *nameBtn   = [[UIButton alloc]init];
            nameBtn.tag         = 10+i;
            nameBtn.backgroundColor = [UIColor whiteColor];
            nameBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [nameBtn setAdjustsImageWhenHighlighted:NO];
            [nameBtn setImage:[UIImage imageNamed:_sectionImages[i]] forState:UIControlStateNormal];
            [nameBtn addTarget:self action:@selector(OnTapNameBtn:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:nameBtn];
            
            [nameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(view.mas_centerX);
                make.centerY.mas_equalTo(view.mas_centerY);
                make.width.height.mas_equalTo(50);
            }];
        }
    }
}

- (void)setSectionSelectedImages:(NSArray *)sectionSelectedImages {
    if (sectionSelectedImages.count > 0) {
        _sectionSelectedImages = sectionSelectedImages;
        
        for (UIView *view in _scTop.subviews) {
            for (UIButton *btn in view.subviews) {
                if (btn.tag == 10) {
                    [btn setImage:[UIImage imageNamed:_sectionSelectedImages[0]] forState:UIControlStateNormal];
                }
            }
        }
    }
}
@end
