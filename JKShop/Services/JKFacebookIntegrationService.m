//
//  JKFacebookIntegrationService.m
//  JKShop
//
//  Created by iSlan on 7/30/14.
//  Copyright (c) 2014 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKFacebookIntegrationService.h"

@implementation JKFacebookIntegrationService

+ (instancetype)facebookService {
    static JKFacebookIntegrationService *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[JKFacebookIntegrationService alloc] init];
    });
    return service;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[FacebookManager sharedInstance] openSessionWithAllowLoginUI:NO];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[FBSession activeSession] close];
}

@end
