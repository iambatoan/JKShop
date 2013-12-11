//
//  JKBookmarkTableViewCell.m
//  JKShop
//
//  Created by admin on 12/9/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKBookmarkTableViewCell.h"

@interface JKBookmarkTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgProductImage;
@property (weak, nonatomic) IBOutlet UILabel *lblProductName;
@property (weak, nonatomic) IBOutlet UILabel *lblProductPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblNumber;
@property (weak, nonatomic) IBOutlet UIImageView *imgProductWrapImage;
@property (strong, nonatomic) JKProduct *product;
@end

@implementation JKBookmarkTableViewCell

- (void)configWithProduct:(JKProduct *)product andNumber:(NSInteger)number
{
    self.product = product;
    self.imgProductWrapImage.layer.borderWidth = 1;
    self.imgProductWrapImage.layer.borderColor = [UIColor colorWithHexString:@"beb7a9"].CGColor;
    
    [self.imgProductImage setImageWithURL:[NSURL URLWithString:[[product.images anyObject] getSmallImageURL]]];
    
    self.lblProductName.text = product.name;
    [self.lblProductName setFont:[UIFont fontWithName:@"Lato" size:14]];
    
    [self.lblProductName sizeToFitKeepWidth];
    
    
    self.lblProductPrice.text = [NSString getVNCurrencyFormatterWithNumber:@([product.price intValue])];
    
    self.lblNumber.text = [NSString stringWithFormat:@"X %d", number];
}

+ (CGFloat)getHeight
{
    return 80;
}

@end
