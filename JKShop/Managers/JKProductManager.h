//
//  JKProductManager.h
//  JKShop
//
//  Created by admin on 12/1/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "BaseManager.h"

@interface JKProductManager : BaseManager

- (void)getProductsWithCategoryID:(NSInteger)category_id
                        onSuccess:(JKJSONRequestSuccessBlock)successBlock
                          failure:(JKJSONRequestFailureBlock)failureBlock;

- (NSArray *)getStoredProductsWithCategoryId:(NSInteger)category_id;

- (NSMutableArray *)getBookmarkProducts;
- (BOOL)isBookmarkedAlreadyWithProductID:(NSNumber *)productID;
- (void)removeBookmarkProductWithProductID:(NSNumber *)productID;

- (void)bookmarkProductWithProductID:(NSNumber *)productID;
- (void)bookmarkProductWithProductID:(NSNumber *)productID withNumber:(NSInteger)number;
- (void)updateProductWithProductID:(NSNumber *)productID withNumber:(NSInteger)number;
+ (NSInteger)getAllBookmarkProductCount;
+ (void)removeAllBookmarkProduct;

@end
