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
#import "JKGiftViewController.h"

static CGFloat const LEFT_SIZE = 44;
static CGFloat const LOGIN_VIEW_HEIGHT = 70;
static CGFloat const SCREEN_WIDTH = 320;

@interface JKLeftMenuViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
UISearchDisplayDelegate,
UISearchBarDelegate,
UIAlertViewDelegate,
FacebookManagerDelegate,
UIScrollViewDelegate
>

@property (assign, nonatomic) BOOL                                isSearching;
@property (strong, nonatomic) NSMutableArray                    * arrMenu;
@property (strong, nonatomic) NSMutableArray                    * filteredList;
@property (strong, nonatomic) NSArray                           * arrSection;
@property (strong, nonatomic) NSArray                           * arrIconSection;
@property (strong, nonatomic) NSArray                           * arrSubMenuSectionOne;
@property (weak, nonatomic) IBOutlet UITableView                * menuTableView;
@property (weak, nonatomic) IBOutlet UIView                     * searchBarView;
@property (weak, nonatomic) IBOutlet UIView                     * profileView;
@property (weak, nonatomic) IBOutlet UILabel                    * userName;
@property (weak, nonatomic) IBOutlet UIView                     * loginView;
@property (weak, nonatomic) IBOutlet FBProfilePictureView       * userProfilePicture;

@end

@implementation JKLeftMenuViewController

