//
//  NetworkState.m
//  Gift
//
//  Created by mac on 16/3/11.
//  Copyright (c) 2016年 LE. All rights reserved.
//

#import "NetworkState.h"
#import "AFNetworking.h"
#import "Tool.h"

#import "Reachability.h"
static NetworkState *singleton = nil;

@implementation NetworkState

+ (instancetype)shared
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        singleton = [[self alloc] init];
    });
    return singleton;
}

// 监听网络状态
- (void)networkState
{
    // AF网络监听
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    // 当网络状态发送改变时调用
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        // 判断网络状态
        switch (status) {
//            case AFNetworkReachabilityStatusReachableViaWiFi:
//                NSLog(@"WIFI");
//                break;
//                
//            case AFNetworkReachabilityStatusReachableViaWWAN:
//                NSLog(@"蜂窝");
//                break;
                
            case AFNetworkReachabilityStatusNotReachable:
            case AFNetworkReachabilityStatusUnknown:
                
               // NSLog(@"没有网络");
                
                [Tool HUDText:@"当前网络不可用,请检查"];
                
                break;
                
            default:
                break;
        }
    }];
    
    // 开始监听
    [manager startMonitoring];
    
}

- (void)monitorNetworkStatus{
    
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:reach];
    [reach startNotifier];
}

- (void)reachabilityChanged:(NSNotification *)noti{
    
    Reachability *reach = noti.object;
    
    //    NetworkStatus status = [reach currentReachabilityStatus];
    //    self.isReachable = YES;
    
    if (reach.isReachableViaWiFi) {
        
        NSLog(@"WiFi!");
        //        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"NETWORKS"];
        //        [[NSUserDefaults standardUserDefaults] synchronize];
        //
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationCenterXXX" object:@(1)];
        
    } else if (reach.isReachableViaWWAN) {
        
        NSLog(@"WWAN!");
    } else{
        
        NSLog(@"UNREACHABLE!");
        [Tool HUDText:@"当前网络不可用,请检查"];
        
        //        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"NETWORKS"];
        //        [[NSUserDefaults standardUserDefaults] synchronize];
        //
        //         [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationCenterXXX" object:@(0)];
    }
    
}

// 不可靠
- (void)getNetWorkStates
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = [[NSString alloc]init];
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"] intValue];
            
            switch (netType) {
                case 0:
                    state = @"无网络";
                    [Tool HUDText:@"当前网络不可用,请检查"];
                    //无网模式
                    break;
                case 1:
                    state =  @"2G";
                    break;
                case 2:
                    state =  @"3G";
                    break;
                case 3:
                    state =   @"4G";
                    break;
                case 5:
                {
                    state =  @"wifi";
                    break;
                default:
                    break;
                }
            }
        }
    }
    NSLog(@"state=%@",state);
}
/* 基本原理是从UIApplication类型中通过valueForKey获取内部属性 statusBar。然后筛选一个内部类型UIStatusBarDataNetworkItemView），最后返回他的 dataNetworkType属性，根据状态栏获取网络状态，可以区分2G、3G、4G、WIFI，系统的方法，比较快捷，不好的是万一连接的WIFI 没有联网的话，识别不到。
 */
@end
