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
@property (weak, nonatomic) IBOutlet UITableView    * menuTableView;
@property (weak, nonatomic) IBOutlet UIView         * searchBarView;

@end

@implementation JKLeftMenuViewController

#pragma mark - View controller lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.arrMenu = [[[JKCategoryManager sharedInstance] getMenuList] mutableCopy];
    
    self.arrSubMenuSectionOne = @[@"JK Shop", @"Hàng mới về", @"Liên hệ"];
    self.arrSection = @[@"Nổi Bật", @"Danh Mục", @"Tuỳ Chỉnh"];
    self.arrIconSection = @[@"star.png",@"category.png",@"setting.png"];
    
    [self.menuTableView registerNib:[UINib nibWithNibName:NSStringFromClass([JKSidebarMenuTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([JKSidebarMenuTableViewCell class])];
    [self.menuTableView registerNib:[UINib nibWithNibName:NSStringFromClass([JKLeftMenuSectionHeader class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([JKLeftMenuSectionHeader class])];
    [self loadCategoryMenu];
}


#pragma mark - Tableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.isSearching && [tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        return 1;
    }
    return [self.arrSection count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.isSearching && [tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        return self.filteredList.count;
    }
    
    switch (section) {
        case 0:
            return self.arrSubMenuSectionOne.count;
        case 1:
            if (self.arrMenu.count) {
                return self.arrMenu.count;
            }
            return 1;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
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
        default:
        {
            if(self.arrMenu.count)
            {
                JKCategory *category = [self.arrMenu objectAtIndex:indexPath.row];
                [cell customCategoryCellWithCategory:category];
                return cell;
            }
            
            UITableViewCell *refreshCell = [[UITableViewCell alloc] init];
            
            UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [refreshButton addTarget:self
                              action:@selector(refreshButtonPressed)
                    forControlEvents:UIControlEventTouchUpInside];
            [refreshButton setTitle:@"Refresh Menu" forState:UIControlStateNormal];
            [refreshButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [refreshButton setBackgroundColor:[UIColor grayColor]];
            refreshButton.frame = CGRectMake(30, 7, 215, 27);
            
            [refreshCell addSubview:refreshButton];
            return refreshCell;
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
            
        default:
            break;
    }
}

#pragma Search Display Controller Delegate

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    
    self.isSearching = YES;
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:NSStringFromClass([JKSearchProductCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([JKSearchProductCell class])];
    IIViewDeckController *deckViewController = (IIViewDeckController*)[JKAppDelegate getRootViewController];
    [deckViewController setLeftSize:0];
    [self.searchBarView setWidth:320];
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller{
    self.isSearching = NO;
    
    IIViewDeckController *deckViewController = (IIViewDeckController*)[JKAppDelegate getRootViewController];
    [deckViewController setLeftSize:LEFT_SIZE];
    [self.searchBarView setWidth:275];
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    [self.menuTableView reloadData];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self filterListForSearchText:searchString];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        CGRect frame = self.searchDisplayController.searchResultsTableView.frame;
        frame.origin.y = -20;
        frame.size.height = 500;
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
    
    for (JKProduct *product in arrProduct) {
        NSString *productNameWithoutUnicode = [[NSString alloc] initWithData:[product.name dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES] encoding:NSASCIIStringEncoding];
        NSRange nameRange = [productNameWithoutUnicode rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if (nameRange.location != NSNotFound) {
            [arrResultProduct addObject:product];
        }
    }
    return arrResultProduct;
    
    
    if (arrResultProduct.count == 0) {
        for (JKProduct *product in arrProduct) {
            NSRange nameRange = [product.product_code rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (nameRange.location != NSNotFound) {
                [arrResultProduct addObject:product];
            }
        }
        return arrResultProduct;
    }
    
    
}

- (IBAction)buttonMapPressed:(id)sender {
    IIViewDeckController *deckViewController = (IIViewDeckController*)[JKAppDelegate getRootViewController];
    JKNavigationViewController *centralNavVC = (JKNavigationViewController *) deckViewController.centerController;
    [centralNavVC setViewControllers:[NSArray arrayWithObject:[[JKMapViewController alloc]init]] animated:YES];
    [deckViewController toggleLeftViewAnimated:YES];
}

- (IBAction)buttonCallPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:0909226976"]];
}

- (void)refreshButtonPressed{
    [self loadCategoryMenu];
}

- (void)loadCategoryMenu{
    [[JKCategoryManager sharedInstance] getMenuListOnComplete:^(NSArray *menu) {
        self.arrMenu = [menu mutableCopy];
        [self.menuTableView reloadData];
    } orFailure:^(NSError *error) {
        DLog(@"Error when load menu");
    }];
}
@end
