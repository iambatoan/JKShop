//
//  JKBookmarkTableHeader.m
//  JKShop
//
//  Created by admin on 12/9/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKBookmarkTableHeader.h"

@implementation JKBookmarkTableHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"JKBookmarkTableHeader" owner:nil options:nil] objectAtIndex:0];
    }
    return self;
}

- (void)changeNumberOfBookmarkProduct:(NSInteger)numberProducts
{
    self.lblNumberOfProducts.text = [NSString stringWithFormat:@"%d sản phẩm", numberProducts];
    [self.lblNumberOfProducts sizeToFitKeepHeight];
    
    CGRect frame = self.lblInCart.frame;
    frame.origin.x = CGRectGetMaxX(self.lblNumberOfProducts.frame) + 5;
    self.lblInCart.frame = frame;
}

+ (CGFloat)getHeight
{
    return 35;
}

@end
