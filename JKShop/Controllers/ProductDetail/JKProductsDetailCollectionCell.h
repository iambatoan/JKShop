//
//  JKProductsDetailCollectionCell.h
//  JKShop
//
//  Created by Toan Slan on 12/4/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKProductsDetailCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
- (void)customProductsDetailCellWithProductImage:(JKProductImages *)productImage;

@end
