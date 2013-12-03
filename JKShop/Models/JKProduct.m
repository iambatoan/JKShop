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
        product.detail = dictionary[@"description"];
        product.name = dictionary[@"name"];
        product.price = dictionary[@"price"];
        product.sale_price = dictionary[@"sale_price"];
        product.size = dictionary[@"size"];
        product.stock = dictionary[@"stock"];
        product.stock_status = dictionary[@"stock_status"];
        
        NSArray *arrImages = dictionary[@"images"];
        
        NSArray *firstImage = nil;
        if (arrImages.count > 0) {
            firstImage = [arrImages objectAtIndex:0];
        }
        
        if (firstImage && firstImage.count >= 2) {
            product.cover_image = [firstImage objectAtIndex:1];
        }
    }
    return product;
}

+ (JKProduct *)productWithDictionary:(NSDictionary *)dictionary category:(JKCategory*)category{
    JKProduct *product = [JKProduct productWithDictionary:dictionary];
    [product.categorySet addObject:category];
    return product;
}

@end
