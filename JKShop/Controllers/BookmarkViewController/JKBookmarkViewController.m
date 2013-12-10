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
#import "JKBookmarkTableFooter.h"

static NSString * const STORE_PRODUCT_BOOKMARK      =   @"store_product_bookmark";
static NSString * const STORE_PRODUCT_ID            =   @"store_product_id";
static NSString * const STORE_PRODUCT_NUMBER        =   @"store_product_number";

@interface JKBookmarkViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (strong, nonatomic) NSMutableArray * bookmarkProductArray;
@property (weak, nonatomic) IBOutlet UITableView *bookmarkTableView;

@end

@implementation JKBookmarkViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.bookmarkTableView registerNib:[UINib nibWithNibName:NSStringFromClass([JKBookmarkTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([JKBookmarkTableViewCell class])];
    [self.bookmarkTableView registerNib:[UINib nibWithNibName:NSStringFromClass([JKBookmarkTableHeader class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([JKBookmarkTableHeader class])];
    [self.bookmarkTableView registerNib:[UINib nibWithNibName:NSStringFromClass([JKBookmarkTableFooter class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([JKBookmarkTableFooter class])];
}

- (void)viewWillAppear:(BOOL)animated{
    self.bookmarkProductArray = [[JKProductManager alloc] getBookmarkProducts];
    [self.bookmarkTableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JKBookmarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JKBookmarkTableViewCell class]) forIndexPath:indexPath];
    [cell configWithProduct:[self getProductFromStoreBookmark:[self.bookmarkProductArray objectAtIndex:indexPath.row]] andNumber:1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [JKBookmarkTableHeader getHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [JKBookmarkTableViewCell getHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return [JKBookmarkTableFooter getHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bookmarkProductArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    JKBookmarkTableHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([JKBookmarkTableHeader class])];
    [header changeNumberOfBookmarkProduct:[self getNumberOfBookmarkProduct]];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    header.labelTotal.text = [NSString stringWithFormat:@"%@ VNĐ", [formatter stringFromNumber:[NSNumber numberWithInteger:[self getTotalPrice]]]];
    
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    JKBookmarkTableFooter *footer = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JKBookmarkTableFooter class])];
    if (!footer) {
        footer = [[JKBookmarkTableFooter alloc] init];
    }
    return footer;
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

- (NSInteger)getNumberOfBookmarkProduct{
    int count = 0;
    for (NSDictionary *dic in self.bookmarkProductArray) {
        count += [[dic objectForKey:STORE_PRODUCT_NUMBER] integerValue];
    }
    return count;
}

@end
