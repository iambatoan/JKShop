//
//  JKAppDelegate.m
//  JKShop
//
//  Created by admin on 11/30/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKAppDelegate.h"

@implementation JKAppDelegate
@synthesize services = _services;

- (NSArray *)services {
    //Note: Order matters
    if (!_services) {
        _services = @[[JKMagicalRecordService magicalRecordService],
                      [JKGMSService GMSService],
                      [JKGAIService GAIService],
                      [JKFacebookIntegrationService facebookService],
                      [JKCrittercismService crittercismService],
                      [JKGiftService giftService],
                      [JKReachabilityService reachabilityService],
                      [JKLoadMainWindowService loadMainWindowService],
                      [JKCoreDataService coreDataService]];
    }
    
    return _services;
}

@end
