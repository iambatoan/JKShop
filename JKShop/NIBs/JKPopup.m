//
//  JKPopup.m
//  JKShop
//
//  Created by admin on 12/10/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKPopup.h"

@interface JKPopup()

@property (strong, nonatomic) IBOutlet UIView *test;

@end

@implementation JKPopup

- (id)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        self.headerLabel.text = title;
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        [self.contentView addSubview:self.test];
        [[self titleBar] setNoiseOpacity:0];
        CGFloat colors[8] = {0,0,0,1,0,0,0,1};
        [[self titleBar] setColorComponents:colors];
    }
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	[self.test setFrame:self.contentView.bounds];
}

@end
