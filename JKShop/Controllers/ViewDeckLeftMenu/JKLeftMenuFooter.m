//
//  JKLeftMenuFooter.m
//  JKShop
//
//  Created by admin on 11/30/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKLeftMenuFooter.h"

@interface JKLeftMenuFooter()

@property (weak, nonatomic) IBOutlet UIButton *callButton;


@end

@implementation JKLeftMenuFooter

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"JKLeftMenuFooter" owner:nil options:nil] objectAtIndex:0];
    }
    return self;
}

@end
