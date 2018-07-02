/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * applyEntity: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import "InvitationManager.h"
#import "FMDB.h"

#define DBNAME @"user_cache_data.db"

@interface InvitationManager ()
//{
//    NSUserDefaults *_defaults;
//}

@end

static InvitationManager *sharedInstance = nil;
@implementation InvitationManager

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
//-(instancetype)init{
//    if (self = [super init]) {
//        _defaults = [NSUserDefaults standardUserDefaults];
//    }
//    
//    return self;
//}
-(FMDatabase*)getDB {
    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath   = [docsPath stringByAppendingPathComponent:DBNAME];
    FMDatabase *db     = [FMDatabase databaseWithPath:dbPath];
    [self createTable:db];
    return db;
}

#pragma mark - FMDB
-(void)createTable:(FMDatabase *)db
{
    // create table userinfo (userid text, username text, userimage text)
    if ([db open]) {
        if (![db tableExists:@"applyFriendInfo"]) {
            if ([db executeUpdate:@"create table if not exists applyFriendInfo (id integer primary key autoincrement not null, applicantUsername varchar(255), applicantNick varchar(255), applicantAvatar varchar(255), reason varchar(255), receiverUsername varchar(255), receiverNick varchar(255), style varchar(255), groupId varchar(255), groupSubject varchar(255), is_dealed varchar(255), loginUser varchar(255))"]) {
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

- (void)clearTableData:(FMDatabase *)db
{
    if ([db executeUpdate:@"delete from applyFriendInfo"]) {
        NSLog(@"clear successed");
    }else{
        NSLog(@"fail to clear");
    }
}

-(void)addInvitation:(ApplyEntity *)applyEntity loginUser:(NSString *)username{
//    NSData *defalutData = [_defaults objectForKey:username];
//    NSArray *ary = [NSKeyedUnarchiver unarchiveObjectWithData:defalutData];
//    NSMutableArray *appleys = [[NSMutableArray alloc] initWithArray:ary];
//    [appleys addObject:applyEntity];
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:appleys];
//    [_defaults setObject:data forKey:username];
    
    FMDatabase *db = [self getDB];
    
    if ([db executeUpdate:@"insert into applyFriendInfo(applicantUsername,applicantNick,applicantAvatar,reason,receiverUsername,receiverNick,style,groupId,groupSubject,is_dealed,loginUser) VALUES(?,?,?,?,?,?,?,?,?,?,?)",applyEntity.applicantUsername,applyEntity.applicantNick,applyEntity.applicantAvatar,applyEntity.reason,applyEntity.receiverUsername,applyEntity.receiverNick,applyEntity.style,applyEntity.groupId,applyEntity.groupSubject,applyEntity.is_dealed,username]) {
        NSLog(@"插入成功");
    }else{
        NSLog(@"插入失败");
    }
    
    [db close];
}

-(void)removeInvitation:(ApplyEntity *)applyEntity loginUser:(NSString *)username{
//    NSData *defalutData = [_defaults objectForKey:username];
//    NSArray *ary = [NSKeyedUnarchiver unarchiveObjectWithData:defalutData];
//    NSMutableArray *appleys = [[NSMutableArray alloc] initWithArray:ary];
//    ApplyEntity *needDelete;
//    for (ApplyEntity *entity in appleys) {
//        if ([entity.groupId isEqualToString:applyEntity.groupId] &&[entity.receiverUsername isEqualToString:applyEntity.receiverUsername]) {
////            [entity.receiverUsername isEqualToString:applyEntity.receiverUsername]) {
//            needDelete = entity;
//            break;
//        }
//    }
//    [appleys removeObject:needDelete];
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:appleys];
//    [_defaults setObject:data forKey:username];
    
    FMDatabase *db = [self getDB];
    
    if ([db executeUpdate:@"delete from applyFriendInfo where loginUser = ? and groupId = ? and applicantUsername = ?",username,applyEntity.groupId,applyEntity.applicantUsername]) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败");
    }
    
    
    [db close];
}

// 申请与通知
-(void)updateInvitation:(ApplyEntity *)applyEntity loginUser:(NSString *)username {
//    NSData *defalutData = [_defaults objectForKey:username];
//    NSArray *ary = [NSKeyedUnarchiver unarchiveObjectWithData:defalutData];
//    NSMutableArray *appleys = [[NSMutableArray alloc] initWithArray:ary];
//    
//    for (int i = 0 ; i < appleys.count ; i++) {
//        ApplyEntity *entity = [appleys objectAtIndex:i];
//        if ([entity.applicantUsername isEqualToString:applyEntity.applicantUsername] && [entity.groupId isEqualToString:applyEntity.groupId] &&[entity.receiverUsername isEqualToString:applyEntity.receiverUsername]) {
//            [appleys replaceObjectAtIndex:i withObject:applyEntity];
//            break;
//        }
//    }
//    
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:appleys];
//    [_defaults setObject:data forKey:username];
    
    FMDatabase *db = [self getDB];
    
    if ([db executeUpdate:@"update 'applyFriendInfo' SET is_dealed = ? , reason = ? where applicantUsername = ? and loginUser = ? and groupId = ?",applyEntity.is_dealed,applyEntity.reason,applyEntity.applicantUsername,username,applyEntity.groupId]) {
        NSLog(@"更新成功");
    } else {
        NSLog(@"更新成功");
    }
    
    [db close];
}

