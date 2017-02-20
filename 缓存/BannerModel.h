//
//  BannerModel.h
//  网络考试题_家居
//
//  Created by wuyiguang on 16/2/18.
//  Copyright (c) 2016年 YG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BannerModel.h"
#import "LKDBHelper.h"

#import "MJExtension.h"
@interface BannerModel : NSObject

//#import "JSONModel.h"
//@interface BannerModel : JSONModel

@property (nonatomic, strong) NSString *imageurl;
@property (nonatomic, strong) NSString *title;
@property (nonatomic,strong) NSString *target_id;

+ (instancetype)instanceObj:(id)obj;

+ (BannerModel *)getUserInfoFromDBkey:(id)key obj:(id)obj;

//查询单列
+ (NSArray *)searchSingleWhithProperty:(NSString *)property;

//查询多列
+ (NSArray *)searchLinesWhithPropertyA:(NSString *)a
                             PropertyB:(NSString *)b;

//查询所有
+ (NSArray *)searchAll;

//删除所有属性
- (void)deleteRow;

//删除单个属性
+ (void)deleteForproperty:(NSDictionary *)property;
@end
