//
//  HttpRequest.m
//
//  Created by wuyiguang on 16/2/17.
//  Copyright (c) 2016年 YG. All rights reserved.
//

#import "HttpRequest.h"
#import "AFNetworking.h"

@implementation HttpRequest

+ (void)GET:(NSString *)url params:(id)params completion:(Completion)completion faild:(Faild)faild
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (completion) {
            completion(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (faild) {
            faild(error);
        }
    }];
}

@end
