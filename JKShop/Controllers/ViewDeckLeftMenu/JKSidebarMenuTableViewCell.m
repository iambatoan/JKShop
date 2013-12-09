//
//  JKSidebarMenuTableViewCell.m
//  JKShop
//
//  Created by admin on 11/30/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKSidebarMenuTableViewCell.h"

@interface JKSidebarMenuTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView            * sidebarMenuImage;
@property (weak, nonatomic) IBOutlet UILabel                * sidebarMenuTitle;

@end

@implementation JKSidebarMenuTableViewCell

- (void)customCategoryCellWithCategory:(JKCategory *)category
{
    self.sidebarMenuTitle.text = [category name];
    if ([category getParentId]) {
        self.sidebarMenuTitle.text = [NSString stringWithFormat:@"    %@",[category name]];
    }
}

- (void)configWithData:(id)data
{
    self.sidebarMenuTitle.text = [data objectForKey:MENU_TITLE];
}

#pragma mark - Helpers

+ (CGFloat)getHeight
{
    return 43;
}

@end
