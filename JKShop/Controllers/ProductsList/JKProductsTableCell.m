//
//  JKProductsTableCell.m
//  JKShop
//
//  Created by admin on 12/1/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKProductsTableCell.h"

@interface JKProductsTableCell()

@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *productPrice;

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;

@end

@implementation JKProductsTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = (JKProductsTableCell *)[[[NSBundle mainBundle] loadNibNamed:@"JKProductsTableCell" owner:self options:nil] objectAtIndex:0];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma marks Custom Product Cell

- (void)customProductCellWithProduct:(JKProduct *)aProduct
{
    self.productName.text = aProduct.name;
    self.productPrice.text = aProduct.price;
    
//    self.productDetails.text = [NSString stringWithFormat:@"Màu: %@ \nChất liệu: %@", aProduct.colors, aProduct.material];
//    [self.productDetails sizeToFitKeepWidth];
//    
//    NSString *imgUrl = [NSString stringWithFormat:@"http://orangefashion.vn/store/%@/%@_small.jpg", aProduct.product_id, aProduct.product_id];
//    
//    [self.productCoverImage setImageWithURL:[[NSURL alloc] initWithString:imgUrl]];
//    [self.productImageView setImageWithURL:[NSURL URLWithString:[[aProduct.imageMutableArray firstObject] imageLarge]]];
    
}

@end
