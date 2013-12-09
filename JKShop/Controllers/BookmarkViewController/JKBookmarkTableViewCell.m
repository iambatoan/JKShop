//
//  JKBookmarkTableViewCell.m
//  JKShop
//
//  Created by admin on 12/9/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKBookmarkTableViewCell.h"

@implementation JKBookmarkTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"JKBookmarkTableViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    return self;
}

- (void)configWithProduct:(JKProduct *)product andNumber:(NSInteger)number
{
    self.product = product;
    self.imgProductWrapImage.layer.borderWidth = 1;
    self.imgProductWrapImage.layer.borderColor = [UIColor colorWithHexString:@"beb7a9"].CGColor;
    
    NSString *imgUrl = [NSString stringWithFormat:@"http://orangefashion.vn/store/%@/%@_small.jpg", product.product_id, product.product_id];
    [self.imgProductImage setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil];
    
    self.lblProductName.text = product.name;
    [self.lblProductName sizeToFitKeepWidth];
    
    self.lblProductPrice.text = product.price;
    CGRect priceFrame = self.lblProductPrice.frame;
    priceFrame.origin.y = CGRectGetMaxY(self.lblProductName.frame);
    self.lblProductPrice.frame = priceFrame;
    
    self.lblNumber.text = [NSString stringWithFormat:@"x %d", number];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDeleteBookmark:)];
    [self addGestureRecognizer:longPress];
}

+ (CGFloat)getHeight
{
    return 80;
}

#pragma mark - Actions

- (void)longPressToDeleteBookmark:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(onLongPress:)]) {
        [self.delegate onLongPress:@{   @"guesture": sender,
                                        @"productId": self.product.product_id}];
    }
}


@end
