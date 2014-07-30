//
//  JKGMSService.m
//  JKShop
//
//  Created by iSlan on 7/30/14.
//  Copyright (c) 2014 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKGMSService.h"

static NSString * const JKGoogleMapApiKey = @"AIzaSyB9WLInu2QhsVM8X0KQGW0mnNZJqvXgZsE";

@implementation JKGMSService

+ (instancetype)GMSService
{
    return [[JKGMSService alloc] init];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GMSServices provideAPIKey:JKGoogleMapApiKey];
    return YES;
}

@end
