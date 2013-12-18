//
//  JKReachabilityManager.m
//  JKShop
//
//  Created by admin on 12/18/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKReachabilityManager.h"

#import "Reachability.h"

@implementation JKReachabilityManager

SINGLETON_MACRO

+ (BOOL)isReachable {
    return [[[JKReachabilityManager sharedInstance] reachability] isReachable];
}

+ (BOOL)isUnreachable {
    return ![[[JKReachabilityManager sharedInstance] reachability] isReachable];
}

+ (BOOL)isReachableViaWWAN {
    return [[[JKReachabilityManager sharedInstance] reachability] isReachableViaWWAN];
}

+ (BOOL)isReachableViaWiFi {
    return [[[JKReachabilityManager sharedInstance] reachability] isReachableViaWiFi];
}

- (id)init {
    self = [super init];
    
    if (self) {
        // Initialize Reachability
        self.reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
        self.lastState = 1;
        // Start Monitoring
        [self.reachability startNotifier];
    }
    
    return self;
}

@end
