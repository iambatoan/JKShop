//
//  JKProduct.h
//  JKShop
//
//  Created by admin on 12/1/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "_JKProduct.h"
#import "JKProductImages.h"

@interface JKProduct : _JKProduct

+ (JKProduct *)productWithDictionary:(NSDictionary *)dictionary;
+ (JKProduct *)productWithDictionary:(NSDictionary *)dictionary category:(JKCategory*)category;
- (NSInteger)getProductId;
- (NSString *)getProductName;
- (NSSet *)getImageSet;
- (NSString *)getProductSKU;
- (NSString *)getProductDetail;
- (NSString *)getProductPrice;
+ (NSInteger)getProductPriceWithProductId:(NSString *)productId;

@end
