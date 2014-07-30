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
    if (!_services) {
        _services = @[];
    }
    
    return _services;
}

@end
