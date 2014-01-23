//
//  UIFont+Additions.m
//
//  Created by Torin Nguyen on 17/4/13.
//  Copyright (c) 2013 MyCompany. All rights reserved.
//

#import "UIFont+Additions.h"

@implementation UIFont (Additions)

+ (void)load
{
    [super load];
    //EXCHANGE_METHOD( systemFontOfSize:, appFontOfSize: );
    //EXCHANGE_METHOD( boldSystemFontOfSize:, boldAppFontOfSize: );
}

+ (UIFont *)appFontFromFont:(UIFont *)standardFont
{
    NSString * fontName = [standardFont.fontName lowercaseString];
    CGFloat size = standardFont.pointSize;
    
    BOOL bold = [fontName contains:@"bold"];
    BOOL light = [fontName contains:@"light"];
    BOOL medium = [fontName contains:@"semi"];
    
    if (bold)           standardFont = [UIFont boldAppFontOfSize:size];
    else if (medium)    standardFont = [UIFont mediumAppFontOfSize:size];
    else if (light)     standardFont = [UIFont lightAppFontOfSize:size];
    else                standardFont = [UIFont appFontOfSize:size];
    
    return standardFont;
}

+ (UIFont *)appFontOfSize:(CGFloat)fontSize
{
    return [UIFont HelveticaNeueRegularFontOfSize:fontSize];
}

+ (UIFont *)lightAppFontOfSize:(CGFloat)fontSize
{
    return [UIFont HelveticaNeueLightFontOfSize:fontSize];
}

+ (UIFont *)mediumAppFontOfSize:(CGFloat)fontSize
{
    return [UIFont HelveticaNeueSemiBoldFontOfSize:fontSize];
}

+ (UIFont *)boldAppFontOfSize:(CGFloat)fontSize
{
    return [UIFont HelveticaNeueBoldFontOfSize:fontSize];
}

+ (UIFont *)altAppFontOfSize:(CGFloat)fontSize
{
    return [UIFont OpenSansRegularFontOfSize:fontSize];
}

+ (UIFont *)altLightAppFontOfSize:(CGFloat)fontSize
{
    return [UIFont OpenSansLightFontOfSize:fontSize];
}

+ (UIFont *)altMediumAppFontOfSize:(CGFloat)fontSize
{
    return [UIFont OpenSansSemiBoldFontOfSize:fontSize];
}

+ (UIFont *)altBoldAppFontOfSize:(CGFloat)fontSize
{
    return [UIFont OpenSansBoldFontOfSize:fontSize];
}




#pragma mark - Private functions

+ (UIFont *)HelveticaNeueRegularFontOfSize:(CGFloat)fontSize
{
    UIFont *theFont = [UIFont fontWithName:@"HelveticaNeue-Regular" size:fontSize];
    if (theFont == nil)
        theFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:fontSize];
    return theFont;
}

+ (UIFont *)HelveticaNeueSemiBoldFontOfSize:(CGFloat)fontSize
{
    UIFont *theFont = [UIFont fontWithName:@"HelveticaNeue-Semibold" size:fontSize];
    if (theFont == nil)
        theFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:fontSize];
    return theFont;
}

+ (UIFont *)HelveticaNeueBoldFontOfSize:(CGFloat)fontSize
{
    UIFont *theFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:fontSize];
    if (theFont == nil)
        theFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:fontSize];
    return theFont;
}

+ (UIFont *)HelveticaNeueLightFontOfSize:(CGFloat)fontSize
{
    UIFont *theFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize];
    if (theFont == nil)
        theFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize];
    return theFont;
}

+ (UIFont *)OpenSansRegularFontOfSize:(CGFloat)fontSize
{
    UIFont *theFont = [UIFont fontWithName:@"OpenSans-Regular" size:fontSize];
    if (theFont == nil)
        theFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:fontSize];
    return theFont;
}

+ (UIFont *)OpenSansSemiBoldFontOfSize:(CGFloat)fontSize
{
    UIFont *theFont = [UIFont fontWithName:@"OpenSans-Semibold" size:fontSize];
    if (theFont == nil)
        theFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:fontSize];
    return theFont;
}

+ (UIFont *)OpenSansBoldFontOfSize:(CGFloat)fontSize
{
    UIFont *theFont = [UIFont fontWithName:@"OpenSans-Bold" size:fontSize];
    if (theFont == nil)
        theFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:fontSize];
    return theFont;
}

+ (UIFont *)OpenSansLightFontOfSize:(CGFloat)fontSize
{
    UIFont *theFont = [UIFont fontWithName:@"OpenSans-Light" size:fontSize];
    if (theFont == nil)
        theFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize];
    return theFont;
}

@end
