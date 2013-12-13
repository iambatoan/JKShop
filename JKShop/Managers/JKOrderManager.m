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
        [[JKHTTPClient sharedClient] postPath:[NSString stringWithFormat:@"%@%@", API_SERVER_HOST, API_GET_NONCE]
                                   parameters:param
                                      success:^(AFHTTPRequestOperation *operation, id response)
        {
            successBlock(operation.response.statusCode, response);
        }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            failureBlock(operation.response.statusCode, error);
        }];
    }
                                             onFailure:^(NSInteger statusCode, NSError *error)
    {
        failureBlock(statusCode, error);
    
    }];
}

- (void)getNonceOnSuccess:(JKJSONRequestNonceSuccessBlock)successBlock
                onFailure:(JKJSONRequestFailureBlock)failureBlock
{
    NSDictionary *param = @{@"controller": @"products",
                            @"method": @"create_order"};
    
    [[JKHTTPClient sharedClient] getPath:[NSString stringWithFormat:@"%@%@", API_SERVER_HOST, API_GET_NONCE]
                              parameters:param
                                 success:^(AFHTTPRequestOperation *operation, id response)
    {
        successBlock(operation.response.statusCode,response[@"nonce"]);
    }
                                 failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        failureBlock(operation.response.statusCode,error);
    }];
}

                        
@end
