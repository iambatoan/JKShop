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
#import "JKAppDelegate.h"
#import "JKNavigationViewController.h"
#import "JKLeftMenuFooter.h"
#import "JKCategory.h"
#import "JKHomeViewController.h"

@interface JKLeftMenuViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (strong, nonatomic) NSMutableArray        * arrMenu;
@property (strong, nonatomic) NSArray               * arrSection;
@property (strong, nonatomic) NSArray               * arrIconSection;
@property (strong, nonatomic) NSArray               * arrSubMenuSectionOne;
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;


@end

@implementation JKLeftMenuViewController

#pragma mark - View controller lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.arrMenu = [[NSMutableArray alloc] init];
    
    self.arrSubMenuSectionOne = @[@"JK Shop", @"Hàng mới về", @"Liên hệ"];
    self.arrSection = @[@"Nổi Bật", @"Danh Mục", @"Tuỳ Chỉnh", @"Thông Tin"];
    self.arrIconSection = @[@"star.png",@"category.png",@"setting.png",@"info.png"];
    
    [self.menuTableView registerNib:[UINib nibWithNibName:NSStringFromClass([JKSidebarMenuTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([JKSidebarMenuTableViewCell class])];
    
    self.arrMenu = [[JKCategory MR_findAll] mutableCopy];
    
    [[JKCategoryManager sharedInstance] getMenuListOnComplete:^(NSArray *menu) {
        self.arrMenu = [menu mutableCopy];
        [self.menuTableView reloadData];
    } orFailure:^(NSError *error) {
        DLog(@"Error when load menu");
    }];
}

#pragma mark - Tableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.arrSection count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    // Hit
    if (section == 0) {
        return self.arrSubMenuSectionOne.count;
    }
    
    // Menu
    if (section == 1) {
        return self.arrMenu.count;
    }
    
    // Information
    if (section == 2) {
        return 1;
    }
    
    // Log out
    if (section == 3) {
        return 1;
    }
    
    return self.arrMenu.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [JKLeftMenuSectionHeader getHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [JKSidebarMenuTableViewCell getHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    JKLeftMenuSectionHeader *header;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
        header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([JKLeftMenuSectionHeader class])];
    }else{
        header = [[JKLeftMenuSectionHeader alloc] init];
    }
    if (!header) {
        header = [[JKLeftMenuSectionHeader alloc] init];
    }
    
    if ([[self.arrSection objectAtIndex:section] isKindOfClass:[NSString class]]) {
        [header configTitleNameWithString:[self.arrSection objectAtIndex:section]];
        [header configIconWithImageURL:[self.arrIconSection objectAtIndex:section]];
    }
    
    return header;

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    JKLeftMenuFooter *footer;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
        footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([JKLeftMenuFooter class])];
    }else{
        footer = [[JKLeftMenuFooter alloc] init];
    }
    if (!footer) {
        footer = [[JKLeftMenuFooter alloc] init];
    }
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 3)
        return 65;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIndentifier =  NSStringFromClass([JKSidebarMenuTableViewCell class]);
    JKSidebarMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    if (indexPath.section == 0) {
        NSString *title = [self.arrSubMenuSectionOne objectAtIndex:indexPath.row];
        NSDictionary *data = @{MENU_TITLE : title};
        [cell configWithData:data];
        return cell;
    }
    
    if (indexPath.section == 2) {
        NSDictionary *data = @{MENU_TITLE : @"Cấu hình"};
        [cell configWithData:data];
        return cell;
    }
    
    if (indexPath.section == 3) {
        NSDictionary *data = @{MENU_TITLE : @"Bản đồ"};
        [cell configWithData:data];
        return cell;
    }
    
    if (indexPath.row < self.arrMenu.count)
    {
        JKCategory *category = [self.arrMenu objectAtIndex:indexPath.row];
        [cell customCategoryCellWithCategory:category];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    IIViewDeckController *deckViewController = (IIViewDeckController*)[[(JKAppDelegate*)[[UIApplication sharedApplication] delegate] window] rootViewController];
    JKNavigationViewController *centralNavVC = (JKNavigationViewController *) deckViewController.centerController;
    
    if (indexPath.section == 0) {
        
        // Back to master menu
        if (indexPath.row == 0) {
            [centralNavVC setViewControllers:[NSArray arrayWithObject:[[JKHomeViewController alloc] init]] animated:YES];
            [deckViewController toggleLeftView];
            return;
        }
        
        // New products
        
        if (indexPath.row == 1) {
//            OFProductsViewController *productsVC = [[OFProductsViewController alloc] init];
//            productsVC.category_id = 21;
//            productsVC.lblTitle = [self.arrSubMenuSectionOne objectAtIndex:indexPath.row];
//            
//            [centralNavVC pushViewController:productsVC animated:YES];
//            [deckViewController toggleLeftView];
            return;
        }
        
        // Contact screen
        if (indexPath.row == 2) {
            BaseViewController *menu3 = [[BaseViewController alloc] init];
            CGRect frame = self.view.frame;
            
            UIWebView *web = [[UIWebView alloc] initWithFrame:frame];
            [menu3.view addSubview:web];
            
            NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"thong-tin-thanh-toan.html"];
            NSURL *url = [NSURL fileURLWithPath:path isDirectory:NO];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [web loadRequest:request];
            
            menu3.title = @"Hướng dẫn đặt hàng";
            
            [centralNavVC setViewControllers:[NSArray arrayWithObject:menu3] animated:YES];
            [deckViewController toggleLeftView];
            return;
        }
    }
    
    if (indexPath.section == 3) {
        [centralNavVC setViewControllers:[NSArray arrayWithObject:[[JKMapViewController alloc]init]] animated:YES];
        [deckViewController toggleLeftView];
        return;
    }
    
    if (indexPath.section == 2) {
        [SVProgressHUD showErrorWithStatus:@"Chức năng hiện đang trong quá trình phát triển"];
        return;
    }
    
    JKProductsViewController *productsVC = [[JKProductsViewController alloc] init];
    productsVC.category_id = [[self.arrMenu objectAtIndex:indexPath.row] getCategoryId];
    productsVC.lblTitle = [[self.arrMenu objectAtIndex:indexPath.row] getCategoryName];
    [centralNavVC setViewControllers:[NSArray arrayWithObject:productsVC] animated:YES];
    [deckViewController toggleLeftView];
}

@end
