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
@property (weak, nonatomic) IBOutlet UIImageView        * noImageCover;

@end

@implementation JKProductsViewController

#pragma mark - View controller lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = DEFAULT_NAVIGATION_TITLE;
    self.viewDeckController.centerController.title = DEFAULT_NAVIGATION_TITLE;
    if (![self.lblTitle isEqualToString:@""]) {
        self.title = self.lblTitle;
    }
    
    self.productsArr = [[NSMutableArray alloc] init];
    self.productsArr = [[[JKProductManager sharedInstance] getStoredProductsWithCategoryId:self.category_id] mutableCopy];
    if (!self.productsArr.count)
    {
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeGradient];
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

#pragma mark - Collection view datasource

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
    JKNavigationViewController *centralNavVC = (JKNavigationViewController *) self.viewDeckController.centerController;
    
    JKProductDetailViewController *productDetailVC = [[JKProductDetailViewController alloc] init];
    productDetailVC.product = [self.productsArr objectAtIndex:indexPath.item];
    
    [centralNavVC pushViewController:productDetailVC animated:YES];
}

#pragma mark - Helper method

- (void)fillUpTableProductWithCategoryID:(NSInteger)categoryID
{
    if (self.category_id == 21) {
        return;
    }
    [[JKProductManager sharedInstance] getProductsWithCategoryID:categoryID onSuccess:^(NSInteger statusCode, NSArray *arrayProducts) {
        self.productsArr = [arrayProducts mutableCopy];
        for (JKProduct *product in arrayProducts) {
            if (![[[product getImageSet] anyObject] getMediumImageURL]) {
                [self.productsArr removeObject:product];
            }
        }
        
        [SVProgressHUD dismiss];
        if (!self.productsArr.count) {
            [self.noImageCover setHidden:NO];
        }
        [self.collectionProducts reloadData];
        
        
    } failure:^(NSInteger statusCode, id obj) {
        [SVProgressHUD showErrorWithStatus:@"Please check connection and try again"];
    }];
}

- (void)refresh{
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeGradient];
    [self fillUpTableProductWithCategoryID:self.category_id];
    [self.refreshControl endRefreshing];
}

- (void)reachabilityDidChange:(NSNotification *)notification{
//    if ([JKReachabilityManager isReachable]) {
//        if (![JKReachabilityManager sharedInstance].lastState) {
//            [TSMessage showNotificationInViewController:self
//                                                  title:@"Connecting.."
//                                                   type:TSMessageNotificationTypeMessage
//                                               duration:2
//                                             atPosition:TSMessageNotificationPositionBottom];
//            
//            [TSMessage showNotificationInViewController:self
//                                                  title:@"Connected"
//                                                   type:TSMessageNotificationTypeSuccess
//                                               duration:1
//                                             atPosition:TSMessageNotificationPositionBottom];
//        }
//        [self fillUpTableProductWithCategoryID:self.category_id];
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
