//
//  JKProductImages.h
//  JKShop
//
//  Created by admin on 12/1/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "_JKProductImages.h"
#import "JKHTTPClient.h"

@interface JKProductImages : _JKProductImages

+ (void)getImagesForProduct:(NSInteger)product_id
               successBlock:(JKJSONRequestSuccessBlock)successBlock
               failureBlock:(JKJSONRequestFailureBlock)failureBlock;

@end
