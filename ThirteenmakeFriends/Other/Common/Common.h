//
//  Common.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 15/12/18.
//  Copyright © 2015年 ThirtyOneDay. All rights reserved.
//

#ifndef Common_h
#define Common_h

#ifdef DEBUG  // 调试阶段
#define NSLog(...) NSLog(__VA_ARGS__)
#else // 发布阶段
#define NSLog(...)
#endif

#ifdef DEBUG  // 调试阶段
//测试服
#define DomainUrl2 @"http://app.gzhanss.com"

#define ToPayUrl @"http://gd.tecclub.cn"

#else // 发布阶段
//正式服
#define DomainUrl2 @"https://app.13loveme.com"
#define ToPayUrl @"http://gd.tecclub.cn"

#endif

// 应用信息
#define AppKey @"thirtyone#chatapp"
#define istore_dev @""
#define istore @""
#define apns_dev @"iOS-13-dev-push"
#define apns_distribe @"iOS-13-distribe-push"

#ifdef DEBUG  // 调试阶段
// 测试-环境推送
#define kGtAppId @"6j0cJ09jOB8tkqAv1R7wa2"
#define kGtAppKey @"cjqD7Sx1Ju5VmkZLRJcLg4"
#define kGtAppSecret @"t4S4smw3Bs78YaVFmuIEm"
#else // 发布阶段
// 个推开发者网站中申请 App 时注册的 AppId、AppKey、AppSecret 正式-环境推送
#define kGtAppId @"o2fItBGkhp9vFjQIkI8Q55"
#define kGtAppKey @"8grrIU5kcr8b4d7KHJTUN5"
#define kGtAppSecret @"7UakhIfz9k7T6Iu9RnW0S9"
#endif

// 表情云
#define BQMM_AppKey @"62c59557aaf8450a864c0a179197a729"
#define BQMM_AppSecret @"703182506bb645c2b0f4fde9be9d5226"

// 短信验证
#define SMS_AppKey @"133a820021de8"
#define SMS_AppSecret @"78f86f1a085157969da12a1f21e71016"
//#define SMS_template @"8903035"
#define SMS_template nil


// APPID
#define APPID @"1320743193"

// 友盟统计
#define UM_Statistics_AppKey @"5a2f9ffcf43e480cd30004c2"

// 微信 GZ
#define WX_AppKey @"wxfdfc4baabc0ed36b"
#define WX_AppSecret @"220110fb27f16b866addbe1ac1e22d92"
#define WX_redirectURL @"http://mobile.umeng.com/social"

// qq GZ
#define QQ_AppKey @"1107003338"
#define QQ_AppSecret @"Ofpg0rKHj4D6TtvW"
#define QQ_redirectURL @"http://mobile.umeng.com/social"

// 微博 GZ
#define WB_AppKey @"3279522088"
#define WB_AppSecret @"a5be451a45e28d0c899e83af530cae45"
#define WB_redirectURL @"http://www.jianshu.com"

// ios7
#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define iOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define iOS10 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)

/** AppDelegate对象*/
#define myAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

// 是否为4inch
#define FourInch ([UIScreen mainScreen].bounds.size.height == 568.0)

// 屏幕宽高
#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define View_HEIGHT (SCREEN_HEIGHT - NavigationBar_Height - TabBar_Height)


// 状态栏
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0
/** 顶部高度 */
#define NavigationBar_Height (kStatusBarHeight + kNavBarHeight)
#define TabBar_Height ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define Normal_Height 44
#define kSafeBottomHeight 34

/** 获取某View安全区域范围的宏 */
#define VIEWSAFEAREAINSETS(view) ({UIEdgeInsets i; if(@available(iOS 11.0, *)) {i = view.safeAreaInsets;} else {i = UIEdgeInsetsZero;} i;})

// 是否有网络
#define isNetworking [[AppUpdateInfo sharedInstance] isHavingNetworking]

