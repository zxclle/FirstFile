//
//  NetworkState.h
//  Gift
//
//  Created by mac on 16/3/11.
//  Copyright (c) 2016年 LE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkState : NSObject
+ (instancetype)shared;

- (void)networkState;

- (void)monitorNetworkStatus;

- (void)getNetWorkStates;
@end
