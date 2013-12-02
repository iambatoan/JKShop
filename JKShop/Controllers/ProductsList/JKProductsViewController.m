//
//  JKProductsViewController.m
//  JKShop
//
//  Created by admin on 12/1/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKProductsViewController.h"
#import "JKProductManager.h"

@interface JKProductsViewController ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
IIViewDeckControllerDelegate,
UISearchBarDelegate,
UISearchDisplayDelegate
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
    [self fillUpTableProductWithCategoryID:self.category_id];
}


- (void)fillUpTableProductWithCategoryID:(NSInteger)categoryID
{
    [[JKProductManager sharedInstance] getProductsWithCategoryID:categoryID onSuccess:^(NSInteger statusCode, id obj) {
        [SVProgressHUD dismiss];
        [self.productsArr setArray:(NSArray *)obj[@"products"]];
        [self.collectionProducts reloadData];
    } failure:^(NSInteger statusCode, id obj) {
        //Handle when failure
        [SVProgressHUD showErrorWithStatus:@"Xin vui lòng kiểm tra kết nối mạng và thử lại"];
    }];
}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    // Return the number of sections.
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    if (self.isSearching)
//        return self.filteredList.count;
//    
//    return self.productsArr.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *CellIdentifier = @"JKProductsTableCell";
//    JKProductsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if (self.isSearching && [self.filteredList count]) {
//        if ([[self.filteredList objectAtIndex:indexPath.row] isKindOfClass:[JKProduct class]]) {
//            [cell customProductCellWithProduct:[self.filteredList objectAtIndex:indexPath.row]];
//            return cell;
//        }
//    }
//    
//    // Configure the cell...
//    if ([[self.productsArr objectAtIndex:indexPath.row] isKindOfClass:[JKProduct class]]) {
//        [cell customProductCellWithProduct:[self.productsArr objectAtIndex:indexPath.row]];
//        return cell;
//    }
//    
//    JKProduct *product = [JKProduct productWithDictionary:[self.productsArr objectAtIndex:indexPath.row]];
//    product.category_id = [NSString stringWithFormat:@"%d",self.category_id];
//    [cell customProductCellWithProduct:product];
//    
//    return cell;
//}
//
//- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 295;
//}
//
//#pragma mark - Table view delegate
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    JKProductDetailsViewController *desVC = [[JKProductDetailsViewController alloc] init];
////    
////    int selectedRow = [tableView indexPathForSelectedRow].row;
////    
////    if (self.isSearching) {
////        if ([[self.filteredList objectAtIndex:selectedRow] isKindOfClass:[JKProduct class]]) {
////            JKProduct *product = [self.filteredList objectAtIndex:selectedRow];
////            desVC.productID = product.product_id;
////        }else
////        {
////            desVC.productID = [[self.filteredList objectAtIndex:selectedRow] objectForKey:@"MaSanPham"];
////        }
////    }else{
////        if ([[self.productsArr objectAtIndex:selectedRow] isKindOfClass:[JKProduct class]]) {
////            JKProduct *product = [self.productsArr objectAtIndex:selectedRow];
////            desVC.productID = product.product_id;
////        }else
////        {
////            desVC.productID = [[self.productsArr objectAtIndex:selectedRow] objectForKey:@"MaSanPham"];
////        }
////    }
////    
////    JKNavigationViewController *centralNavVC = (JKNavigationViewController *) self.viewDeckController.centerController;
////    [centralNavVC pushViewController:desVC animated:YES];
////    
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.productsArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"JKProductsCollectionCell";
    JKProductsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    JKProduct *product = [JKProduct productWithDictionary:[self.productsArr objectAtIndex:indexPath.item]];
    product.category_id = [NSString stringWithFormat:@"%d",self.category_id];
    [cell customProductCellWithProduct:product];
    
    return cell;
}


@end
