//
//  JKProductDetailViewController.m
//  JKShop
//
//  Created by Toan Slan on 12/3/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKProductDetailViewController.h"
#import "JKProductsDetailCollectionCell.h"

static CGFloat const IOS_7_TOP_CONTENT_INSET = -25;

@interface JKProductDetailViewController ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UIScrollViewDelegate
>

@property (strong, nonatomic) NSArray                               * productImageArray;
@property (strong, nonatomic) NSMutableArray                        * productsArr;

@property (weak, nonatomic) IBOutlet UILabel                        * labelProductName;
@property (weak, nonatomic) IBOutlet UILabel                        * labelProductPrice;
@property (weak, nonatomic) IBOutlet UILabel                        * labelProductDetail;
@property (weak, nonatomic) IBOutlet UILabel                        * labelProductSKU;
@property (weak, nonatomic) IBOutlet UILabel                        * labelRelatedProduct;
@property (weak, nonatomic) IBOutlet UIScrollView                   * contentScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl                  * imagePageControl;
@property (weak, nonatomic) IBOutlet UICollectionView               * productCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView               * relatedProductCollectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView        * activityIndicator;

@end

@implementation JKProductDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [self.product getProductName];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [self.contentScrollView setContentInset:UIEdgeInsetsMake(IOS_7_TOP_CONTENT_INSET, 0, 0, 0)];
    }
    
    [self.productCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([JKProductsDetailCollectionCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NSStringFromClass([JKProductsDetailCollectionCell class])];
    [self.relatedProductCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([JKProductsCollectionCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NSStringFromClass([JKProductsCollectionCell class])];
    
    [self fillUpTableProductWithCategoryID:[[self.product.category anyObject] getCategoryId]];
    
    [self loadProductDetail];
    
    [self getImageFromProduct];
    
    
}

- (void)getImageFromProduct{
    [JKProductImages getImagesForProduct:[self.product getProductId] successBlock:^(NSInteger statusCode, NSSet *productImageSet) {
        self.productImageArray = [productImageSet allObjects];
        [self.imagePageControl setNumberOfPages:[self.productImageArray count]];
        
        [self.contentScrollView setScrollEnabled:YES];
        [self.productCollectionView reloadData];
        
        [SVProgressHUD dismiss];
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
    
    [self.labelRelatedProduct alignBelowView:self.labelProductDetail offsetY:10 sameWidth:YES];
    
    [self.relatedProductCollectionView alignBelowView:self.labelRelatedProduct offsetY:10 sameWidth:YES];
    
    self.activityIndicator.frame = CGRectMake(CGRectGetMidX([self.relatedProductCollectionView frame]) - 10, CGRectGetMidY([self.relatedProductCollectionView frame]) - 10, 30, 30);
    
    self.contentScrollView.contentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width,CGRectGetMaxY([self.relatedProductCollectionView frame]));
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
#warning clean this code
    CGFloat pageWidth = self.productCollectionView.frame.size.width;
    
    int page = floor((self.productCollectionView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.imagePageControl.currentPage = page;
}

- (void)fillUpTableProductWithCategoryID:(NSInteger)categoryID
{
    [[JKProductManager sharedInstance] getProductsWithCategoryID:categoryID onSuccess:^(NSInteger statusCode, NSArray *productsArray) {
        self.productsArr = [[NSMutableArray alloc] init];
        for(JKProduct *product in productsArray){
            if (product != self.product) {
                [self.productsArr addObject:product];
            }
        }
        
        [self.relatedProductCollectionView reloadData];
        
        [self.activityIndicator stopAnimating];
        
    } failure:^(NSInteger statusCode, id obj) {
        [SVProgressHUD showErrorWithStatus:@"Xin vui lòng kiểm tra kết nối mạng và thử lại"];
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.relatedProductCollectionView) {
        IIViewDeckController *deckViewController = (IIViewDeckController*)[JKAppDelegate getRootViewController];
        JKNavigationViewController *centralNavVC = (JKNavigationViewController *) deckViewController.centerController;
        
        JKProductDetailViewController *productDetailVC = [[JKProductDetailViewController alloc] init];
        productDetailVC.product = [self.productsArr objectAtIndex:indexPath.item];
        
        [centralNavVC pushViewController:productDetailVC animated:YES];
        [SVProgressHUD showWithStatus:@"Đang tải chi tiết sản phẩm" maskType:SVProgressHUDMaskTypeGradient];

    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (collectionView == self.productCollectionView) {
        return [self.productImageArray count];
    }
    
    return self.productsArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.productCollectionView) {
        JKProductsDetailCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JKProductsDetailCollectionCell class]) forIndexPath:indexPath];
        [cell customProductsDetailCellWithProductImage:[self.productImageArray objectAtIndex:indexPath.item]];
        
        UIImageView *imageView = cell.productImageView;
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView setupImageViewer];
        imageView.clipsToBounds = NO;
        
        return cell;
    }
    
    JKProductsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JKProductsCollectionCell class]) forIndexPath:indexPath];
    [cell customProductCellWithProduct:[self.productsArr objectAtIndex:indexPath.item]];
    return cell;
    
}

#pragma mark - Helper methods

@end
