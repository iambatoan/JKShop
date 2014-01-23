//
//  UIFont+Additions.h
//
//  Created by Torin Nguyen on 17/4/13.
//  Copyright (c) 2013 MyCompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Additions)

+ (UIFont *)appFontFromFont:(UIFont *)standardFont;

+ (UIFont *)appFontOfSize:(CGFloat)fontSize;

+ (UIFont *)lightAppFontOfSize:(CGFloat)fontSize;

+ (UIFont *)mediumAppFontOfSize:(CGFloat)fontSize;

+ (UIFont *)boldAppFontOfSize:(CGFloat)fontSize;

+ (UIFont *)altAppFontOfSize:(CGFloat)fontSize;

+ (UIFont *)altLightAppFontOfSize:(CGFloat)fontSize;

+ (UIFont *)altMediumAppFontOfSize:(CGFloat)fontSize;

+ (UIFont *)altBoldAppFontOfSize:(CGFloat)fontSize;

@end
