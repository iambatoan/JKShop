//
//  JKSearchBar.m
//  JKShop
//
//  Created by Toan Slan on 12/9/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKSearchBar.h"

@implementation JKSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)layoutSubviews
{
    UITextField *searchField;
    NSUInteger numViews = [self.subviews count];
    for(int i = 0; i < numViews; i++) {
        if([[self.subviews objectAtIndex:i] isKindOfClass:[UITextField class]]) {
            searchField = [self.subviews objectAtIndex:i];
        }
    }
    if(!(searchField == nil)) {
        [searchField setBackground:nil];
        [searchField setBackgroundColor:[UIColor whiteColor]];
        [searchField setBorderStyle:UITextBorderStyleBezel];
    }
    self.backgroundColor = [UIColor headerMenuColor];
    [self clearSearchBarBackground];
    [self setCloseButtonTitle:@"Cancel" forState:UIControlStateNormal];
    [super layoutSubviews];
}

- (void)clearSearchBarBackground{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        for (UIView *subview in [[self.subviews objectAtIndex:0]subviews]) {
            if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [subview removeFromSuperview];
                return;
            }
        }
    }
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
        }
    }
    
}

- (void) setCloseButtonTitle: (NSString *) title forState: (UIControlState)state
{
    [self setTitle: title forState: state forView:self];
}

-(void) setTitle: (NSString *) title forState: (UIControlState)state forView: (UIView *)view
{
    UIButton *cancelButton = nil;
    for(UIView *subView in view.subviews){
        if([subView isKindOfClass:UIButton.class])
        {
            cancelButton = (UIButton*)subView;
            [cancelButton setTitle:title forState:state];
            [cancelButton setTintColor:[UIColor colorWithHexString:@"D26E4B"]];
            return;
        }
        else
        {
            [self setTitle:title forState:state forView:subView];
        }
    }
}

@end
