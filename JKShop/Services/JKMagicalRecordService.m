//
//  JKMagicalRecordService.m
//  JKShop
//
//  Created by iSlan on 7/30/14.
//  Copyright (c) 2014 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKMagicalRecordService.h"

@implementation JKMagicalRecordService

+ (instancetype)magicalRecordService {
    return [[JKMagicalRecordService alloc] init];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [MagicalRecord setupCoreDataStack];
    return YES;
}

@end
