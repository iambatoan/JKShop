//
//  JKProduct.m
//  JKShop
//
//  Created by admin on 12/1/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKProduct.h"

@implementation JKProduct
+ (JKProduct *)productWithDictionary:(NSDictionary *)dictionary
{
    // look for the core data first
    JKProduct *product = [[JKProduct MR_findByAttribute:@"product_id" withValue:dictionary[@"id"]] lastObject];
    
    if (product)
        return product;
    
    if (!product && ![dictionary[@"name"] isKindOfClass:[NSNull class]]) {
        product = [JKProduct MR_createEntity];
        product.product_id = [NSNumber numberWithInt:[dictionary[@"id"] intValue]];
        product.color = dictionary[@"color"];
        product.product_code = [NSString stringWithFormat:@"%@",dictionary[@"sku"]];
        product.detail = [dictionary[@"description"] stringByDecodingHTMLEntities];
        product.name = [dictionary[@"name"] stringByDecodingHTMLEntities];
        product.price = dictionary[@"price"];
        product.sale_price = dictionary[@"sale_price"];
        product.size = dictionary[@"size"];
        product.stock = dictionary[@"stock"];
        product.stock_status = dictionary[@"stock_status"];
        for (int i = 0; i < [dictionary[@"images"] count]; i++) {
            [product.imagesSet addObject:[JKProductImages productImagesWithArray:[dictionary[@"images"] objectAtIndex:i] productID:(NSInteger)[NSNumber numberWithInt:[dictionary[@"id"] intValue]]]];
        }
    }
    return product;
}

+ (JKProduct *)productWithDictionary:(NSDictionary *)dictionary category:(JKCategory*)category{
    JKProduct *product = [JKProduct productWithDictionary:dictionary];
    if (![product.categorySet containsObject:category]) {
        [product.categorySet addObject:category];
    }
    return product;
}

- (NSInteger)getProductId{
    return [self.product_id integerValue];
}

- (NSString *)getProductName{
    return self.name;
}

- (NSSet *)getImageSet{
    return self.images;
}

- (NSString *)getProductPrice{
    return self.price;
}

- (NSString *)getProductDetail{
    return self.detail;
}

- (NSString *)getProductSKU{
    return self.product_code;
}

+ (NSInteger)getProductPriceWithProductId:(NSString *)productId{
    return [[[[JKProduct MR_findByAttribute:@"product_id" withValue:productId] lastObject] getProductPrice] integerValue];
}

@end