// 动态
/** 昵称的字体*/
#define postNameFont [UIFont systemFontOfSize:15]
/** 年龄的字体*/
#define ageFont [UIFont systemFontOfSize:12]
/** 正文的字体*/
#define postContentFont [UIFont systemFontOfSize:13]
/** 距离cell边框的距离*/
#define postCellBorder 10

/** 18号字体*/
#define k18Font [UIFont systemFontOfSize:18]
/** 17号字体*/
#define k17Font [UIFont systemFontOfSize:17]
/** 16号字体*/
#define k16Font [UIFont systemFontOfSize:16]
/** 15号字体*/
#define k15Font [UIFont systemFontOfSize:15]
/** 14号字体*/
#define k14Font [UIFont systemFontOfSize:14]
/** 13号字体*/
#define k13Font [UIFont systemFontOfSize:13]
/** 12号字体*/
#define k12Font [UIFont systemFontOfSize:12]

/** ios9以后 平方字体 ， ios9 之前 Helvetica 字体 */
#define kPingFangBoldFont(x) [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 ? [UIFont fontWithName:@"PingFangSC-Medium" size:x] : [UIFont fontWithName:@"Helvetica-Bold" size:x]

#define kPingFangLightFont(x) [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 ? [UIFont fontWithName:@"PingFangSC-Light" size:x] : [UIFont fontWithName:@"Helvetica-Light" size:x]

#define kPingFangRegularFont(x) [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 ? [UIFont fontWithName:@"PingFangSC-Regular" size:x] : [UIFont fontWithName:@"Helvetica" size:x]

#define kPingFangThinFont(x) [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 ? [UIFont fontWithName:@"PingFangSC-Thin" size:x] : [UIFont fontWithName:@"Helvetica-Light" size:x]

// 帖子cell内部相册
#define PhotosMaxCount 9
#define PhotosMaxCols(photosCount) ((photosCount==4)?2:3)
#define PhotoW 70
#define PhotoH PhotoW
#define PhotoMargin 10

// 通知
// 表情选中的通知
#define HMEmotionDidSelectedNotification @"HMEmotionDidSelectedNotification"
// 点击删除按钮的通知
#define HMEmotionDidDeletedNotification @"HMEmotionDidDeletedNotification"
// 通知里面取出表情用的key
#define HMSelectedEmotion @"HMSelectedEmotion"

// 链接选中的通知
#define HMLinkDidSelectedNotification @"HMLinkDidSelectedNotification"

// 富文本里面出现的链接
#define HMLinkText @"HMLinkText"

/** 表情相关 */
// 表情的最大行数
#define HMEmotionMaxRows 3
// 表情的最大列数
#define HMEmotionMaxCols 7
// 每页最多显示多少个表情
#define HMEmotionMaxCountPerPage (HMEmotionMaxRows * HMEmotionMaxCols - 1)

// 判断是否为 iPhone 5S/SE
#define iPhone5SE [[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 568.0f
/** iPhone X */
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//#define iPhoneX [[UIScreen mainScreen] bounds].size.width == 375.0f && [[UIScreen mainScreen] bounds].size.height == 812.0f

// 登陆信息
#define LoginUserID @"userID"
#define LoginName @"userName"
#define LoginPassword @"userPassword"
#define LoginSex @"sex"
#define LoginAvatar @"avatar"
#define HuangXingPwd @"huangxingpwd"

#define User_ID [[NSUserDefaults standardUserDefaults] objectForKey:LoginUserID]
#define User_Name [[NSUserDefaults standardUserDefaults] objectForKey:LoginName]
#define User_Password [[NSUserDefaults standardUserDefaults] objectForKey:LoginPassword]
#define User_Sex [[NSUserDefaults standardUserDefaults] objectForKey:LoginSex]
#define User_Avatar [[NSUserDefaults standardUserDefaults] objectForKey:LoginAvatar]

