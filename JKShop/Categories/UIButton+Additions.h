//
//  UIButton+Additions.h
//
//
//  Created by Torin Nguyen on 16/8/13.
//
//

#import <UIKit/UIKit.h>

@interface UIButton (Additions)

@property (nonatomic, strong) UIImage * image;

- (void)autofitTextKeepRight:(BOOL)keepRight;

- (void)setSelectedWithEffect:(BOOL)selected animated:(BOOL)animated;
- (void)setImageWithColor:(UIColor *)color forState:(UIControlState)state;

- (void)useImageForBackgroundColor;

- (void)autoAdjustFontFamily;

- (void)fadeToText:(NSString *)newText;
- (void)fadeToText:(NSString *)newText duration:(CGFloat)duration;
- (void)fadeToImage:(UIImage *)image;
- (void)fadeToImage:(UIImage *)image duration:(CGFloat)duration;

@end
