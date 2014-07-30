//
//  BaseAppDelegate.m
//  JKShop
//
//  Created by iSlan on 7/30/14.
//  Copyright (c) 2014 Nguyễn Bá Toàn. All rights reserved.
//

#import "BaseAppDelegate.h"

@implementation BaseAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    id <UIApplicationDelegate> service;
    for (service in self.services) {
        if ([service respondsToSelector:@selector(application:didFinishLaunchingWithOptions:)]) {
            [service application:application didFinishLaunchingWithOptions:launchOptions];
        }
    }
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    id <UIApplicationDelegate> service;
    for (service in self.services) {
        if ([service respondsToSelector:@selector(applicationDidBecomeActive:)]) {
            [service applicationDidBecomeActive:application];
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    id <UIApplicationDelegate> service;
    for (service in self.services) {
        if ([service respondsToSelector:@selector(applicationWillTerminate:)]) {
            [service applicationWillTerminate:application];
        }
    }
}

 - (void)applicationDidEnterBackground:(UIApplication *)application
{
    id <UIApplicationDelegate> service;
    for (service in self.services) {
        if ([service respondsToSelector:@selector(applicationDidEnterBackground:)]) {
            [service applicationDidEnterBackground:application];
        }
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    id <UIApplicationDelegate> service;
    for (service in self.services) {
        if ([service respondsToSelector:@selector(application:openURL:sourceApplication:annotation:)]) {
            [service application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
        }
    }
    return YES;
}

@end
