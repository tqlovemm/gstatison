//
//  UserProfileManager.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/9/23.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "UserProfileManager.h"

#import "FMDB.h"
#import "MKNetworkKit.h"

#define DBNAME @"user_cache_data.db"

#define kCURRENT_USERNAME [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername]

@implementation UserCacheInfo

@end

@implementation UserProfileManager

static UserProfileManager * _instance = nil;

+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init] ;
    }) ;
    
    return _instance ;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)loadUserProfileInBackgroundWithBuddy:(NSArray*)buddyList
{
    //首先构造Json数组
    //1.头
//    NSMutableArray *usernameArr = [NSMutableArray array];
//    for (EMBuddy *buddy in buddyList) {
//        [usernameArr addObject:buddy.username];
//    }
//    
//    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
//    paras[@"data"] = (NSArray *)usernameArr;
    
    NSMutableString *jsonString = [[NSMutableString alloc] initWithString:@"["];
    for(EMBuddy *buddy in buddyList){
        
        //2. 遍历数组，取出键值对并按json格式存放
        NSString *string;
        
        string  = [NSString stringWithFormat:
                   @"\"%@\",",buddy.username];
//        string  = [NSString stringWithFormat:
//                   @"%@,",buddy.username];
        
        [jsonString appendString:string];
        
    }
    // 添加自己的用户名
    [jsonString appendString:[NSString stringWithFormat:
                              @"\"%@\",",kCURRENT_USERNAME]];
    
    // 3. 获取末尾逗号所在位置
    NSUInteger location = [jsonString length]-1;
    
    NSRange range = NSMakeRange(location, 1);
    // 4. 将末尾逗号换成结束的]}
    [jsonString replaceCharactersInRange:range withString:@"]"];
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"data"] = (NSArray *)jsonString;
    
    [FKL_DataService requestURL:[NSString url_getIconAndNickname] parameters:paras withType:@"GET" format:@"JSON" complete:^(id result) {
        NSArray *array = result;
        for (NSDictionary *dic in array) {
            [UserProfileManager saveInfo:dic[@"username"] imgUrl:dic[@"avatar"] nickName:dic[@"nickname"]];
        }
        
    } faileComplete:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"获得昵称失败:%@",error);
    }];
}

#pragma mark - FMDB
+(void)createTable:(FMDatabase *)db
{
    if ([db open]) {
        if (![db tableExists :@"userinfo"]) {
            if ([db executeUpdate:@"create table userinfo (userid text, username text, userimage text)"]) {
                NSLog(@"create table success");
            }else{
                NSLog(@"fail to create table");
            }
        }else {
            NSLog(@"table is already exist");
        }
    }else{
        NSLog(@"fail to open");
    }
}

+ (void)clearTableData:(FMDatabase *)db
{
    if ([db executeUpdate:@"DELETE FROM userinfo"]) {
        NSLog(@"clear successed");
    }else{
        NSLog(@"fail to clear");
    }
}

+(FMDatabase*)getDB{
    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath   = [docsPath stringByAppendingPathComponent:DBNAME];
    FMDatabase *db     = [FMDatabase databaseWithPath:dbPath];
    [self createTable:db];
    return db;
}

/*
 *保存用户信息（如果已存在，则更新）
 *userId: 用户环信ID
 *imgUrl：用户头像链接（完整路径）
 *nickName: 用户昵称
 */
+(void)saveInfo:(NSString*)userId
         imgUrl:(NSString*)imgUrl
       nickName:(NSString*)nickName{
    NSMutableDictionary *extDic = [NSMutableDictionary dictionary];
    [extDic setValue:userId forKey:kChatUserId];
    [extDic setValue:imgUrl forKey:kChatUserPic];
    NSString *nick = @"";
    if (nickName == nil || [nickName isEqualToString:@""]) {
        nick = userId;
    } else {
        nick = nickName;
    }
    [extDic setValue:nick forKey:kChatUserNick];
    [UserProfileManager saveDict:extDic];
}

