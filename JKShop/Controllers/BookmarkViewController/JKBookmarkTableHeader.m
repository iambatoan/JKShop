//
//  JKBookmarkTableHeader.m
//  JKShop
//
//  Created by admin on 12/9/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKBookmarkTableHeader.h"
#import "JKOrderManager.h"

@interface JKBookmarkTableHeader()

@property (weak, nonatomic) IBOutlet UILabel *lblNumberOfProducts;
@property (weak, nonatomic) IBOutlet UILabel *lblInCart;

@end

@implementation JKBookmarkTableHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] objectAtIndex:0];
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
    return 84;
}

- (IBAction)checkoutButtonPressed:(id)sender {
    if ([FBSession activeSession].isOpen) {
        [[JKOrderManager sharedInstance] createOrderOnSuccess:^(NSInteger statusCode, id obj)
        {
            [SVProgressHUD showSuccessWithStatus:@"Create order successfully!"];
        }
                                                    onFailure:^(NSInteger statusCode, NSError *error)
        {
            DLog(@"%d, %@", statusCode, error);
        }];
        return;
    }
    [SVProgressHUD showErrorWithStatus:@"Login to checkout !!!"];
}

@end
