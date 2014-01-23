//
//  UIImageView+Additions.m
//  TemplateProject
//
//  Created by Torin Nguyen on 19/4/13.
//  Copyright (c) 2013 MyCompany. All rights reserved.
//

#import "UIImageView+Additions.h"
#import "UIImage+animatedGIF.h"

@implementation UIImageView (Additions)

- (void)fadeToImage:(UIImage*)newImage duration:(CGFloat)duration
{
  UIImageView * imageView = [[UIImageView alloc] initWithFrame:self.bounds];
  imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  imageView.contentMode = self.contentMode;
  imageView.image = newImage;
  imageView.alpha = 0;
  [self addSubview:imageView];
  
  [UIView animateWithDuration:duration animations:^{
    imageView.alpha = 1;
    
  } completion:^(BOOL finished) {
    self.image = newImage;
    imageView.image = nil;
    [imageView removeFromSuperview];
  }];
}

- (void)sizeToFitImage
{
    CGFloat scale = 2.0 / [UIScreen mainScreen].scale;
    UIImage * image = self.image;
    CGFloat newWidth = image.size.width / scale;
    CGFloat newHeight = image.size.height / scale;

    CGRect frame = self.frame;
    if (newWidth > frame.size.width)
        frame.size.width = newWidth;
    
    if (newHeight > frame.size.height)
        frame.size.height = newHeight;
    
    self.frame = frame;
}

@end
