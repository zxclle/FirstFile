//
//  BannerModel.m
//  网络考试题_家居
//
//  Created by wuyiguang on 16/2/18.
//  Copyright (c) 2016年 YG. All rights reserved.
//

#import "BannerModel.h"
#import "MJExtension.h"
#import "NSObject+MJKeyValue.h"
@implementation BannerModel
MJExtensionLogAllProperties

+ (instancetype)instanceObj:(id)obj
{
    BannerModel *model = [[BannerModel alloc] init];
    
    model.imageurl = obj[@"image_url"];
    model.title = obj[@"target"][@"title"];
    model.target_id = obj[@"target_id"];
    return model;
}


//KVC
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"image_url"])
    {
        self.imageurl = value;
    }
    
    if ([key isEqualToString:@"target"])
    {
        self.title = value[@"title"];
    }
}

-(id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}


//JSONModel
//+(JSONKeyMapper *)keyMapper
//{
//    
//    return [[JSONKeyMapper alloc] initWithDictionary:@{@"target.title":@"title",
//                             @"image_url":@"imageurl"}];
//}
//
//+ (BOOL)propertyIsOptional:(NSString *)propertyName
//{
//    
//    return YES;
//}


- (instancetype)init
{
    if (self = [super init]) {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        path = [path stringByAppendingPathComponent:@"LKHelperdb"];
        NSLog(@"%@", path);
        // @"LKKKHelperdb"，这个不重要，他会自动统一路径为.../Documents/db
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

+ (BannerModel *)getUserInfoFromDBkey:(id)key obj:(id)obj
{
    NSString *where = [NSString stringWithFormat:@"image_url = '%@'",nil];
    BannerModel *model = [BannerModel searchSingleWithWhere:where orderBy:nil];
    
    if (!model)
    {
        model = [[BannerModel alloc] init];
    
//        model.imageurl = obj[@"image_url"];
//        model.title = obj[@"target"][@"title"];
//        model.target_id = obj[@"target_id"];
//        NSLog(@"model.imageurl=%@", model.imageurl);
//kvc
        [model setValuesForKeysWithDictionary:obj];
//        model = [BannerModel mj_objectWithKeyValues:obj];
        [model saveToDB];
    }
    
    return model;
}

- (void)setImageurl:(NSString *)imageurl
{
    _imageurl = imageurl;
    [BannerModel updateToDB:self where:nil];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    [BannerModel updateToDB:self where:nil];
}

- (void)setTarget_id:(NSString *)target_id
{
    _target_id = target_id;
    [BannerModel updateToDB:self where:nil];
}

//表名
+ (NSString *)getTableName
{
    return @"BannerModelTable";
}

//主键：唯一标示一条记录  A表中的一个字段，是B表的主键，则说该字段是A的外键
+ (NSString *)getPrimaryKey
{
    return @"imageurl";
}

+ (NSArray *)searchSingleWhithProperty:(NSString *)property
{
    //单列查询
    NSArray *nameArray = [BannerModel searchColumn:property where:nil orderBy:nil offset:0 count:0];
    return nameArray;
}

+ (NSArray *)searchLinesWhithPropertyA:(NSString *)a
                             PropertyB:(NSString *)b
{
    //多列查询
    NSArray *twoColumn = [BannerModel searchColumn:[NSString stringWithFormat:@"%@,%@",a,b] where:nil orderBy:nil offset:0 count:0];
    return twoColumn;
}

+ (NSArray *)searchAll
{
    //查询所有属性
    NSArray *searchResultArray = nil;
    searchResultArray = [BannerModel searchWithWhere:nil orderBy:nil offset:0 count:100];
    return searchResultArray;
}

- (void)deleteRow
{
    //清空表数据  clear table data
    //    [LKDBHelper clearTableData:[UserModel class]];
    [BannerModel deleteToDB:self];
    
}

+ (void)deleteForproperty:(NSDictionary *)property
{
    ///获取 UserModel 类使用的 LKDBHelper
    LKDBHelper *globalHelper = [BannerModel getUsingLKDBHelper];
    BannerModel *user = [[BannerModel alloc] init];
    user = [globalHelper searchSingle:[BannerModel class] where:property orderBy:nil];
    BOOL ishas = [globalHelper isExistsModel:user];
    if (ishas) {
        [globalHelper deleteToDB:user];
    }
}

@end
