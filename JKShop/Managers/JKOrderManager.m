//
//  JKOrderManager.m
//  JKShop
//
//  Created by Toan Slan on 12/12/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKOrderManager.h"

@implementation JKOrderManager

SINGLETON_MACRO

- (void)createOrderOnSuccess:(JKJSONRequestSuccessBlock)successBlock
                   onFailure:(JKJSONRequestFailureBlock)failureBlock
{
    [[JKOrderManager sharedInstance] getNonceOnSuccess:^(NSInteger statusCode, NSString *nonce)
    {
         NSDictionary *param = @{@"nonce": nonce};
         NSString *path = [NSString stringWithFormat:@"%@%@", API_SERVER_HOST, API_GET_NONCE];
         [[AFHTTPRequestOperationManager JK_manager] POST:path
                                               parameters:param
                                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                      if (successBlock) {
                                                          successBlock(operation.response.statusCode, responseObject);
                                                      }
                                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                      if (failureBlock) {
                                                          failureBlock(operation.response.statusCode, error);
                                                      }
                                                  }];
    }
                                             onFailure:^(NSInteger statusCode, NSError *error)
    {
         if (failureBlock) {
             failureBlock(statusCode, error);
         }
    }];
}

- (void)getNonceOnSuccess:(JKJSONRequestNonceSuccessBlock)successBlock
                onFailure:(JKJSONRequestFailureBlock)failureBlock
{
    NSDictionary *param = @{@"controller": @"products",
                            @"method": @"create_order"};
    NSString *path = [NSString stringWithFormat:@"%@%@", API_SERVER_HOST, API_GET_NONCE];
    [[AFHTTPRequestOperationManager JK_manager] GET:path
                                         parameters:param
                                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                if (successBlock) {
                                                    successBlock(operation.response.statusCode,responseObject[@"nonce"]);
                                                }
                                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                if (failureBlock) {
                                                    failureBlock(operation.response.statusCode,error);
                                                }
                                            }];
}

                        
@end
