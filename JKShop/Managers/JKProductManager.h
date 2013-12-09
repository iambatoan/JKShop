//
//  JKProductManager.h
//  JKShop
//
//  Created by admin on 12/1/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "BaseManager.h"
#import "JKHTTPClient.h"

@interface JKProductManager : BaseManager

- (void)getProductsWithCategoryID:(NSInteger)category_id
                        onSuccess:(JKJSONRequestSuccessBlock)successBlock
                          failure:(JKJSONRequestFailureBlock)failureBlock;

- (NSArray *)getStoredProductsWithCategoryId:(NSInteger)category_id;

@end
