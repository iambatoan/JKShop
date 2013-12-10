//
//  JKBookmarkTableHeader.h
//  JKShop
//
//  Created by admin on 12/9/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKBookmarkTableHeader : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *labelTotal;

- (void)changeNumberOfBookmarkProduct:(NSInteger)numberProducts;
+ (CGFloat)getHeight;

@end
