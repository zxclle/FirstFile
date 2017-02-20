//
//  Tool.m
//
//  Created by wuyiguang on 16/2/17.
//  Copyright (c) 2016年 YG. All rights reserved.
//

#import "Tool.h"
#import "AppDelegate.h"

#define kAppDel ((AppDelegate *)[UIApplication sharedApplication].delegate)

@implementation Tool

+ (MBProgressHUD *)HUDText:(NSString *)message
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:kAppDel.window];
    
    [kAppDel.window addSubview:hud];
    
    hud.mode = MBProgressHUDModeText; //默认带菊花
    
    hud.removeFromSuperViewOnHide = YES;
    
    hud.dimBackground = YES;
    
    hud.labelText = message;
    
    [hud show:YES];
    
    [hud hide:YES afterDelay:1.5];
    
    return hud;
}

+ (MBProgressHUD *)HUDIndicatView:(NSString *)message
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:kAppDel.window];
    
    [kAppDel.window addSubview:hud];
    
    hud.labelText = message;
    
    hud.removeFromSuperViewOnHide = YES;
    
    [hud show:YES];
    
    return hud;
}

@end
