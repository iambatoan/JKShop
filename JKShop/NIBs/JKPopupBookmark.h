//
//  JKPopupBookmark.h
//  JKShop
//
//  Created by Toan Slan on 12/11/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "UAModalPanel.h"

@class JKPopupBookmark;
@protocol JKPopupBookmarkDelegate

- (void)didPressConfirmButton:(JKPopupBookmark *)modalPanel;

@end

@interface JKPopupBookmark : UAModalPanel

@property (assign, nonatomic) NSObject <JKPopupBookmarkDelegate> *JKDelegate;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (strong, nonatomic) JKProduct *product;

- (id)initWithFrame:(CGRect)frame;
- (void)loadDetailWithProduct:(JKProduct *)product;

@end
