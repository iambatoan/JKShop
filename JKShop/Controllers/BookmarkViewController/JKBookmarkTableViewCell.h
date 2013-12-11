//
//  JKBookmarkTableViewCell.h
//  JKShop
//
//  Created by admin on 12/9/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JKBookmarkTableViewCellDelegate <NSObject>

- (void)onLongPress:(id)sender;

@end

@interface JKBookmarkTableViewCell : SWTableViewCell

@property (strong, nonatomic) id <JKBookmarkTableViewCellDelegate> delegate;

- (void)configWithDictionary:(NSDictionary *)dictionaryProduct;
+ (CGFloat)getHeight;


@end
