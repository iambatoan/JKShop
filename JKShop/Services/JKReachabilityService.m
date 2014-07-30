//
//  JKReachabilityService.m
//  JKShop
//
//  Created by iSlan on 7/30/14.
//  Copyright (c) 2014 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKReachabilityService.h"

@implementation JKReachabilityService

+ (instancetype)reachabilityService
{
    static JKReachabilityService *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[JKReachabilityService alloc] init];
    });
    return service;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status < 1) {
            [self handleUnreachable];
        }
    }];
    return YES;
}

- (void)handleUnreachable {
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Thông Báo" andMessage:@"Không thể kết nối với Internet. Vui lòng thử lại sau!"];
    [alertView addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeCancel handler:nil
     ];
    
    [alertView show];
}

@end
