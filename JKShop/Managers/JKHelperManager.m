//
//  JKHelperManager.m
//  JKShop
//
//  Created by admin on 11/30/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKHelperManager.h"

@implementation JKHelperManager

SINGLETON_MACRO

- (void)getMenuListOnComplete:(void(^)(NSArray *menu))complete orFailure:(void(^)(NSError *error))failure{
    NSString *path = API_SERVER_HOST;
    NSDictionary *params = @{ @"rquest" : @"getMenu" };
    [[JKHTTPClient sharedClient] getPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self storeMenuList:responseObject];
        NSArray *menuList = [self getMenuList];
        
        //Handle success
        if (complete) {
            complete(menuList);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //Handle failure
        
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

- (void)storeMenuList:(id)menuList
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:menuList forKey:MENU_LIST_USERDEFAULT];
    [userDefault synchronize];
}

- (NSArray *)getMenuList
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:MENU_LIST_USERDEFAULT];
}

@end
