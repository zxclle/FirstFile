//
//  Tool.h
//
//  Created by wuyiguang on 16/2/17.
//  Copyright (c) 2016年 YG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface Tool : NSObject

/** 纯文本提示 */
+ (MBProgressHUD *)HUDText:(NSString *)message;

/** 带菊花提示 */
+ (MBProgressHUD *)HUDIndicatView:(NSString *)message;

@end
