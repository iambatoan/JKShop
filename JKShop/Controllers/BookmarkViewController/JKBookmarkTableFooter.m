//
//  JKBookmarkTableFooter.m
//  JKShop
//
//  Created by Toan Slan on 12/10/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKBookmarkTableFooter.h"

@implementation JKBookmarkTableFooter

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] objectAtIndex:0];
    }
    return self;
}
- (IBAction)deleteAllButtonPressed:(id)sender {
    
}

+ (CGFloat)getHeight{
    return 50;
}
@end
