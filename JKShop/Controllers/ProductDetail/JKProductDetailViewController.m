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
@property (weak, nonatomic) IBOutlet UIPageControl *imagePageControl;
@property (strong, nonatomic) NSArray *productImageArray;
@property (weak, nonatomic) IBOutlet UILabel *labelProductName;
@property (weak, nonatomic) IBOutlet UILabel *labelProductPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelProductDetail;
@property (weak, nonatomic) IBOutlet UILabel *labelProductSKU;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UILabel *labelRelatedProduct;
@property (weak, nonatomic) NSArray *productsArr;
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
    self.title = [self.product getProductName];

    self.contentScrollView.contentSize = CGSizeMake(320,1500);
    [self.contentScrollView setContentInset:UIEdgeInsetsMake(-20, 0, 0, 0)];
    [self.productCollectionView registerNib:[UINib nibWithNibName:@"JKProductsDetailCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"JKProductsDetailCollectionCell"];
//    [self.relatedProductCollection registerNib:[UINib nibWithNibName:@"JKProductsCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"JKProductsCollectionCell"];
    [self fillUpTableProductWithCategoryID:[[self.product.category anyObject] getCategoryId]];
    [self loadProductDetail];
    [self getImageFromProduct];
}

- (void)getImageFromProduct{
    [JKProductImages getImagesForProduct:[self.product getProductId] successBlock:^(NSInteger statusCode, id obj) {
        self.productImageArray = [obj allObjects];
//        [self loadScrollView];
        [self.contentScrollView setScrollEnabled:YES];
        [self.productCollectionView reloadData];
        [SVProgressHUD dismiss];
        [self.imagePageControl setNumberOfPages:[self.productImageArray count]];
    } failureBlock:^(NSInteger statusCode, id obj) {
        //Handle when failure
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
}

//- (void)loadScrollView{
//    [SVProgressHUD dismiss];
//    for (int i = 0; i < [self.productImageArray count]; i++) {
//        CGRect frame;
//        frame.origin.x = self.imageScrollView.frame.size.width * i + 2;
//        frame.origin.y = 2;
//        frame.size = CGSizeMake(self.imageScrollView.frame.size.width - 8, self.imageScrollView.frame.size.height - 6);
//        
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
//        [imageView setImageWithURL:[NSURL URLWithString:[[self.productImageArray objectAtIndex:i] getLargeImageURL]]];
//        [self.imageScrollView addSubview:imageView];
//    }
//    self.imageScrollView.contentSize = CGSizeMake(self.imageScrollView.frame.size.width * [self.productImageArray count], self.imageScrollView.frame.size.height);
//    [self.imagePageControl setNumberOfPages:[self.productImageArray count]];
//}
//
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth = self.productCollectionView.frame.size.width;
    int page = floor((self.productCollectionView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.imagePageControl.currentPage = page;
}

- (void)fillUpTableProductWithCategoryID:(NSInteger)categoryID
{
    [[JKProductManager sharedInstance] getProductsWithCategoryID:categoryID onSuccess:^(NSInteger statusCode, id obj) {
        self.productsArr = obj;
        
//        [self.relatedProductCollection reloadData];
    } failure:^(NSInteger statusCode, id obj) {
        //Handle when failure
        [SVProgressHUD showErrorWithStatus:@"Xin vui lòng kiểm tra kết nối mạng và thử lại"];
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    if (self.productsArr.count != 0) {
//        self.relatedProductCollection.hidden = NO;
//    }
//    
//    return self.productsArr.count;
    return [self.productImageArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JKProductsDetailCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JKProductsDetailCollectionCell" forIndexPath:indexPath];
    [cell customProductsDetailCellWithProductImage:[self.productImageArray objectAtIndex:indexPath.item]];
    return cell;
}

@end
