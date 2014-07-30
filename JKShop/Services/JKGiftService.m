//
//  JKGiftService.m
//  JKShop
//
//  Created by iSlan on 7/30/14.
//  Copyright (c) 2014 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKGiftService.h"

static NSString * const kTrackingDay = @"kTrackingDay";
static NSString * const kGiftUserDefault = @"kGiftUserDefault";

@implementation JKGiftService

+ (instancetype)giftService {
    return [[JKGiftService alloc] init];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if ([[NSDate date] compare:[[NSUserDefaults standardUserDefaults] valueForKey:kTrackingDay]] == NSOrderedAscending) {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kGiftUserDefault];
    }
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:kTrackingDay];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if ([[NSDate date] compare:[[NSUserDefaults standardUserDefaults] valueForKey:kTrackingDay]] == NSOrderedAscending) {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kGiftUserDefault];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:kTrackingDay];
}

@end