-(NSArray *)applyEmtitiesWithloginUser:(NSString *)username{
//    NSData *defalutData = [_defaults objectForKey:username];
//    NSArray *ary = [NSKeyedUnarchiver unarchiveObjectWithData:defalutData];
//    return ary;
    
    FMDatabase *db = [self getDB];
    NSMutableArray  *noticeArray = [[NSMutableArray alloc] init];
    
    FMResultSet *res = [db executeQuery:[NSString stringWithFormat:@"select * from applyFriendInfo where loginUser = '%@' order by id desc",username]];
    while ([res next]) {
        ApplyEntity *notice = [[ApplyEntity alloc] init];
        notice.applicantUsername = [res stringForColumn:@"applicantUsername"];
        notice.applicantNick = [res stringForColumn:@"applicantNick"];
        notice.applicantAvatar = [res stringForColumn:@"applicantAvatar"];
        notice.reason = [res stringForColumn:@"reason"];
        notice.receiverUsername = [res stringForColumn:@"receiverUsername"];
        notice.receiverNick = [res stringForColumn:@"receiverNick"];
        notice.style = @([[res stringForColumn:@"style"] integerValue]);
        notice.groupId = [res stringForColumn:@"groupId"];
        notice.groupSubject = [res stringForColumn:@"groupSubject"];
        notice.is_dealed = [res stringForColumn:@"is_dealed"];
        [noticeArray addObject:notice];
        
    }
    [db close];
    
    return noticeArray;
}

@end


@interface ApplyEntity ()<NSCoding>

@end

@implementation ApplyEntity

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_applicantUsername forKey:@"applicantUsername"];
    [aCoder encodeObject:_applicantNick forKey:@"applicantNick"];
    [aCoder encodeObject:_applicantAvatar forKey:@"applicantAvatar"];
    [aCoder encodeObject:_reason forKey:@"reason"];
    [aCoder encodeObject:_receiverUsername forKey:@"receiverUsername"];
    [aCoder encodeObject:_receiverNick forKey:@"receiverNick"];
    [aCoder encodeObject:_style forKey:@"style"];
    [aCoder encodeObject:_groupId forKey:@"groupId"];
    [aCoder encodeObject:_groupSubject forKey:@"groupSubject"];
    // 申请与通知
    [aCoder encodeObject:_is_dealed forKey:@"is_dealed"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        _applicantUsername = [aDecoder decodeObjectForKey:@"applicantUsername"];
        _applicantNick = [aDecoder decodeObjectForKey:@"applicantNick"];
        _applicantAvatar = [aDecoder decodeObjectForKey:@"applicantAvatar"];
        _reason = [aDecoder decodeObjectForKey:@"reason"];
        _receiverUsername = [aDecoder decodeObjectForKey:@"receiverUsername"];
        _receiverNick = [aDecoder decodeObjectForKey:@"receiverNick"];
        _style = [aDecoder decodeObjectForKey:@"style"];
        _groupId = [aDecoder decodeObjectForKey:@"groupId"];
        _groupSubject = [aDecoder decodeObjectForKey:@"groupSubject"];
        // 申请与通知
        _is_dealed = [aDecoder decodeObjectForKey:@"is_dealed"];
        
    }
    
    return self;
}

@end

