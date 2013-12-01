//
//  JKProductManager.m
//  JKShop
//
//  Created by admin on 12/1/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKProductManager.h"

@implementation JKProductManager

SINGLETON_MACRO

#pragma mark - Get product details from server

- (void)getProductsWithCategoryID:(NSInteger)category_id onSuccess:(JKJSONRequestSuccessBlock)successBlock failure:(JKJSONRequestFailureBlock)failureBlock
{
    NSDictionary *params = @{
                             @"category_id"     : [NSNumber numberWithInteger:category_id]
                             };
    
    [[JKHTTPClient sharedClient] getPath:[NSString stringWithFormat:@"%@%@",API_SERVER_HOST,API_GET_PRODUCT_BY_CATEGORY_ID] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        [[JKProductManager sharedInstance] productsFromReponseObject:responseObject];
        
        if (successBlock) {
            successBlock(operation.response.statusCode, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
//        NSArray *arr = [self getStoredProductsWithCategoryId:category_id];
//        if (arr.count > 0) {
//            successBlock(operation.response.statusCode, arr);
//        }
//        
//        if (failureBlock) {
            failureBlock(operation.response.statusCode, error);
//        }
    }];
    
    
}






@end
