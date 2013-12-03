//
//  JKSidebarMenuTableViewCell.m
//  JKShop
//
//  Created by admin on 11/30/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKSidebarMenuTableViewCell.h"

@interface JKSidebarMenuTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *sidebarMenuImage;
@property (weak, nonatomic) IBOutlet UILabel *sidebarMenuTitle;

@end

@implementation JKSidebarMenuTableViewCell

- (void)customCategoryCellWithCategory:(JKCategory *)category
{
    [self customCell];
    self.sidebarMenuTitle.text = [category name];
}

- (void)configWithData:(id)data
{
    [self customCell];
    self.sidebarMenuTitle.text = [data objectForKey:MENU_TITLE];
}

- (void)customCell
{  
    // Dark line
//    UIView *btmLine = [[UIView alloc] initWithFrame:CGRectMake(0, 43, 320, 1)];
//    btmLine.backgroundColor = [UIColor colorWithHexValue:0x000000];
//    [self addSubview:btmLine];
//    
//    // Light line
//    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 1)];
//    topLine.backgroundColor = [UIColor colorWithHexValue:0x4d4b49];
//    [self addSubview:topLine];
}

#pragma mark - Helpers

+ (CGFloat)getHeight
{
    return 43;
}

@end
