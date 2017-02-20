//
//  BannerDB.m
//  网络考试题_家居
//
//  Created by wuyiguang on 16/2/19.
//  Copyright (c) 2016年 YG. All rights reserved.
//

#import "BannerDB.h"
#import "FMDatabase.h"

static BannerDB *user = nil;
static FMDatabase *fmdb = nil;

// 表名
#define kBannerTable @"LeBannerTableLE"

// 字段
#define kImgUrl @"imageurl"

#define kTitle @"title"

@implementation BannerDB

+ (BannerDB *)shared
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        user = [[self alloc] init];
    });
    return user;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        // 创建数据库
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        
        path = [path stringByAppendingPathComponent:@"BannerDB.db"];
        NSLog(@"pathLE %@",path);
        fmdb = [FMDatabase databaseWithPath:path];
        
        if (![fmdb open]) {
            NSLog(@"打开失败");
            return self;
        }
        
        // 创建一张表
        NSString *sql = [NSString stringWithFormat: @"CREATE TABLE IF NOT EXISTS %@ (id INTEGER PRIMARY KEY NOT NULL, %@ TEXT, %@ TEXT)", kBannerTable, kImgUrl, kTitle];
        
        // 执行语句
        if (![fmdb executeUpdate:sql]) {
            NSLog(@"建表失败");
        }
    }
    return self;
}

- (NSArray *)findAll
{
    NSMutableArray *userList = [[NSMutableArray alloc] init];
    
    // 1. sql语句
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@", kBannerTable];
    
    // 2. 执行
    FMResultSet *rs = [fmdb executeQuery:sql];
    
    // 3. 查找下一条记录
    while ([rs next]) {
        
        BannerModel *model = [[BannerModel alloc] init];
        
        // 获取字段的值，添加到模型中
        model.title = [rs stringForColumn:kTitle];
        model.imageurl = [rs stringForColumn:kImgUrl];
        
        // 模型添加到数组中
        [userList addObject:model];
    }
    
    return userList;
}

- (void)insertModels:(NSArray *)models
{
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@) VALUES (?, ?)", kBannerTable, kImgUrl, kTitle];
    
    for (BannerModel *model in models) {
        
        // 执行语句
        if (![fmdb executeUpdate:insertSql, model.imageurl, model.title]) {
            NSLog(@"插入失败");
        }
    }
}

- (void)deleteAll
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@", kBannerTable];
    
    if (![fmdb executeUpdate:sql]) {
        NSLog(@"删除失败");
    }
}

@end
