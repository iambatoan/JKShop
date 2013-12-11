//
//  JKPopup.h
//  JKShop
//
//  Created by admin on 12/10/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKPopup : UAModalPanel

- (id)initWithFrame:(CGRect)frame;

- (void)loadDetailWithProduct:(JKProduct *)product;

@end