+(void)saveDict:(NSDictionary *)userinfo{
    FMDatabase *db     = [self getDB];
    
    NSString *userid = [[userinfo objectForKey:kChatUserId] lowercaseString];
    if ([db executeUpdate:@"DELETE FROM userinfo where userid = ?", userid]) {
        DLog(@"删除成功");
    }else{
        DLog(@"删除失败");
    }
    NSString *username = [userinfo objectForKey:kChatUserNick];
    NSString *userimage = [userinfo objectForKey:kChatUserPic];
    if ([db executeUpdate:@"INSERT INTO userinfo (userid, username, userimage) VALUES (?, ?, ?)", userid,username,userimage]) {
        DLog(@"插入成功");
    }else{
        DLog(@"插入失败");
    }
    
    [db close];
}

+ (void)saveAllDicts:(NSArray *)userinfos {
    
    FMDatabase *db = [self getDB];
    NSMutableString *deleteStr = [[NSMutableString alloc] initWithString:@"delete from userinfo where userid in('"];
    NSMutableString *insertStr = [[NSMutableString alloc] initWithString:@"INSERT INTO userinfo(userid,username,userimage) VALUES"];
    
    for (NSDictionary *dic in userinfos) {
        [deleteStr appendString:[NSString stringWithFormat:@"%@',",[dic[@"username"] lowercaseString]]];
        [insertStr appendString:[NSString stringWithFormat:@"('%@','%@','%@'),",[dic[@"username"] lowercaseString],dic[@"nickname"],dic[@"avatar"]]];
    }
    NSUInteger dekLocation = [deleteStr length]-1;
    NSRange delRange = NSMakeRange(dekLocation, 1);
    [deleteStr replaceCharactersInRange:delRange withString:@")"];
    
    NSUInteger insLocation = [insertStr length]-1;
    NSRange insRange = NSMakeRange(insLocation, 1);
    [insertStr replaceCharactersInRange:insRange withString:@""];
    
    if (userinfos.count == 0) {
        [db close];
        return;
    }
    
    if ([db executeUpdate:deleteStr]) {
        DLog(@"删除成功");
    }else{
        DLog(@"删除失败");
    }
    
    if ([db executeUpdate:insertStr]) {
        DLog(@"插入成功");
    }else{
        DLog(@"插入失败");
    }
    
    [db close];
}

/*
 *根据环信ID获取用户信息
 *userId 用户的环信ID
 */
+(UserCacheInfo*)getById:(NSString *)userid{
    
    FMDatabase *db     = [self getDB];
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:@"SELECT userid, username, userimage FROM userinfo where userid = ?",userid];
        if ([rs next]) {
            
            UserCacheInfo *userInfo = [[UserCacheInfo alloc] init];
            
            userInfo.Id = [rs stringForColumn:@"userid"];
            userInfo.NickName = [rs stringForColumn:@"username"];
            userInfo.AvatarUrl = [rs stringForColumn:@"userimage"];
            DLog(@"查询一个 %@",userInfo);
            return userInfo;
        }else{
            //            return nil;
            UserCacheInfo *userInfo = [[UserCacheInfo alloc] init];
            
            userInfo.Id = userid;
            userInfo.NickName = userid;
            userInfo.AvatarUrl = nil;
            return userInfo;
        }
    }else{
        //        return nil;
        UserCacheInfo *userInfo = [[UserCacheInfo alloc] init];
        
        userInfo.Id = userid;
        userInfo.NickName = userid;
        userInfo.AvatarUrl = nil;
        return userInfo;
    }
}

/*
 * 根据环信ID获取昵称
 * userId:环信用户id
 */
+(NSString*)getNickById:(NSString*)userId{
    UserCacheInfo *user = [UserProfileManager getById:userId];
    if(user == nil || [user  isEqual: @""]) return @"";
    
    return user.NickName;
}

/*
 * 获取当前环信用户信息
 */
+(UserCacheInfo*)getCurrUser{
    return [UserProfileManager getById:kCURRENT_USERNAME];
}

@end
