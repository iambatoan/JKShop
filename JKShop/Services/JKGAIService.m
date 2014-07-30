//
//  JKGAIService.m
//  JKShop
//
//  Created by iSlan on 7/30/14.
//  Copyright (c) 2014 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKGAIService.h"

static NSString * const JKGAIAppID = @"UA-46437583-1";

@implementation JKGAIService

+ (instancetype)GAIService {
    return [[JKGAIService alloc] init];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 20;
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    [[GAI sharedInstance] trackerWithTrackingId:JKGAIAppID];
    
    return YES;
}

@end
