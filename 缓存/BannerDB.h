//
//  BannerDB.h
//  网络考试题_家居
//
//  Created by wuyiguang on 16/2/19.
//  Copyright (c) 2016年 YG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BannerModel.h"

@interface BannerDB : NSObject

+ (BannerDB *)shared;

/**
 *  获取表中所有的数据
 *
 *  @return 返回数据库中所有的记录
 */
- (NSArray *)findAll;

/**
 *  插入数据到数据库中
 *
 *  @param models 插入的数据模型的数组
 */
- (void)insertModels:(NSArray *)models;

/**
 *  删除数据
 */
- (void)deleteAll;

@end
