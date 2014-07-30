//
//  AFHTTPRequestOperationManager+CustomManager.m
//  JKShop
//
//  Created by iSlan on 7/29/14.
//  Copyright (c) 2014 Nguyễn Bá Toàn. All rights reserved.
//

#import "AFHTTPRequestOperationManager+CustomManager.h"

@implementation AFHTTPRequestOperationManager (CustomManager)

+ (instancetype)shareManager {
    static AFHTTPRequestOperationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:API_SERVER_HOST]];
    });
    return manager;
}

+ (instancetype)JK_manager {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    return manager;
}

@end
