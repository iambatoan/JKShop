//
//  JKHelperManager.h
//  JKShop
//
//  Created by admin on 11/30/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#define MENU_LIST_USERDEFAULT       @"menu_list"

#import "BaseManager.h"

@interface JKCategoryManager : BaseManager

- (void)getMenuListOnComplete:(void(^)(NSArray *menu))complete orFailure:(void(^)(NSError *error))failure;
- (NSArray *)getMenuList;

@end