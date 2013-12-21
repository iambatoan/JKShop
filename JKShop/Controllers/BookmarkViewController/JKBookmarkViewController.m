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
#import "JKPopupBookmark.h"

static NSString * const STORE_PRODUCT_BOOKMARK      =   @"store_product_bookmark";
static NSString * const STORE_PRODUCT_ID            =   @"store_product_id";
static NSString * const STORE_PRODUCT_NUMBER        =   @"store_product_number";

@interface JKBookmarkViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
UIAlertViewDelegate,
SWTableViewCellDelegate,
UAModalPanelDelegate,
JKPopupBookmarkDelegate
>

@property (strong, nonatomic) NSMutableArray * bookmarkProductArray;

@end

@implementation JKBookmarkViewController

#pragma mark - View controller lifecycle

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

#pragma mark - Table view datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JKBookmarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JKBookmarkTableViewCell class]) forIndexPath:indexPath];

    [cell setHeight:[JKBookmarkTableViewCell getHeight]];
    
    [cell configWithDictionary:[self.bookmarkProductArray objectAtIndex:indexPath.row]];

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

#pragma mark - Button delete all action

- (IBAction)buttonDeleteAllPressed:(id)sender {
    if (![[JKProductManager sharedInstance] getBookmarkProducts].count) {
        [SVProgressHUD showErrorWithStatus:@"List is empty!"];
        return;
    }
    
    SIAlertView *alert = [[SIAlertView alloc] initWithTitle:@"Warning!" andMessage:@"Do you want to delete all?"];
    [alert addButtonWithTitle:@"Yes"
                         type:SIAlertViewButtonTypeDestructive
                      handler:^(SIAlertView *alert){
                          [JKProductManager removeAllBookmarkProduct];
                          self.bookmarkProductArray = [[JKProductManager alloc] getBookmarkProducts];
                          [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_CHANGE_BOOKMARK_PRODUCT_COUNT object:self];
                          [self.bookmarkTableView reloadData];
                      }];
    
    [alert addButtonWithTitle:@"No"
                         type:SIAlertViewButtonTypeCancel
                      handler:nil];

    alert.transitionStyle = SIAlertViewTransitionStyleBounce;
    alert.backgroundStyle = SIAlertViewBackgroundStyleSolid;
    
    [alert show];
}

#pragma mark - Swipeable Cell Action

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSIndexPath *indexPath = [self.bookmarkTableView indexPathForCell:cell];
    
    switch (index) {
        case 0:
        {
            JKPopupBookmark *modalPanel = [[JKPopupBookmark alloc] initWithFrame:self.view.bounds];
            [modalPanel.stepper setValue:[self getNumberProductFromStoreBookmarkAtIndex:indexPath.row]];
            [modalPanel loadDetailWithProduct:[self getProductFromStoreBookmarkAtIndex:indexPath.row]];
            IIViewDeckController *deckViewController = (IIViewDeckController*)[JKAppDelegate getRootViewController];
            [deckViewController setRightSize:0];
            [self.view addSubview:modalPanel];
            modalPanel.onClosePressed = ^(UAModalPanel* panel) {
                [deckViewController setRightSize:40];
                [panel hide];
            };
            modalPanel.JKDelegate = self;
            [modalPanel showFromPoint:[self.view center]];
            break;
        }
        case 1:
        {
            [[JKProductManager sharedInstance] removeBookmarkProductWithProductID:[[self.bookmarkProductArray objectAtIndex:indexPath.row] objectForKey:STORE_PRODUCT_ID]];
            [self.bookmarkProductArray removeObjectAtIndex:indexPath.row];
            [self.bookmarkTableView deleteRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_CHANGE_BOOKMARK_PRODUCT_COUNT object:self];
            
            [self.bookmarkTableView reloadData];
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
     [UIColor colorWithRed:255/255.0 green:102/255.0 blue:102/255.0 alpha:1.0f]
                                                title:@"Delete"];
    
    return rightUtilityButtons;
}

- (void)onLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        CGPoint p = [gestureRecognizer locationInView:self.bookmarkTableView];
        
        NSIndexPath *indexPath = [self.bookmarkTableView indexPathForRowAtPoint:p];
        JKPopupBookmark *modalPanel = [[JKPopupBookmark alloc] initWithFrame:self.view.bounds];
        [modalPanel.stepper setValue:[self getNumberProductFromStoreBookmarkAtIndex:indexPath.row]];
        [modalPanel loadDetailWithProduct:[self getProductFromStoreBookmarkAtIndex:indexPath.row]];
        IIViewDeckController *deckViewController = (IIViewDeckController*)[JKAppDelegate getRootViewController];
        [deckViewController setRightSize:0];
        [self.view addSubview:modalPanel];
        modalPanel.onClosePressed = ^(UAModalPanel* panel) {
            [deckViewController setRightSize:40];
            [panel hide];
        };
        modalPanel.JKDelegate = self;
        [modalPanel showFromPoint:[self.view center]];
    }
}

#pragma mark - Helper methods

- (NSInteger)getTotalPrice{
    int total = 0;
    for (NSDictionary *dic in self.bookmarkProductArray) {
        total += [[dic objectForKey:STORE_PRODUCT_NUMBER] integerValue] * [JKProduct getProductPriceWithProductId:[dic objectForKey:STORE_PRODUCT_ID]];
    }
    return total;
}

- (JKProduct *)getProductFromStoreBookmarkAtIndex:(NSInteger)index{
    return [[JKProduct MR_findByAttribute:@"product_id" withValue:[[self.bookmarkProductArray objectAtIndex:index] objectForKey:STORE_PRODUCT_ID]] lastObject];
}

- (NSInteger)getNumberProductFromStoreBookmarkAtIndex:(NSInteger)index{
    return [[[self.bookmarkProductArray objectAtIndex:index] objectForKey:STORE_PRODUCT_NUMBER] integerValue];
}

#pragma mark - JK popup bookmark delegate

- (void)didPressConfirmButton:(JKPopupBookmark *)modalPanel{
    [[JKProductManager sharedInstance] updateProductWithProductID:modalPanel.product.product_id withNumber:[modalPanel.stepper value]];
    [SVProgressHUD showSuccessWithStatus:@"Confirm successful"];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_CHANGE_BOOKMARK_PRODUCT_COUNT object:self];
    IIViewDeckController *deckViewController = (IIViewDeckController*)[JKAppDelegate getRootViewController];
    [deckViewController setRightSize:40];
    
    self.bookmarkProductArray = [[JKProductManager alloc] getBookmarkProducts];
    [self.bookmarkTableView reloadData];
}


@end
