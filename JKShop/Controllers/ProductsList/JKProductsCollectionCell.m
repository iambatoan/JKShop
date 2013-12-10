//
//  JKProductsCollectionCell.m
//  JKShop
//
//  Created by Toan Slan on 12/2/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKProductsCollectionCell.h"

@interface JKProductsCollectionCell()

@property (weak, nonatomic) IBOutlet UIImageView            * productImageView;
@property (weak, nonatomic) IBOutlet UILabel                * productName;
@property (weak, nonatomic) IBOutlet UILabel                * productPrice;

@end

@implementation JKProductsCollectionCell

- (void)customProductCellWithProduct:(JKProduct *)aProduct{
    [self.productImageView setImageWithURL:[NSURL URLWithString:[[aProduct.images anyObject] getMediumImageURL]]];
    self.productName.text = aProduct.name;
    [self.productName setFont:[UIFont fontWithName:@"Lato" size:14]];
    [self.productName setTextColor:[UIColor titleColor]];
    self.productPrice.text = [NSString stringWithFormat:@"%d,000 VNĐ",[aProduct.price intValue]/1000 > 0 ? [aProduct.price intValue]/1000 : [aProduct.price intValue]];
}

@end