#define UserDefaults            [NSUserDefaults standardUserDefaults]
#define ImageViewName(x)        [UIImage imageNamed:x]

//#define KUserDefualtsLoginUserName [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername]
#define KUserDefualtsLoginUserName [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"em_lastLogin_%@",kSDKUsername]]
#define KUserDefualtsLoginToken [[NSUserDefaults standardUserDefaults] objectForKey:kSDKToken]

//Ext keyWord（环信客服扩展字段）
#define kMesssageExtWeChat @"weichat"
#define kMesssageExtWeChat_ctrlType @"ctrlType"
#define kMesssageExtWeChat_ctrlType_enquiry @"enquiry"
#define kMesssageExtWeChat_ctrlType_inviteEnquiry @"inviteEnquiry"
#define kMesssageExtWeChat_ctrlArgs @"ctrlArgs"
#define kMesssageExtWeChat_ctrlArgs_inviteId @"inviteId"
#define kMesssageExtWeChat_ctrlArgs_serviceSessionId @"serviceSessionId"
#define kMesssageExtWeChat_ctrlArgs_detail @"detail"
#define kMesssageExtWeChat_ctrlArgs_summary @"summary"

#define kMesssageExtWeChat_agent @"agent"
#define kMesssageExtWeChat_agent_userNickname @"userNickname"
#define kMesssageExtWeChat_agent_avatar @"avatar"

// 环信聊天用的昵称和头像（发送聊天消息时，要附带这3个属性）
#define kChatUserId @"ChatUserId"// 环信账号
#define kChatUserNick @"ChatUserNick"
#define kChatUserPic @"ChatUserPic"

// 自定义消息cell
#define KEM_Custom_Message_Key @"em_Custom_Message"
#define KEM_Custom_Message_userName @"cardUserName"
#define KEM_Custom_Message_cardUserDes @"cardUserDes"
#define KEM_Custom_Message_cardUserPic @"cardUserPic"
#define KEM_Custom_Message_cardClickUrl @"cardClickUrl"


#define WEAKSELF  typeof(self) __weak weakSelf=self;

#define ALERT(title, msg)                   [[[UIAlertView alloc]     initWithTitle:title\
                                            message:msg\
                                            delegate:nil\
                                            cancelButtonTitle:@"确定"\
                                            otherButtonTitles:nil] show]

#define F(string, args...)                  [NSString stringWithFormat:string, args]
#define URL(string)                         [NSURL URLWithString:(string)]
#define StringEqual(x,y)                    [(x) isEqualToString:(y)]


//tableview的head高度为0时
static CGFloat  const HeightHeadViewZero = 0.00001f;

#pragma mark - weak / strong
#define XD_WeakSelf        @XD_Weakify(self);
#define XD_StrongSelf      @XD_Strongify(self);

/*！
 * 强弱引用转换，用于解决代码块（block）与强引用self之间的循环引用问题
 * 调用方式: `@XD_Weakify`实现弱引用转换，`@XD_Strongify`实现强引用转换
 *
 * 示例：
 * @XD_Weakify
 * [obj block:^{
 * @strongify_self
 * self.property = something;
 * }];
 */
#ifndef XD_Weakify
#if DEBUG
#if __has_feature(objc_arc)
#define XD_Weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define XD_Weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define XD_Weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define XD_Weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

/*！
 * 强弱引用转换，用于解决代码块（block）与强引用对象之间的循环引用问题
 * 调用方式: `@XD_Weakify(object)`实现弱引用转换，`@XD_Strongify(object)`实现强引用转换
 *
 * 示例：
 * @XD_Weakify(object)
 * [obj block:^{
 * @XD_Strongify(object)
 * strong_object = something;
 * }];
 */
#ifndef XD_Strongify
#if DEBUG
#if __has_feature(objc_arc)
#define XD_Strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define XD_Strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define XD_Strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define XD_Strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

#endif /* Common_h */
