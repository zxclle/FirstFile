//
//  BannModel.h
//  缓存
//
//  Created by zxc-02 on 2016/11/24.
//  Copyright © 2016年 zxc-02. All rights reserved.
//

#import "BannModel.h"
#import <Foundation/Foundation.h>
#import "LKDBHelper.h"

@interface BannModel : NSObject
@property (nonatomic, strong) NSString *imageurl;
@property (nonatomic, strong) NSString *title;
@property (nonatomic,strong) NSString *target_id;

+ (instancetype)instanceObj:(id)obj;

+ (BannModel *)getUserInfoFromDBkey:(id)key obj:(id)obj;

//查询单列
+ (NSArray *)searchSingleWhithProperty:(NSString *)property;

//查询多列
+ (NSArray *)searchLinesWhithPropertyA:(NSString *)a
                             PropertyB:(NSString *)b;

//查询所有
+ (NSArray *)searchAll;
@end
