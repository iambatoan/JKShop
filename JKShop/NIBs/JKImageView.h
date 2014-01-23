//
//  JKImageView.h
//  JKShop
//
//  Created by Toan Slan on 1/23/14.
//  Copyright (c) 2014 Nguyễn Bá Toàn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageManager.h"

@interface JKImageView : UIImageView

- (void)reset;

- (void)setImageAsync:(NSString *)fullUrl;

- (void)setImageAsync:(NSString *)fullUrl
   showErrorIndicator:(BOOL)showErrorIndicator;

- (void)setImageAsync:(NSString *)fullUrlString
   showErrorIndicator:(BOOL)showErrorIndicator
     placeholderImage:(UIImage *)placeholder
            completed:(SDWebImageCompletedBlock)completedBlock;

@end
