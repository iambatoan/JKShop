//
//  JKLeftMenuSectionHeader.h
//  JKShop
//
//  Created by admin on 11/30/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKLeftMenuSectionHeader : UIView

- (void)configTitleNameWithString:(NSString *)title;
- (void)configIconWithImageURL:(NSString *)iconURL;
+ (CGFloat)getHeight;

@end
