//
//  JKHTTPClient.h
//  JKShop
//
//  Created by admin on 11/30/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "AFHTTPClient.h"

typedef void (^JKJSONRequestSuccessBlock) (NSInteger statusCode, NSArray *productArray);
typedef void (^JKJSONRequestImageSuccessBlock) (NSInteger statusCode, NSSet *productImageSet);
typedef void (^JKJSONRequestFailureBlock) (NSInteger statusCode, id obj);

typedef void (^JKRequestSuccessBlock) (NSInteger statusCode, id obj);
typedef void (^JKRequestFailureBlock) (NSInteger statusCode, id obj);

typedef void (^JKRequestProgressBLock) (NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile);

@interface JKHTTPClient : AFHTTPClient

+ (instancetype)sharedClient;

@end
