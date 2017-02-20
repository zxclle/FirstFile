//
//  HttpRequest.h
//
//  Created by wuyiguang on 16/2/17.
//  Copyright (c) 2016年 YG. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "Interface.h"

typedef void(^Completion)(id jsonObj);
typedef void(^Faild)(NSError *error);

@interface HttpRequest : NSObject

/** GET请求数据 */
+ (void)GET:(NSString *)url params:(id)params completion:(Completion)completion faild:(Faild)faild;

@end
