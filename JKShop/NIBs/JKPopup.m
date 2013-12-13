//
//  JKPopup.m
//  JKShop
//
//  Created by admin on 12/10/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKPopup.h"

@interface JKPopup()

@property (strong, nonatomic) JKProduct *product;
@property (strong, nonatomic) IBOutlet UIView *popupView;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UILabel *labelQuantity;
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *labelProductName;
@property (weak, nonatomic) IBOutlet UILabel *labelProductSku;
@property (weak, nonatomic) IBOutlet UILabel *labelProductPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelProductDetail;
@property (weak, nonatomic) IBOutlet UIImageView *productImageWrapper;

@end

@implementation JKPopup

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        [self.contentView addSubview:self.popupView];
        self.contentColor = [UIColor whiteColor];
        self.borderColor = [UIColor titleColor];
        
    }
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	[self.popupView setFrame:self.contentView.bounds];
}

- (IBAction)stepperValueChanged:(id)sender {
    double value = [(UIStepper *)sender value];
    [self.labelQuantity setText:[NSString stringWithFormat:@"%d", (int)value]];
}

- (void)loadDetailWithProduct:(JKProduct *)product{
    self.product = product;
    self.labelProductName.text = product.name;
    [self.labelProductName setFont:[UIFont fontWithName:@"Lato" size:17]];
    [self.labelProductName setTextColor:[UIColor titleColor]];
    self.labelProductSku.text = [NSString stringWithFormat:@"Mã sản phẩm: %@",product.product_code];
    self.labelProductPrice.text = [NSString getVNCurrencyFormatterWithNumber:@([product.price intValue])];
    self.labelProductDetail.text = product.detail;
    [self.productImage setImageWithURL:[NSURL URLWithString:[[product.images anyObject] getSmallImageURL]]];
    self.productImageWrapper.layer.borderWidth = 1;
    self.productImageWrapper.layer.borderColor = [UIColor titleColor].CGColor;
}

- (IBAction)addToCartButtonPress:(id)sender {
    if ([[JKProductManager sharedInstance] isBookmarkedAlreadyWithProductID:self.product.product_id]) {
         [SVProgressHUD showErrorWithStatus:@"Sản phẩm đã được Bookmark rồi!"];
        [self hide];
         return;
     }

    [[JKProductManager sharedInstance] bookmarkProductWithProductID:self.product.product_id withNumber:[self.stepper value]];
    [SVProgressHUD showSuccessWithStatus:@"Bookmark thành công"];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_CHANGE_BOOKMARK_PRODUCT_COUNT object:self];
    [self hide];
}

@end
