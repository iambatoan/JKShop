//
//  JKSearchProductCell.m
//  JKShop
//
//  Created by Toan Slan on 12/5/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKSearchProductCell.h"

@interface JKSearchProductCell()

@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *productPrice;
@property (weak, nonatomic) IBOutlet UILabel *productCode;


@end

@implementation JKSearchProductCell

- (void)customCellWithProduct:(JKProduct *)product{
    
    // product name
    self.productName.text = product.name;
    [self.productName setFont:[UIFont fontWithName:@"Lato" size:20]];
    [self.productName setTextColor:[UIColor titleColor]];
    
    if ([[product.images anyObject] getSmallImageURL]) {
        [self.productImage setImageWithURL:[NSURL URLWithString:[[product.images anyObject] getSmallImageURL]]];
    }
    
    self.productPrice.text = [NSString stringWithFormat:@"%@ VNĐ",product.price];
    self.productCode.text = [NSString stringWithFormat:@"Mã sản phẩm: %@",product.product_code];
}

+ (CGFloat)getHeight{
    return 128;
}

@end
