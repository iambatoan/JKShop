//
//  JKBookmarkTableViewCell.m
//  JKShop
//
//  Created by admin on 12/9/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKBookmarkTableViewCell.h"

static NSString * const STORE_PRODUCT_ID            =   @"store_product_id";
static NSString * const STORE_PRODUCT_NUMBER        =   @"store_product_number";

@interface JKBookmarkTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgProductImage;
@property (weak, nonatomic) IBOutlet UILabel *lblProductName;
@property (weak, nonatomic) IBOutlet UILabel *lblProductPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblNumber;
@property (weak, nonatomic) IBOutlet UIImageView *imgProductWrapImage;
@property (strong, nonatomic) JKProduct *product;
@end

@implementation JKBookmarkTableViewCell

- (void)configWithDictionary:(NSDictionary *)dictionaryProduct
{
    
    self.product = [self getProductFromStoreBookmark:dictionaryProduct];
    self.imgProductWrapImage.layer.borderWidth = 1;
    self.imgProductWrapImage.layer.borderColor = [UIColor colorWithHexString:@"beb7a9"].CGColor;
    
    [self.imgProductImage setImageWithURL:[NSURL URLWithString:[[self.product.images anyObject] getSmallImageURL]]];
    
    self.lblProductName.text = self.product.name;
    [self.lblProductName setFont:[UIFont fontWithName:@"Lato" size:14]];
    
    [self.lblProductName sizeToFitKeepWidth];
    
    
    self.lblProductPrice.text = [NSString getVNCurrencyFormatterWithNumber:@([self.product.price intValue])];
    
    self.lblNumber.text = [NSString stringWithFormat:@"X %d", [dictionaryProduct[STORE_PRODUCT_NUMBER] integerValue]];
}
                    
- (JKProduct *)getProductFromStoreBookmark:(NSDictionary *)storeBookmark{
    return [[JKProduct MR_findByAttribute:@"product_id" withValue:[storeBookmark objectForKey:STORE_PRODUCT_ID]] lastObject];
}

+ (CGFloat)getHeight
{
    return 80;
}

@end
