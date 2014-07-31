//
//  JKHelperManager.m
//  JKShop
//
//  Created by admin on 11/30/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKCategoryManager.h"

@implementation JKCategoryManager

SINGLETON_MACRO

- (void)getMenuListOnComplete:(void(^)(NSArray *menu))complete
                    orFailure:(void(^)(NSError *error))failure {
  NSString *path = [NSString stringWithFormat:@"%@%@",API_SERVER_HOST,API_GET_LIST_CATEGORY];
    
  [[AFHTTPRequestOperationManager JK_manager] GET:path
                                       parameters:nil
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
//      [self storeMenuList:[responseObject objectForKey:@"categories"]];
      NSArray *menuList = [self getMenuList];
      
      if (complete) {
          complete(menuList);
      }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      NSArray *menuList = [self getMenuList];
      if (complete) {
          complete(menuList);
          return;
      }
      
      if (failure) {
          failure(error);
      }
  }];
}

//- (void)storeMenuList:(id)menuList
//{
//  NSMutableArray *arrMenu = [[NSMutableArray alloc] init];
//  
//  NSBlockOperation *saveInBackground = [NSBlockOperation blockOperationWithBlock:^{
//    [menuList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//      JKCategory *category;
//      category = [JKCategory categoryWithDictionary:obj];
//      [arrMenu addObject:category];
//    }];
//  }];
//  
//  [saveInBackground setCompletionBlock:^{
//    NSManagedObjectContext *mainContext  = [NSManagedObjectContext MR_defaultContext];
//    [mainContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
//      DLog(@"Finish save to magical record");
//    }];
//  }];
//  
//  [saveInBackground start];
//}

- (NSArray *)getMenuList
{
  NSMutableArray *arrMenu = [[NSMutableArray alloc] init];
//  for (JKCategory *category in [JKCategory MR_findByAttribute:@"parent_id" withValue:@0 andOrderBy:@"category_id" ascending:YES]) {
//    if ([category.category_id isEqual:@88]) {
//      [arrMenu insertObject:category atIndex:0];
//    }
//    else{
//      [arrMenu addObject:category];
//    }
//    for (JKCategory *categoryChild in [JKCategory MR_findAll]) {
//      if ([categoryChild getParentId] == [category getCategoryId]) {
//        [arrMenu addObject:categoryChild];
//      }
//    }
//  }
  return arrMenu;
}

@end
