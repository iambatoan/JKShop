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

static CGFloat const IOS_7_CONTENT_INSET = 60;
static CGFloat const IOS_6_ORIGIN_X = 8;
static CGFloat const IOS_6_ORIGIN_Y = 44;

@interface JKProductsViewController ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
IIViewDeckControllerDelegate
>

@property (strong, nonatomic) NSMutableArray            * productsArr;
@property (strong, nonatomic) UIRefreshControl          * refreshControl;

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
    self.productsArr = [[[JKProductManager sharedInstance] getStoredProductsWithCategoryId:self.category_id] mutableCopy];
    if (!self.productsArr.count)
    {
        [SVProgressHUD showWithStatus:@"Đang tải sản phẩm" maskType:SVProgressHUDMaskTypeGradient];
    }
    
    [self.collectionProducts registerNib:[UINib nibWithNibName:NSStringFromClass([JKProductsCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([JKProductsCollectionCell class])];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [self.collectionProducts setContentInset:UIEdgeInsetsMake(IOS_7_CONTENT_INSET, 0, 0, 0)];
    }
    else{
        self.collectionProducts.frame = CGRectMake(IOS_6_ORIGIN_X, IOS_6_ORIGIN_Y, CGRectGetWidth(self.collectionProducts.frame), CGRectGetHeight(self.collectionProducts.frame) - IOS_6_ORIGIN_Y);
    }
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.collectionProducts addSubview:self.refreshControl];
    
    [self fillUpTableProductWithCategoryID:self.category_id];
}


- (void)fillUpTableProductWithCategoryID:(NSInteger)categoryID
{
    [[JKProductManager sharedInstance] getProductsWithCategoryID:categoryID onSuccess:^(NSInteger statusCode, NSArray *arrayProducts) {
        self.productsArr = [arrayProducts mutableCopy];
        for (JKProduct *product in arrayProducts) {
            if (![[[product getImageSet] anyObject] getMediumImageURL]) {
                [self.productsArr removeObject:product];
            }
        }

        [SVProgressHUD dismiss];
        [self.collectionProducts reloadData];
        

    } failure:^(NSInteger statusCode, id obj) {
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
    JKProductsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JKProductsCollectionCell class]) forIndexPath:indexPath];
    [cell customProductCellWithProduct:[self.productsArr objectAtIndex:indexPath.item]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    IIViewDeckController *deckViewController = (IIViewDeckController*)[JKAppDelegate getRootViewController];
    JKNavigationViewController *centralNavVC = (JKNavigationViewController *) deckViewController.centerController;
    
    JKProductDetailViewController *productDetailVC = [[JKProductDetailViewController alloc] init];
    productDetailVC.product = [self.productsArr objectAtIndex:indexPath.item];
    
    [centralNavVC pushViewController:productDetailVC animated:YES];
}

- (void)refresh{
    [SVProgressHUD showWithStatus:@"Đang tải sản phẩm" maskType:SVProgressHUDMaskTypeGradient];
    [self fillUpTableProductWithCategoryID:self.category_id];
    [self.refreshControl endRefreshing];
}


@end
