//
//  JKProductsViewController.m
//  JKShop
//
//  Created by admin on 12/1/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKProductsViewController.h"
#import "JKProductManager.h"
#import "JKProductDetailViewController.h"

@interface JKProductsViewController ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
IIViewDeckControllerDelegate
>

@property (strong, nonatomic) NSMutableArray            * productsArr;
@property (assign, nonatomic) BOOL                        isSearching;
@property (strong, nonatomic) NSMutableArray            * filteredList;

@end

@implementation JKProductsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = DEFAULT_NAVIGATION_TITLE;
    if (![self.lblTitle isEqualToString:@""]) {
        self.title = self.lblTitle;
    }
    
    self.productsArr = [[NSMutableArray alloc] init];
    
    self.isSearching = NO;
    self.filteredList = [[NSMutableArray alloc] init];
    
    [SVProgressHUD showWithStatus:@"Đang tải sản phẩm" maskType:SVProgressHUDMaskTypeGradient];
    [self.collectionProducts registerNib:[UINib nibWithNibName:@"JKProductsCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"JKProductsCollectionCell"];
    [self.collectionProducts setContentInset:UIEdgeInsetsMake(45, 0, 0, 0)];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [self.collectionProducts setContentInset:UIEdgeInsetsMake(60, 0, 0, 0)];
    }
    [self fillUpTableProductWithCategoryID:self.category_id];
}


- (void)fillUpTableProductWithCategoryID:(NSInteger)categoryID
{
    [[JKProductManager sharedInstance] getProductsWithCategoryID:categoryID onSuccess:^(NSInteger statusCode, id obj) {
        [SVProgressHUD dismiss];
        
        self.productsArr = obj;
        
        [self.collectionProducts reloadData];
    } failure:^(NSInteger statusCode, id obj) {
        //Handle when failure
        [SVProgressHUD showErrorWithStatus:@"Xin vui lòng kiểm tra kết nối mạng và thử lại"];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.productsArr.count != 0) {
        self.collectionProducts.hidden = NO;
    }
    
    return self.productsArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"JKProductsCollectionCell";
    JKProductsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell customProductCellWithProduct:[self.productsArr objectAtIndex:indexPath.item]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    IIViewDeckController *deckViewController = (IIViewDeckController*)[[(JKAppDelegate*)[[UIApplication sharedApplication] delegate] window] rootViewController];
    JKNavigationViewController *centralNavVC = (JKNavigationViewController *) deckViewController.centerController;
    JKProductDetailViewController *productDetailVC = [[JKProductDetailViewController alloc] init];
    
    productDetailVC.product = [self.productsArr objectAtIndex:indexPath.item];
    
    [centralNavVC pushViewController:productDetailVC animated:YES];
    [SVProgressHUD showWithStatus:@"Đang tải chi tiết sản phẩm" maskType:SVProgressHUDMaskTypeGradient];
}


@end
