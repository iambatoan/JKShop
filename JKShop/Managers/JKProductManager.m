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
        
        [[JKProductManager sharedInstance] productsFromReponseObject:responseObject[@"products"]];
        
        if (successBlock) {
            successBlock(operation.response.statusCode, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSArray *arr = [self getStoredProductsWithCategoryId:category_id];
        if (arr.count > 0) {
            successBlock(operation.response.statusCode, arr);
            return;
        }
        
        if (failureBlock) {
            failureBlock(operation.response.statusCode, error);
        }
    }];
    
    
}

- (NSArray *)getStoredProductsWithCategoryId:(NSInteger)category_id
{
    NSNumber *catID = @(category_id);
    NSArray *arrProducts = [[NSArray alloc] init];
    
    // if new arrived
    if (category_id == 21) {
        arrProducts = [JKProduct MR_findAllSortedBy:@"public_date" ascending:NO];
        return arrProducts;
    }
    
    arrProducts = [JKProduct MR_findByAttribute:@"category_id" withValue:catID];
    return arrProducts;
}


#pragma mark - Helpers

- (void)productsFromReponseObject:(id)responseObject
{
    NSMutableArray *arrProduct = [[NSMutableArray alloc] init];
    
    NSBlockOperation *saveInBackground = [NSBlockOperation blockOperationWithBlock:^{
        [responseObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            JKProduct *product;
            product = [JKProduct productWithDictionary:obj];
            [arrProduct addObject:product];
        }];
    }];
    
    [saveInBackground setCompletionBlock:^{
        NSManagedObjectContext *mainContext  = [NSManagedObjectContext MR_defaultContext];
        [mainContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
            DLog(@"Finish save to magical record");
        }];
    }];
    
    [saveInBackground start];
}



@end
