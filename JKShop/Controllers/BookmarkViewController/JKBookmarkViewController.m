//
//  JKBookmarkViewController.m
//  JKShop
//
//  Created by admin on 12/9/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKBookmarkViewController.h"
#import "JKBookmarkTableHeader.h"
#import "JKBookmarkTableViewCell.h"

static NSString * const STORE_PRODUCT_BOOKMARK      =   @"store_product_bookmark";
static NSString * const STORE_PRODUCT_ID            =   @"store_product_id";
static NSString * const STORE_PRODUCT_NUMBER        =   @"store_product_number";

@interface JKBookmarkViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
UIAlertViewDelegate,
SWTableViewCellDelegate
>

@property (strong, nonatomic) NSMutableArray * bookmarkProductArray;

@end

@implementation JKBookmarkViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.bookmarkTableView registerNib:[UINib nibWithNibName:NSStringFromClass([JKBookmarkTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([JKBookmarkTableViewCell class])];
    [self.bookmarkTableView registerNib:[UINib nibWithNibName:NSStringFromClass([JKBookmarkTableHeader class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([JKBookmarkTableHeader class])];
}

- (void)viewWillAppear:(BOOL)animated{
    self.bookmarkProductArray = [[JKProductManager alloc] getBookmarkProducts];
    [self.bookmarkTableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JKBookmarkTableViewCell *cell = [self.bookmarkTableView dequeueReusableCellWithIdentifier:NSStringFromClass([JKBookmarkTableViewCell class]) forIndexPath:indexPath];

    [cell setHeight:[JKBookmarkTableViewCell getHeight]];
    [cell configWithProduct:[self getProductFromStoreBookmark:[self.bookmarkProductArray objectAtIndex:indexPath.row]] andNumber:[[[self.bookmarkProductArray objectAtIndex:indexPath.row] objectForKey:STORE_PRODUCT_NUMBER] intValue]];

    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [JKBookmarkTableHeader getHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [JKBookmarkTableViewCell getHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bookmarkProductArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    JKBookmarkTableHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([JKBookmarkTableHeader class])];
    [header changeNumberOfBookmarkProduct:[JKProductManager getAllBookmarkProductCount]];
    
    header.labelTotal.text = [NSString getVNCurrencyFormatterWithNumber:@([self getTotalPrice])];
    
    return header;
}

- (JKProduct *)getProductFromStoreBookmark:(NSDictionary *)storeBookmark{
    return [[JKProduct MR_findByAttribute:@"product_id" withValue:[storeBookmark objectForKey:STORE_PRODUCT_ID]] lastObject];
}

- (NSInteger)getTotalPrice{
    int total = 0;
    for (NSDictionary *dic in self.bookmarkProductArray) {
        total += [[dic objectForKey:STORE_PRODUCT_NUMBER] integerValue] * [JKProduct getProductPriceWithProductId:[dic objectForKey:STORE_PRODUCT_ID]];
    }
    return total;
}

- (IBAction)buttonDeleteAllPressed:(id)sender {
    if (![[JKProductManager sharedInstance] getBookmarkProducts].count) {
        [SVProgressHUD showErrorWithStatus:@"Không có sản phẩm trong giỏ hàng!"];
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Do you want to delete all?"
                                                   delegate:self
                                          cancelButtonTitle:@"Yes"
                                          otherButtonTitles:@"No", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [JKProductManager removeAllBookmarkProduct];
        self.bookmarkProductArray = [[JKProductManager alloc] getBookmarkProducts];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_CHANGE_BOOKMARK_PRODUCT_COUNT object:self];
        [self.bookmarkTableView reloadData];
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
            NSLog(@"More button was pressed");
            break;
        case 1:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.bookmarkTableView indexPathForCell:cell];
            
            [self.bookmarkProductArray removeObjectAtIndex:cellIndexPath.row];
            [self.bookmarkTableView deleteRowsAtIndexPaths:@[cellIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        default:
            break;
    }
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"More"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    return rightUtilityButtons;
}

@end
