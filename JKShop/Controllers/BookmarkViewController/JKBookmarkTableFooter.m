//
//  JKBookmarkTableFooter.m
//  JKShop
//
//  Created by Toan Slan on 12/10/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKBookmarkTableFooter.h"

@interface JKBookmarkTableFooter()
<
UIAlertViewDelegate
>

@end

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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Do you want to delete all?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [JKProductManager removeAllBookmarkProduct];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadTableView" object:nil];
    }
}

+ (CGFloat)getHeight{
    return 50;
}
@end
