//
//  JKProductsViewController.h
//  JKShop
//
//  Created by admin on 12/1/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString* const DEFAULT_NAVIGATION_TITLE = @"Danh sách sản phẩm";

@interface JKProductsViewController : BaseViewController
@property (assign, nonatomic) NSInteger                     category_id;
@property (strong, nonatomic) NSString                    * lblTitle;
@property (weak, nonatomic) IBOutlet UICollectionView     * collectionProducts;

- (void)reachabilityDidChange:(NSNotification *)notification;

@end
