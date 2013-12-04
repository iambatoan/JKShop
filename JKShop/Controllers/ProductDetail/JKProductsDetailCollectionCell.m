//
//  JKProductsDetailCollectionCell.m
//  JKShop
//
//  Created by Toan Slan on 12/4/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKProductsDetailCollectionCell.h"

@implementation JKProductsDetailCollectionCell

- (void)customProductsDetailCellWithProductImage:(JKProductImages *)productImage{
    [self.productImageView setImageWithURL:[NSURL URLWithString:[productImage getLargeImageURL]]];
}

@end
