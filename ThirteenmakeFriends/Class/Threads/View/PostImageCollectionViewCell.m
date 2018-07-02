//
//  PostImageCollectionViewCell.m
//  ThirteenmakeFriends
//
//  Created by iOS on 23/3/17.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "PostImageCollectionViewCell.h"

@implementation PostImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"PostImageCollectionViewCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (IBAction)didPressedToCancle:(UIButton *)sender {
    if (_cancleBlock) {
        _cancleBlock();
    }
}

@end
