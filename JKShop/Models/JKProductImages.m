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
//    [img setImageURL:stringURL];
    return img;
}

+ (void)getImagesForProduct:(NSInteger)product_id
               successBlock:(JKJSONRequestSuccessBlock)successBlock
               failureBlock:(JKJSONRequestFailureBlock)failureBlock{
    NSDictionary *params = @{@"product_id": [NSNumber numberWithInteger:product_id]};
    
    [[JKHTTPClient sharedClient] getPath:[NSString stringWithFormat:@"%@%@",API_SERVER_HOST,API_GET_PRODUCT_BY_PRODUCT_ID] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *setOfImage = (NSArray *)[[responseObject[@"products"] firstObject] objectForKey:@"images"];
        JKProduct *storedProduct = [[JKProduct MR_findByAttribute:@"product_id" withValue:[NSNumber numberWithInteger:product_id]] lastObject];
        NSArray *arrTmpImages = [[NSArray alloc] init];
        NSMutableArray *arrImages = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [setOfImage count]; i++) {
             arrTmpImages = [setOfImage[i] copy];
            for (int j = 0; j < [arrTmpImages count]; j++) {
                [arrImages addObject:[JKProductImages productImagesWithArray:arrTmpImages]];
            }
        }
        
        storedProduct.images = [NSSet setWithArray:arrImages];
        
        NSManagedObjectContext *mainContext = [NSManagedObjectContext MR_defaultContext];
        [mainContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
            DLog(@"Finish save to magical record");
        }];
        
        successBlock(operation.response.statusCode, arrImages);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        JKProduct *storedProduct = [[JKProduct MR_findByAttribute:@"product_id" withValue:[NSNumber numberWithInteger:product_id]] lastObject];
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
