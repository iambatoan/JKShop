//
//  JKProductDetailViewController.m
//  JKShop
//
//  Created by Toan Slan on 12/3/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKProductDetailViewController.h"

@interface JKProductDetailViewController ()
<
UIScrollViewDelegate
>
@property (weak, nonatomic) IBOutlet UIPageControl *imagePageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;

@end

@implementation JKProductDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    self.viewDeckController.panningMode = IIViewDeckNoPanning;
    [self getImageFromProduct];
    NSArray *imageArray = [[NSArray alloc] initWithObjects:@"no_product.gif", @"logo.png", @"home.jpg", nil];
    
    for (int i = 0; i < [imageArray count]; i++) {
        //We'll create an imageView object in every 'page' of our scrollView.
        CGRect frame;
        frame.origin.x = self.imageScrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.imageScrollView.frame.size;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.image = [UIImage imageNamed:[imageArray objectAtIndex:i]];
        [self.imageScrollView addSubview:imageView];
    }
    //Set the content size of our scrollview according to the total width of our imageView objects.
    self.imageScrollView.contentSize = CGSizeMake(self.imageScrollView.frame.size.width * [imageArray count], self.imageScrollView.frame.size.height);
}

- (void)getImageFromProduct{
    [JKProductImages getImagesForProduct:self.product_id successBlock:^(NSInteger statusCode, id obj) {

    } failureBlock:^(NSInteger statusCode, id obj) {
        //Handle when failure
        [SVProgressHUD showErrorWithStatus:@"Xin vui lòng kiểm tra kết nối mạng và thử lại"];
    }];;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth = self.imageScrollView.frame.size.width;
    int page = floor((self.imageScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.imagePageControl.currentPage = page;
}

@end
