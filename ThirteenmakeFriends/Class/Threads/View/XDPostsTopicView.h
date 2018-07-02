//
//  XDPostsTopicView.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 17/3/24.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TopicStringKey @"postTopic"

extern NSString *const kRouterEventPostTopicViewTapEventName;

@interface XDPostsTopicView : UIView

@property (copy, nonatomic) NSString * topicStiing;

@end
