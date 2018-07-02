//
//  XDRankListModel.h
//  ThirteenmakeFriends
//
//  Created by 空谷凌虚 on 2018/5/22.
//  Copyright © 2018年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDRankListModel : NSObject

@property (nonatomic, copy) NSString *nickname;//用户昵称 ， 吴悠
@property (nonatomic, copy) NSString *avatar;  // 用户头像 ， 吴悠
@property (nonatomic, assign) NSInteger sex;   //用户性别 ， 1女，0男
@property (nonatomic, assign) NSInteger diamonds; //得到或送出去的钻石数量 ，100


@end


@interface XDCustomRankListModel : NSObject

@property (nonatomic, strong) XDRankListModel *rankModel;
@property (nonatomic, assign) NSInteger index;//排名

@end


