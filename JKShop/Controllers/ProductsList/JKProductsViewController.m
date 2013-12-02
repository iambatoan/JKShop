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
        if ([obj isKindOfClass:[NSDictionary class]] && obj[@"products"]) {
            [self.productsArr setArray:(NSArray *)obj[@"products"]];
        }else
        {
            self.productsArr = obj;
        }
        
        [self.collectionProducts reloadData];
    } failure:^(NSInteger statusCode, id obj) {
        //Handle when failure
        [SVProgressHUD showErrorWithStatus:@"Xin vui lòng kiểm tra kết nối mạng và thử lại"];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.productsArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"JKProductsCollectionCell";
    JKProductsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (![[self.productsArr firstObject] isKindOfClass:[JKProduct class]]) {
        JKProduct *product = [JKProduct productWithDictionary:[self.productsArr objectAtIndex:indexPath.item]];
        product.category_id = [NSString stringWithFormat:@"%d",self.category_id];
        [cell customProductCellWithProduct:product];
    }
    else{
        [cell customProductCellWithProduct:[self.productsArr objectAtIndex:indexPath.item]];
    }
    return cell;
}


@end
