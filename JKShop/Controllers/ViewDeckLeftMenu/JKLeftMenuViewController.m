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
#import "JKSearchProductCell.h"
#import "JKProductDetailViewController.h"

static CGFloat const LEFT_SIZE = 44;

@interface JKLeftMenuViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
UISearchDisplayDelegate,
UISearchBarDelegate
>

@property (assign, nonatomic) BOOL                  isSearching;
@property (strong, nonatomic) NSMutableArray        * arrMenu;
@property (strong, nonatomic) NSMutableArray        * filteredList;
@property (strong, nonatomic) NSArray               * arrSection;
@property (strong, nonatomic) NSArray               * arrIconSection;
@property (strong, nonatomic) NSArray               * arrSubMenuSectionOne;
@property (weak, nonatomic) IBOutlet UITableView    *menuTableView;

@end

@implementation JKLeftMenuViewController

#pragma mark - View controller lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.arrMenu = [[NSMutableArray alloc] init];
    self.arrMenu = [[JKCategory MR_findAll] mutableCopy];
    
    self.arrSubMenuSectionOne = @[@"JK Shop", @"Hàng mới về", @"Liên hệ"];
    self.arrSection = @[@"Nổi Bật", @"Danh Mục", @"Tuỳ Chỉnh", @"Thông Tin"];
    self.arrIconSection = @[@"star.png",@"category.png",@"setting.png",@"info.png"];
    
    [self.menuTableView registerNib:[UINib nibWithNibName:NSStringFromClass([JKSidebarMenuTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([JKSidebarMenuTableViewCell class])];
    [self.menuTableView registerNib:[UINib nibWithNibName:NSStringFromClass([JKLeftMenuSectionHeader class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([JKLeftMenuSectionHeader class])];
    self.menuTableView.contentOffset = CGPointMake(0, self.searchDisplayController.searchBar.frame.size.height);
    
    [[JKCategoryManager sharedInstance] getMenuListOnComplete:^(NSArray *menu) {
        self.arrMenu = [menu mutableCopy];
        [self.menuTableView reloadData];
    } orFailure:^(NSError *error) {
        DLog(@"Error when load menu");
    }];
}

#pragma mark - Tableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.isSearching) {
        return 1;
    }
    return [self.arrSection count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.isSearching){
        return self.filteredList.count;
    }
    
    switch (section) {
        case 0:
            return self.arrSubMenuSectionOne.count;
        case 1:
            return self.arrMenu.count;
        case 2:
            return 1;
        case 3:
            return 1;
        default:
            return self.arrMenu.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [JKLeftMenuSectionHeader getHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isSearching) {
        return [JKSearchProductCell getHeight];
    }
    return [JKSidebarMenuTableViewCell getHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    JKLeftMenuSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([JKLeftMenuSectionHeader class])];

    if (!header) {
        header = [[JKLeftMenuSectionHeader alloc] init];
    }
    
    if (self.isSearching) {
        [header configTitleNameWithString:@"Kết quả tìm kiếm"];
        [header configIconWithImageURL:@"search"];
        return header;
    }

    [header configTitleNameWithString:[self.arrSection objectAtIndex:section]];
    [header configIconWithImageURL:[self.arrIconSection objectAtIndex:section]];
    return header;

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    JKLeftMenuFooter *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([JKLeftMenuFooter class])];
    
    if (!footer) {
        footer = [[JKLeftMenuFooter alloc] init];
    }
    
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if(section == 3)
        return [JKLeftMenuFooter getHeight];
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isSearching && [self.filteredList count]) {
        if ([[self.filteredList objectAtIndex:indexPath.row] isKindOfClass:[JKProduct class]]) {
            
            JKSearchProductCell * cell = [self.searchDisplayController.searchResultsTableView dequeueReusableCellWithIdentifier:NSStringFromClass([JKSearchProductCell class])];
            [cell customCellWithProduct:[self.filteredList objectAtIndex:indexPath.row]];
            return cell;
        }
    }
    
    JKSidebarMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JKSidebarMenuTableViewCell class])];
    
    switch (indexPath.section) {
        case 0:
        {
            NSString *title = [self.arrSubMenuSectionOne objectAtIndex:indexPath.row];
            NSDictionary *data = @{MENU_TITLE : title};
            [cell configWithData:data];
            return cell;
        }
        case 2:
        {
            NSDictionary *data = @{MENU_TITLE : @"Cấu hình"};
            [cell configWithData:data];
            return cell;
        }
        case 3:
        {
            NSDictionary *data = @{MENU_TITLE : @"Bản đồ"};
            [cell configWithData:data];
            return cell;
        }
        default:
        {
            JKCategory *category = [self.arrMenu objectAtIndex:indexPath.row];
            [cell customCategoryCellWithCategory:category];
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    IIViewDeckController *deckViewController = (IIViewDeckController*)[JKAppDelegate getRootViewController];
    JKNavigationViewController *centralNavVC = (JKNavigationViewController *) deckViewController.centerController;

    if (self.isSearching) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        JKProductDetailViewController *productDetailVC = [[JKProductDetailViewController alloc] init];
        
        productDetailVC.product = [self.filteredList objectAtIndex:indexPath.item];
        [self.view endEditing:YES];
        [deckViewController toggleLeftView];
        [centralNavVC pushViewController:productDetailVC animated:YES];
        [SVProgressHUD showWithStatus:@"Đang tải chi tiết sản phẩm" maskType:SVProgressHUDMaskTypeGradient];
        return;
    }
    
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                [centralNavVC setViewControllers:[NSArray arrayWithObject:[[JKHomeViewController alloc] init]] animated:YES];
                [deckViewController toggleLeftViewAnimated:YES];
                return;
            }
            
            // New products
            
            if (indexPath.row == 1) {
                //              OFProductsViewController *productsVC = [[OFProductsViewController alloc] init];
                //              productsVC.category_id = 21;
                //              productsVC.lblTitle = [self.arrSubMenuSectionOne objectAtIndex:indexPath.row];
                //
                //              [centralNavVC pushViewController:productsVC animated:YES];
                //              [deckViewController toggleLeftView];
                return;
            }
            
            // Contact screen
            if (indexPath.row == 2) {
                BaseViewController *menu3 = [[BaseViewController alloc] init];
                CGRect frame = self.view.frame;
                
                UIWebView *web = [[UIWebView alloc] initWithFrame:frame];
                [menu3.view addSubview:web];
                
                NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"thong-tin-thanh-toan.html"];
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path isDirectory:NO]];
                [web loadRequest:request];
                
                menu3.title = @"Hướng dẫn đặt hàng";
                
                [centralNavVC setViewControllers:[NSArray arrayWithObject:menu3] animated:YES];
                [deckViewController toggleLeftViewAnimated:YES];
                [menu3 addNavigationItems];
                return;
            }
        case 1:
        {
            JKProductsViewController *productsVC = [[JKProductsViewController alloc] init];
            productsVC.category_id = [[self.arrMenu objectAtIndex:indexPath.row] getCategoryId];
            productsVC.lblTitle = [[self.arrMenu objectAtIndex:indexPath.row] getCategoryName];
            
            [centralNavVC setViewControllers:[NSArray arrayWithObject:productsVC] animated:YES];
            [deckViewController toggleLeftViewAnimated:YES];
            return;
        }
        case 2:
            [SVProgressHUD showErrorWithStatus:@"Chức năng hiện đang trong quá trình phát triển"];
            return;
        case 3:
            [centralNavVC setViewControllers:[NSArray arrayWithObject:[[JKMapViewController alloc]init]] animated:YES];
            [deckViewController toggleLeftViewAnimated:YES];
            return;
        default:
            break;
    }
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    
    self.isSearching = YES;
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:NSStringFromClass([JKSearchProductCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([JKSearchProductCell class])];
    IIViewDeckController *deckViewController = (IIViewDeckController*)[JKAppDelegate getRootViewController];
    [deckViewController setLeftSize:0];
    
    CGRect frame = self.menuTableView.frame;
    frame.size.width = [[UIScreen mainScreen] bounds].size.width;
    self.menuTableView.frame = frame;
    self.searchDisplayController.searchResultsTableView.frame = frame;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller{
    self.isSearching = NO;
    [self.menuTableView reloadData];
    
    IIViewDeckController *deckViewController = (IIViewDeckController*)[JKAppDelegate getRootViewController];
    [deckViewController setLeftSize:LEFT_SIZE];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self filterListForSearchText:searchString];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        CGRect frame = self.searchDisplayController.searchResultsTableView.frame;
        frame.origin.y = -20;
        self.searchDisplayController.searchResultsTableView.frame = frame;
    }
    return YES;
}

- (void)filterListForSearchText:(NSString *)searchText
{
    [self.filteredList removeAllObjects];
    self.filteredList = [self arrProductsForSearchText:searchText];
}

- (NSMutableArray *)arrProductsForSearchText:(NSString *)searchText
{
    NSMutableArray *arrResultProduct = [[NSMutableArray alloc] init];
    NSArray *arrProduct = [JKProduct MR_findAll];
    
    if (arrResultProduct.count == 0) {
        for (JKProduct *product in arrProduct) {
            NSRange nameRange = [product.product_code rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (nameRange.location != NSNotFound) {
                [arrResultProduct addObject:product];
            }
        }
        return arrResultProduct;
    }
    
    for (JKProduct *product in arrProduct) {
        NSRange nameRange = [product.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if (nameRange.location != NSNotFound) {
            [arrResultProduct addObject:product];
        }
    }
    return arrResultProduct;
}

@end
