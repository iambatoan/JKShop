//
//  UIButton+Additions.m
//
//
//  Created by Torin Nguyen on 16/8/13.
//
//

#import "UIButton+Additions.h"
#import "UIView+Additions.h"

@implementation UIButton (Additions)

- (UIImage *)image {
    return self.imageView.image;
}
- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
}


- (void)autofitTextKeepRight:(BOOL)keepRight
{
    NSString * text = self.titleLabel.text;
    CGSize expectedSize = [text sizeWithFont:self.titleLabel.font];
    CGFloat width = MAX(CGRectGetWidth(self.bounds), expectedSize.width + 20*2);    //add padding to the sides
    
    [self resizeWidthTo:width keepRight:keepRight];
}

- (void)setSelectedWithEffect:(BOOL)selected animated:(BOOL)animated
{
    [self setSelected:selected];
    
    if (selected == NO)
    {
        if (animated)     [self animateShadowToOpacity:0 duration:0.35];
        else              self.layer.shadowOpacity = 0;
        return;
    }
    
    self.layer.shadowColor = [UIColor colorWithRed:1 green:0.7 blue:0.35 alpha:1].CGColor;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowRadius = 6;
    self.layer.masksToBounds = NO;
    self.clipsToBounds = NO;
    
    if (animated)     [self animateShadowToOpacity:1 duration:0.35];
    else              self.layer.shadowOpacity = 1;
}

- (void)setImageWithColor:(UIColor *)color forState:(UIControlState)state
{
    [self setImage:[UIImage imageWithColor:color size:self.size] forState:state];
}

- (void)useImageForBackgroundColor
{
    [self setBackgroundImage:[UIImage imageWithColor:self.backgroundColor size:self.size] forState:UIControlStateNormal];
    self.backgroundColor = [UIColor clearColor];
}

- (void)autoAdjustFontFamily
{
    self.titleLabel.font = [UIFont appFontFromFont:self.titleLabel.font];
}

- (void)fadeToText:(NSString *)newText
{
    [self fadeToText:newText duration:0.35];
}

- (void)fadeToText:(NSString *)newText duration:(CGFloat)duration
{
    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionFade;
    animation.duration = duration;
    [self.layer addAnimation:animation forKey:@"kCATransitionFade"];
    
    [self setTitle:newText forState:UIControlStateNormal];
}

- (void)fadeToImage:(UIImage *)image
{
    [self fadeToImage:image duration:0.35];
}

- (void)fadeToImage:(UIImage *)image duration:(CGFloat)duration
{
    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionFade;
    animation.duration = duration;
    [self.layer addAnimation:animation forKey:@"kCATransitionFade"];
    
    [self setImage:image forState:UIControlStateNormal];
}


@end
