//
//  JKProductImages.m
//  JKShop
//
//  Created by admin on 12/1/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKProductImages.h"

@implementation JKProductImages

+ (NSArray *)productImagesWithArray:(NSArray *)array
{
    __block NSMutableArray *result = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [result addObject:[JKProductImages productImageWithURL:obj]];
    }];
    
    return [result copy];
}

+ (JKProductImages *)productImageWithURL:(NSString *)stringURL
{
    JKProductImages *img = [JKProductImages MR_createEntity];
    [img setImageURL:stringURL];
    return img;
}

+ (void)getImagesForProduct:(JKProduct *)product
               successBlock:(JKJSONRequestSuccessBlock)successBlock
               failureBlock:(JKJSONRequestFailureBlock)failureBlock{
    NSDictionary *params = @{@"product_id": product.product_id,
                             @"rquest": @"getimages"};
    
    [[JKHTTPClient sharedClient] getPath:API_SERVER_HOST parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *setOfImage = (NSArray *)responseObject;
        JKProduct *storedProduct = [[JKProduct MR_findByAttribute:@"product_id" withValue:product.product_id] lastObject];
        NSArray *arrImages =  [JKProductImages productImagesWithArray:setOfImage];
        storedProduct.images = [NSSet setWithArray:arrImages];
        
        NSManagedObjectContext *mainContext = [NSManagedObjectContext MR_defaultContext];
        [mainContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
            DLog(@"Finish save to magical record");
        }];
        
        successBlock(operation.response.statusCode, arrImages);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        JKProduct *storedProduct = [[JKProduct MR_findByAttribute:@"product_id" withValue:product.product_id] lastObject];
        if (storedProduct.images.count > 0) {
            successBlock(operation.response.statusCode, [storedProduct.images allObjects]);
        }
        else{
            //Handler when no internet
            DLog(@"%@", [error description]);
            if (failureBlock) {
                failureBlock(operation.response.statusCode, error);
            }
        }
    }];
    
}

@end
