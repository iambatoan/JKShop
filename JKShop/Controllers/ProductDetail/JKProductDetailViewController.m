 //
//  JKProductDetailViewController.m
//  JKShop
//
//  Created by Toan Slan on 12/3/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKProductDetailViewController.h"
#import "JKProductsDetailCollectionCell.h"
#import "JKPopup.h"

@interface JKProductDetailViewController ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UIScrollViewDelegate,
UAModalPanelDelegate,
MHFacebookImageViewerDatasource
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
@property (strong, nonatomic) IBOutlet UIView                       * separatorBreakView;

@end

@implementation JKProductDetailViewController

#pragma mark - View controller lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [self.product getProductName];
    self.viewDeckController.centerController.title = self.title;
    
    [self.productCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([JKProductsDetailCollectionCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NSStringFromClass([JKProductsDetailCollectionCell class])];
    [self.relatedProductCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([JKProductsCollectionCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NSStringFromClass([JKProductsCollectionCell class])];
    
    [self fillUpCollectionRelatedProductWithCategoryID:[[self.product.category anyObject] getCategoryId]];
    
    [self loadProductDetail];
    
    [self getImageFromProduct];
    
    
}

#pragma mark - Collection view datasource

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.relatedProductCollectionView) {
        IIViewDeckController *deckViewController = self.viewDeckController;
        JKNavigationViewController *centralNavVC = (JKNavigationViewController *) deckViewController.centerController;
        
        JKProductDetailViewController *productDetailVC = [[JKProductDetailViewController alloc] init];
        productDetailVC.product = [self.productsArr objectAtIndex:indexPath.item];
        
        [centralNavVC pushViewController:productDetailVC animated:YES];
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
        
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[[self.productImageArray objectAtIndex:indexPath.item] getLargeImageURL]]];
        [imageView setupImageViewerWithDatasource:self initialIndex:indexPath.row onOpen:nil onClose:nil];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = NO;
        
        return cell;
    }
    
    JKProductsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JKProductsCollectionCell class]) forIndexPath:indexPath];
    [cell customProductCellWithProduct:[self.productsArr objectAtIndex:indexPath.item]];
    return cell;
    
}

#pragma mark - Helper methods

- (void)getImageFromProduct{
    [JKProductImages getImagesForProduct:[self.product getProductId] successBlock:^(NSInteger statusCode, NSSet *productImageSet) {
        self.productImageArray = [productImageSet allObjects];
        [self.imagePageControl setNumberOfPages:[self.productImageArray count]];
        
        [self.contentScrollView setScrollEnabled:YES];
        [self.productCollectionView reloadData];
        
        [SVProgressHUD dismiss];
    } failureBlock:^(NSInteger statusCode, id obj) {
        [SVProgressHUD showErrorWithStatus:@"Please check connection and try again"];
    }];;
}

- (void)fillUpCollectionRelatedProductWithCategoryID:(NSInteger)categoryID
{
//    NSInteger catID = 0;
//    for (JKCategory *category in self.product.category) {
//        if ([JKCategory MR_findByAttribute:@"category_id" withValue:@([category getCategoryId])].count) {
//            catID = [category getCategoryId];
//            break;
//        }
//    }
//    self.productsArr = [[[JKProductManager sharedInstance] getStoredProductsWithCategoryId:catID] mutableCopy];
//    for (int i = 0; i < self.productsArr.count; i++) {
//        if (self.productsArr[i] == self.product)
//        {
//            [self.productsArr removeObjectAtIndex:i];
//        }
//    }
    [self showCollectionView];
}

- (void)loadProductDetail{
    self.labelProductName.text = [self.product getProductName];
    
    self.labelProductPrice.text = [NSString getVNCurrencyFormatterWithNumber:@([[self.product getProductPrice] intValue]) ];
    
    self.labelProductDetail.text = [NSString stringWithFormat:@"Detail: %@",[self.product getProductDetail]];
    [self.labelProductDetail sizeToFitKeepWidth];
    
    self.labelProductSKU.text = [NSString stringWithFormat:@"Product code: %@",[self.product getProductSKU]];
    
    [self.separatorBreakView alignBelowView:self.labelProductDetail offsetY:20 sameWidth:NO];
    
    [self.labelRelatedProduct alignBelowView:self.separatorBreakView offsetY:10 sameWidth:NO];
    [self.relatedProductCollectionView alignBelowView:self.labelRelatedProduct offsetY:10 sameWidth:NO];
    
    [self.activityIndicator alignBelowView:self.labelRelatedProduct offsetY:40 sameWidth:NO];
    self.contentScrollView.contentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width,CGRectGetMaxY([self.relatedProductCollectionView frame]));
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth = self.productCollectionView.frame.size.width;
    
    int page = floor((self.productCollectionView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.imagePageControl.currentPage = page;
}

- (void)showCollectionView
{
    if (self.productsArr.count) {
        [self.relatedProductCollectionView reloadData];
        [self.relatedProductCollectionView setHidden:NO];
        [self.activityIndicator stopAnimating];
        if (self.productsArr.count < 3) {
            [self.relatedProductCollectionView setHeight:253];
        }
        if (self.productsArr.count == 0) {
            [self.relatedProductCollectionView setHeight:0];
        }
        [SVProgressHUD dismiss];
    }
}

#pragma mark - JK popup delegate

- (IBAction)addToCartButton:(id)sender {
    if ([[JKProductManager sharedInstance] isBookmarkedAlreadyWithProductID:self.product.product_id]) {
        [SVProgressHUD showErrorWithStatus:@"Already in your cart!"];
        return;
    }
    JKPopup *modalPanel = [[JKPopup alloc] initWithFrame:self.view.bounds];
    [modalPanel loadDetailWithProduct:self.product];
    [self.navigationController.view addSubview:modalPanel];
    [modalPanel showFromPoint:[self.view center]];
}

#pragma mark - MHFacebook Image Viewer delegate

- (NSInteger) numberImagesForImageViewer:(MHFacebookImageViewer *)imageViewer {
    return self.productImageArray.count;
}

-  (NSURL*) imageURLAtIndex:(NSInteger)index imageViewer:(MHFacebookImageViewer *)imageViewer {
    return [NSURL URLWithString:[[self.productImageArray objectAtIndex:index] getLargeImageURL]];
}

- (UIImage*) imageDefaultAtIndex:(NSInteger)index imageViewer:(MHFacebookImageViewer *)imageViewer{
    return nil;
}

- (void)reachabilityDidChange:(NSNotification *)notification{

//    if ([JKReachabilityManager isReachable]) {
//        if (![JKReachabilityManager sharedInstance].lastState) {
//            [TSMessage showNotificationInViewController:self
//                                                  title:@"Connecting.."
//                                                   type:TSMessageNotificationTypeMessage
//                                               duration:2
//                                             atPosition:TSMessageNotificationPositionBottom];
//            [TSMessage showNotificationInViewController:self
//                                                  title:@"Connected"
//                                                   type:TSMessageNotificationTypeSuccess
//                                               duration:1
//                                             atPosition:TSMessageNotificationPositionBottom];
//        }
//        [self getImageFromProduct];
//        [JKReachabilityManager sharedInstance].lastState = 1;
//        return;
//    }
//    if ([JKReachabilityManager sharedInstance].lastState) {
//        [TSMessage dismissActiveNotification];
//        [TSMessage showNotificationInViewController:self
//                                              title:@"No connection"
//                                               type:TSMessageNotificationTypeError
//                                           duration:5
//                                         atPosition:TSMessageNotificationPositionBottom];
//        [JKReachabilityManager sharedInstance].lastState = 0;
//    }
}

@end
