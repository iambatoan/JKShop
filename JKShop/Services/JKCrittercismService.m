//
//  JKCrittercismService.m
//  JKShop
//
//  Created by iSlan on 7/30/14.
//  Copyright (c) 2014 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKCrittercismService.h"

static NSString * const CrittercismAppID = @"52ab2ef997c8f22bfe000002";

@implementation JKCrittercismService

+ (instancetype)crittercismService
{
    return [[JKCrittercismService alloc] init];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Crittercism enableWithAppID:CrittercismAppID];
    return YES;
}

@end
