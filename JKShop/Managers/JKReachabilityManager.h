//
//  JKReachabilityManager.h
//  JKShop
//
//  Created by admin on 12/18/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "BaseManager.h"

@interface JKReachabilityManager : BaseManager

@property (strong, nonatomic) Reachability *reachability;
@property (assign, nonatomic) NSInteger lastState;


+ (BOOL)isReachable;
+ (BOOL)isUnreachable;
+ (BOOL)isReachableViaWWAN;
+ (BOOL)isReachableViaWiFi;

@end
