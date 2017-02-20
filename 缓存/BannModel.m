//
//  BannModel.m
//  缓存
//
//  Created by zxc-02 on 2016/11/24.
//  Copyright © 2016年 zxc-02. All rights reserved.
//

#import "BannModel.h"

@implementation BannModel
- (instancetype)init
{
    if (self = [super init]) {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        path = [path stringByAppendingPathComponent:@"Helperdb"];
        NSLog(@"%@", path);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //            [self getTable];
        });
    }
    return self;
}

//重载选择 使用的LKDBHelper
+(LKDBHelper *)getUsingLKDBHelper
{
    static LKDBHelper* db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        db = [[LKDBHelper alloc]init];
    });
    return db;
}

+ (BannModel *)getUserInfoFromDBkey:(id)key obj:(id)obj
{
    NSString *where = [NSString stringWithFormat:@"image_url = '%@'",key];
    BannModel *model = [BannModel searchSingleWithWhere:where orderBy:nil];
    
    if (!model)
    {
        model = [[BannModel alloc] init];
        
        model.imageurl = obj[@"image_url"];
        model.title = obj[@"target"][@"title"];
        model.target_id = obj[@"target_id"];
        NSLog(@"model.imageurl=%@", model.imageurl);
        
        [model saveToDB];
    }
    
    return model;
}

- (void)setImageurl:(NSString *)imageurl
{
    _imageurl = imageurl;
    [BannModel updateToDB:self where:nil];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    [BannModel updateToDB:self where:nil];
}

- (void)setTarget_id:(NSString *)target_id
{
    _target_id = target_id;
    [BannModel updateToDB:self where:nil];
}

//表名
+ (NSString *)getTableName
{
    return @"BanTable";
}

//主键：唯一标示一条记录  A表中的一个字段，是B表的主键，则说字段是A的外键
+ (NSString *)getPrimaryKey
{
    return @"imageurl";
}

+ (NSArray *)searchSingleWhithProperty:(NSString *)property
{
    //单列查询
    NSArray *nameArray = [BannModel searchColumn:property where:nil orderBy:nil offset:0 count:0];
    return nameArray;
}

+ (NSArray *)searchLinesWhithPropertyA:(NSString *)a
                             PropertyB:(NSString *)b
{
    //多列查询
    NSArray *twoColumn = [BannModel searchColumn:[NSString stringWithFormat:@"%@,%@",a,b] where:nil orderBy:nil offset:0 count:0];
    return twoColumn;
}

+ (NSArray *)searchAll
{
    //查询所有属性
    NSArray *searchResultArray = nil;
    searchResultArray = [BannModel searchWithWhere:nil orderBy:nil offset:0 count:100];
    return searchResultArray;
}

@end
