//
//  JKProductImages.m
//  JKShop
//
//  Created by admin on 12/1/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKProductImages.h"

@implementation JKProductImages

+ (JKProductImages *)productImagesWithArray:(NSArray *)array productID:(NSInteger)productID
{
    JKProductImages *img = [JKProductImages MR_createEntity];
    img.product_id = [NSNumber numberWithInt:productID];
    if (array.count == 3) {
        img.small_URL = array[0];
        img.medium_URL = array[1];
        img.large_URL = array[2];
        return img;
    }
    if (array.count == 2) {
        img.small_URL = array[0];
        img.medium_URL = array[1];
        return img;
    }
    img.small_URL = array[0];
    return img;
}

+ (void)getImagesForProduct:(NSInteger)product_id
               successBlock:(JKJSONRequestImageSuccessBlock)successBlock
               failureBlock:(JKJSONRequestFailureBlock)failureBlock{
    
    JKProduct *storedProduct = [[JKProduct MR_findByAttribute:@"product_id" withValue:@(product_id)] lastObject];
    if(storedProduct){
        if (successBlock) {
            successBlock(200, [storedProduct getImageSet]);
        }
        return;
    }
    [SVProgressHUD showWithStatus:@"Đang tải chi tiết sản phẩm" maskType:SVProgressHUDMaskTypeGradient];
    
    NSDictionary *params = @{@"product_id": [NSNumber numberWithInteger:product_id]};
    NSString *path = [NSString stringWithFormat:@"%@%@",API_SERVER_HOST,API_GET_PRODUCT_BY_PRODUCT_ID];
    
    [[AFHTTPRequestOperationManager JK_manager] GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *setOfImage = (NSArray *)[[responseObject[@"products"] firstObject] objectForKey:@"images"];
        NSArray *arrImages = [[NSArray alloc] init];
        NSMutableArray *arrTmp = [[NSMutableArray alloc] init];
        for (int i = 0; i < [setOfImage count]; i++) {
            arrImages = [setOfImage[i] copy];
            [arrTmp addObject:[JKProductImages productImagesWithArray:arrImages productID:product_id]];
        }
        storedProduct.images = [NSSet setWithArray:arrTmp];
        NSManagedObjectContext *mainContext = [NSManagedObjectContext MR_defaultContext];
        [mainContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
            DLog(@"Finish save to magical record");
        }];
        if (successBlock) {
            successBlock(operation.response.statusCode, [storedProduct getImageSet]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        JKProduct *storedProduct = [[JKProduct MR_findByAttribute:@"product_id" withValue:@(product_id)] lastObject];
        if (storedProduct.images.count > 0) {
            if (successBlock) {
                successBlock(operation.response.statusCode, [NSSet setWithArray:[storedProduct.images allObjects]]);
            }
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

- (NSString *)getSmallImageURL{
    return self.small_URL;
}

- (NSString *)getMediumImageURL{
    return self.medium_URL;
}

- (NSString *)getLargeImageURL{
    return self.large_URL;
}

@end
