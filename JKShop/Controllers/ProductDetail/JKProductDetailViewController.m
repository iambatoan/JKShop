//
//  JKProductDetailViewController.m
//  JKShop
//
//  Created by Toan Slan on 12/3/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKProductDetailViewController.h"
#import "JKProductsDetailCollectionCell.h"

@interface JKProductDetailViewController ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UIScrollViewDelegate
>
@property (weak, nonatomic) IBOutlet UICollectionView *relatedProductCollectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *imagePageControl;
@property (strong, nonatomic) NSArray *productImageArray;
@property (weak, nonatomic) IBOutlet UILabel *labelProductName;
@property (weak, nonatomic) IBOutlet UILabel *labelProductPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelProductDetail;
@property (weak, nonatomic) IBOutlet UILabel *labelProductSKU;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UILabel *labelRelatedProduct;
@property (strong, nonatomic) NSArray *productsArr;
@property (weak, nonatomic) IBOutlet UIPageControl *relatedProductPage;
@property (weak, nonatomic) IBOutlet UICollectionView *productCollectionView;
@end

@implementation JKProductDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    self.viewDeckController.panningMode = IIViewDeckNoPanning;
    
    [self.contentScrollView setScrollEnabled:NO];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.title = [self.product getProductName];

    [self.contentScrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.productCollectionView registerNib:[UINib nibWithNibName:@"JKProductsDetailCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"JKProductsDetailCollectionCell"];
    [self.relatedProductCollectionView registerNib:[UINib nibWithNibName:@"JKProductsCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"JKProductsCollectionCell"];
    [self fillUpTableProductWithCategoryID:[[self.product.category anyObject] getCategoryId]];
    [self loadProductDetail];
    [self getImageFromProduct];
    
    
}

- (void)getImageFromProduct{
    [JKProductImages getImagesForProduct:[self.product getProductId] successBlock:^(NSInteger statusCode, id obj) {
        self.productImageArray = [obj allObjects];
        [self.contentScrollView setScrollEnabled:YES];
        [self.productCollectionView reloadData];
        [SVProgressHUD dismiss];
        self.navigationItem.leftBarButtonItem.enabled = YES;
        [self.imagePageControl setNumberOfPages:[self.productImageArray count]];
    } failureBlock:^(NSInteger statusCode, id obj) {
        [SVProgressHUD showErrorWithStatus:@"Xin vui lòng kiểm tra kết nối mạng và thử lại"];
    }];;
}

- (void)loadProductDetail{
    self.labelProductName.text = [self.product getProductName];
    self.labelProductPrice.text = [NSString stringWithFormat:@"Giá: %@ VNĐ",[self.product getProductPrice]];
    self.labelProductDetail.text = [NSString stringWithFormat:@"Chi tiết sản phẩm: %@",[self.product getProductDetail]];
    [self.labelProductDetail sizeToFitKeepWidth];
    self.labelProductSKU.text = [NSString stringWithFormat:@"Mã sản phẩm: %@",[self.product getProductSKU]];
    self.labelRelatedProduct.frame = CGRectMake(self.labelRelatedProduct.frame.origin.x, self.labelProductDetail.frame.origin.y + self.labelProductDetail.frame.size.height + 10, self.labelRelatedProduct.frame.size.width, self.labelRelatedProduct.frame.size.height);
    self.relatedProductPage.frame = CGRectMake(self.relatedProductPage.frame.origin.x, self.labelRelatedProduct.frame.origin.y + self.labelRelatedProduct.frame.size.height + 10, self.relatedProductPage.frame.size.width, self.relatedProductPage.frame.size.height);
    self.relatedProductCollectionView.frame = CGRectMake(self.relatedProductCollectionView.frame.origin.x, self.relatedProductPage.frame.origin.y + self.relatedProductPage.frame.size.height, self.relatedProductCollectionView.frame.size.width, self.relatedProductCollectionView.frame.size.height);
    self.contentScrollView.contentSize = CGSizeMake(320,CGRectGetMaxY([self.relatedProductCollectionView frame]));
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth = self.productCollectionView.frame.size.width;
    int page = floor((self.productCollectionView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.imagePageControl.currentPage = page;

    CGFloat relatedProductPageWidth = self.relatedProductCollectionView.frame.size.width;
    int relatedProductPage = floor((self.relatedProductCollectionView.contentOffset.x - relatedProductPageWidth / 2) / relatedProductPageWidth) + 1;
    self.relatedProductPage.currentPage = relatedProductPage;
}

- (void)fillUpTableProductWithCategoryID:(NSInteger)categoryID
{
    [[JKProductManager sharedInstance] getProductsWithCategoryID:categoryID onSuccess:^(NSInteger statusCode, id obj) {
        self.productsArr = obj;
        
        [self.relatedProductCollectionView reloadData];
        [self.relatedProductPage setNumberOfPages:([self.relatedProductCollectionView numberOfItemsInSection:0] + 1)/ 2];
    } failure:^(NSInteger statusCode, id obj) {
        //Handle when failure
        [SVProgressHUD showErrorWithStatus:@"Xin vui lòng kiểm tra kết nối mạng và thử lại"];
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.productCollectionView) {
        return [self.productImageArray count];
    }
    if(self.productsArr.count > 5){
        return 5;
    }
    return self.productsArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.productCollectionView) {
        JKProductsDetailCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JKProductsDetailCollectionCell" forIndexPath:indexPath];
        [cell customProductsDetailCellWithProductImage:[self.productImageArray objectAtIndex:indexPath.item]];
        return cell;
    }
    
    JKProductsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JKProductsCollectionCell" forIndexPath:indexPath];
    [cell customProductCellWithProduct:[self.productsArr objectAtIndex:indexPath.item]];
    return cell;
    
}

@end