#pragma mark - View controller lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.arrMenu = [[[JKCategoryManager sharedInstance] getMenuList] mutableCopy];
  
  self.arrSubMenuSectionOne = @[@"JK Shop", @"Contact us", @"Facebook Fanpage", @"Website"];
  self.arrSection = @[@"Featured", @"Category", @"Gift"];
  self.arrIconSection = @[@"star.png",@"category.png",@"gift.png"];
  
  [self.menuTableView registerNib:[UINib nibWithNibName:NSStringFromClass([JKSidebarMenuTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([JKSidebarMenuTableViewCell class])];
  [self.menuTableView registerNib:[UINib nibWithNibName:NSStringFromClass([JKLeftMenuSectionHeader class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([JKLeftMenuSectionHeader class])];
  
  [self loadCategoryMenu];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.menuTableView setContentOffset:CGPointMake(0, 44)];
  
  if ([FBSession activeSession].isOpen) {
    CGRect newFrame = CGRectMake(0, 0, SCREEN_WIDTH, LOGIN_VIEW_HEIGHT);
    self.profileView.frame = newFrame;
    
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
       if (!error) {
         self.userName.text = user.name;
         self.userProfilePicture.profileID = user[@"id"];
       }
     }];
  }
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
    [header configTitleNameWithString:@"Result"];
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
      NSDictionary *data = @{MENU_TITLE : @"Get lucky gift"};
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
    return;
  }
  
  switch (indexPath.section) {
    case 0:
      if (indexPath.row == 0) {
        [centralNavVC setViewControllers:[NSArray arrayWithObject:[[JKHomeViewController alloc] init]] animated:YES];
        [deckViewController toggleLeftViewAnimated:YES];
        return;
      }
      
      // Contact screen
      if (indexPath.row == 1) {
        BaseViewController *menu2 = [[BaseViewController alloc] init];
        CGRect frame = self.view.frame;
        
        UIWebView *web = [[UIWebView alloc] initWithFrame:frame];
        web.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [menu2.view addSubview:web];
        
        NSString *path = @"https://www.facebook.com/notes/jk-shop/c%C3%A1ch-th%E1%BB%A9c-mua-h%C3%A0ng/244994125626975";
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
        [web loadRequest:request];
        
        menu2.title = @"How to order";
        
        [centralNavVC setViewControllers:[NSArray arrayWithObject:menu2] animated:YES];
        [deckViewController toggleLeftViewAnimated:YES];
        [menu2 addNavigationItems];
        return;
      }
      
      
      if (indexPath.row == 2) {
        NSURL *url = [NSURL URLWithString:@"fb://profile/217999154993139"];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
          [[UIApplication sharedApplication] openURL:url];
          return;
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://facebook.com/jkshop.vn"]];
        return;
      }
      
      
      if (indexPath.row == 3) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://jkshop.vn"]];
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
      [centralNavVC setViewControllers:[NSArray arrayWithObject:[[JKGiftViewController alloc] init]] animated:YES];
      [deckViewController toggleLeftViewAnimated:YES];
      return;
      
    default:
      break;
  }
}

#pragma mark - Search displayController delegate

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
  self.isSearching = YES;
  
  [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:NSStringFromClass([JKSearchProductCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([JKSearchProductCell class])];
  IIViewDeckController *deckViewController = (IIViewDeckController*)[JKAppDelegate getRootViewController];
  [deckViewController setLeftSize:0];
  [self.searchBarView setWidth:320];
  CGRect frame = self.menuTableView.frame;
  frame.origin.y = 0;
  frame.size.height = [[UIScreen mainScreen] bounds].size.height;
  [UIView animateWithDuration:0.3f animations:^{
    self.menuTableView.frame = frame;
  }];
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller{
  self.isSearching = NO;
  
  IIViewDeckController *deckViewController = (IIViewDeckController*)[JKAppDelegate getRootViewController];
  [deckViewController setLeftSize:LEFT_SIZE];
  CGRect frame = self.menuTableView.frame;
  frame.origin.y = 78;
  frame.size.height = 429;
  [UIView animateWithDuration:0.3f animations:^{
    self.menuTableView.frame = frame;
  }];
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
  [self.menuTableView reloadData];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
  [self filterListForSearchText:searchString];
  if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
    CGRect frame = self.menuTableView.frame;
    frame.origin.y = -20;
    frame.size.height = [[UIScreen mainScreen] bounds].size.height + 20;
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
  NSArray *arrProduct = [JKProduct MR_findAllSortedBy:@"name" ascending:YES];
  
  for (JKProduct *product in arrProduct) {
    NSString *productNameWithoutUnicode = [[NSString alloc] initWithData:[product.name dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES] encoding:NSASCIIStringEncoding];
    NSRange nameRange = [productNameWithoutUnicode rangeOfString:searchText options:NSCaseInsensitiveSearch];
    if (nameRange.location != NSNotFound && product.images.count) {
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

#pragma mark - Footer button action

- (IBAction)buttonMapPressed:(id)sender {
  IIViewDeckController *deckViewController = (IIViewDeckController*)[JKAppDelegate getRootViewController];
  JKNavigationViewController *centralNavVC = (JKNavigationViewController *) deckViewController.centerController;
  [centralNavVC setViewControllers:[NSArray arrayWithObject:[[JKMapViewController alloc]init]] animated:YES];
  [deckViewController toggleLeftViewAnimated:YES];
}

- (IBAction)buttonCallPressed:(id)sender {
  if ([[[UIDevice currentDevice] model] isEqualToString:@"iPhone"]) {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:0909226976"]];
    return;
  }
  [SVProgressHUD showErrorWithStatus:@"No calling service"];
  
}

#pragma mark - Helper methods

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

- (IBAction)loginButtonAction:(id)sender {
#warning TOTOTOTOTOTOTOTOTOT
//  if ([JKReachabilityManager isUnreachable]) {
//    [SVProgressHUD showErrorWithStatus:@"No connection!"];
//    return;
//  }
  [FacebookManager sharedInstance].delegate = self;
  [[FacebookManager sharedInstance] openSessionWithAllowLoginUI:YES];
}

#pragma mark - Facebook delegate

- (void)facebookSessionStateChanged:(FacebookManager *)facebookManager{
  if ([FBSession activeSession].isOpen) {
    [UIView animateWithDuration:0.5
                     animations:^{
                       CGRect newFrame = CGRectMake(0, 0, SCREEN_WIDTH, LOGIN_VIEW_HEIGHT);
                       self.profileView.frame = newFrame;
                     }];
    return;
  }
  [UIView animateWithDuration:0.5
                   animations:^{
                     CGRect newFrame = CGRectMake(0, -LOGIN_VIEW_HEIGHT, SCREEN_WIDTH, LOGIN_VIEW_HEIGHT);
                     self.profileView.frame = newFrame;
                   }];
}

- (void)facebookLoginSucceeded:(FacebookManager *)facebookManager{
  [[FBRequest requestForMe] startWithCompletionHandler:
   ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
     if (!error) {
       self.userName.text = user.name;
       self.userProfilePicture.profileID = user[@"id"];
     }
   }];
}

#pragma mark - Facebook sign out button action

- (IBAction)signOutButtonAction:(id)sender {
  SIAlertView *alert = [[SIAlertView alloc] initWithTitle:@"Warning!" andMessage:@"Do you want to sign out?"];
  [alert addButtonWithTitle:@"Yes"
                       type:SIAlertViewButtonTypeDestructive
                    handler:^(SIAlertView *alert){
                      [[FacebookManager sharedInstance] logout];
                      [UIView animateWithDuration:0.5
                                       animations:^{
                                         CGRect newFrame = CGRectMake(0, -LOGIN_VIEW_HEIGHT, SCREEN_WIDTH, LOGIN_VIEW_HEIGHT);
                                         self.profileView.frame = newFrame;
                                       }];
                    }];
  
  [alert addButtonWithTitle:@"No"
                       type:SIAlertViewButtonTypeCancel
                    handler:nil];
  
  alert.transitionStyle = SIAlertViewTransitionStyleBounce;
  alert.backgroundStyle = SIAlertViewBackgroundStyleSolid;
  
  [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  if (buttonIndex == 0) {
    [[FacebookManager sharedInstance] logout];
    [UIView animateWithDuration:0.5
                     animations:^{
                       CGRect newFrame = CGRectMake(0, -LOGIN_VIEW_HEIGHT, SCREEN_WIDTH, LOGIN_VIEW_HEIGHT);
                       self.profileView.frame = newFrame;
                     }];
  }
}

@end
