//
//  JKLeftMenuSectionHeader.m
//  JKShop
//
//  Created by admin on 11/30/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKLeftMenuSectionHeader.h"

@interface JKLeftMenuSectionHeader()

@property (weak, nonatomic) IBOutlet UILabel *sectionTitle;
@property (weak, nonatomic) IBOutlet UIImageView *sectionIcon;

@end

@implementation JKLeftMenuSectionHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"JKLeftMenuSectionHeader" owner:nil options:nil] objectAtIndex:0];
    }
    return self;
}

- (void)configTitleNameWithString:(NSString *)title
{
    self.sectionTitle.text = title;
}

- (void)configIconWithImageURL:(NSString *)iconURL
{
    self.sectionIcon.image = [UIImage imageNamed:iconURL];
}

+ (CGFloat)getHeight
{
    return 20;
}

@end
