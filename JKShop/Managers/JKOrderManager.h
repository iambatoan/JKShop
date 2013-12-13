//
//  JKOrderManager.h
//  JKShop
//
//  Created by Toan Slan on 12/12/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "BaseManager.h"

@interface JKOrderManager : BaseManager

- (void)createOrderOnSuccess:(JKJSONRequestSuccessBlock)successBlock
                   onFailure:(JKJSONRequestFailureBlock)failureBlock;

@end
