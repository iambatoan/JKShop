//
//  JKLeftMenuViewController.m
//  JKShop
//
//  Created by admin on 11/30/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKLeftMenuViewController.h"
#import "JKSidebarMenuTableViewCell.h"
#import "JKLeftMenuSectionHeader.h"

@interface JKLeftMenuViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (strong, nonatomic) NSMutableArray        * arrMenu;
@property (strong, nonatomic) NSArray               * arrSection;
@property (strong, nonatomic) NSArray               * arrSubMenuSectionOne;
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;

@end

@implementation JKLeftMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.arrMenu = [[NSMutableArray alloc] init];
    
    self.arrSubMenuSectionOne = @[@"Orange Fashion", @"Hàng mới về", @"Liên hệ"];
    self.arrSection = @[@"Nổi bật", @"Danh mục", @"Tuỳ chỉnh", @"Thông tin"];
    
    [self.menuTableView registerNib:[UINib nibWithNibName:NSStringFromClass([JKSidebarMenuTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([JKSidebarMenuTableViewCell class])];
    
    [[OFHelperManager sharedInstance] getMenuListOnComplete:^(NSArray *menu) {
        self.arrMenu = [[[menu objectAtIndex:1] objectForKey:@"session"] mutableCopy];
        [self.tableMenu reloadData];
    } orFailure:^(NSError *error) {
        DLog(@"Error when load menu");
    }];
}

@end
