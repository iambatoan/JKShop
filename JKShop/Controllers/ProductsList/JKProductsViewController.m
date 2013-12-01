//
//  JKProductsViewController.m
//  JKShop
//
//  Created by admin on 12/1/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKProductsViewController.h"

@interface JKProductsViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
IIViewDeckControllerDelegate,
UISearchBarDelegate,
UISearchDisplayDelegate
>

@property (strong, nonatomic) NSMutableArray            * productsArr;
@property (assign, nonatomic) BOOL                        isSearching;
@property (strong, nonatomic) NSMutableArray            * filteredList;

@end

@implementation JKProductsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = DEFAULT_NAVIGATION_TITLE;
    if (![self.lblTitle isEqualToString:@""]) {
        self.title = self.lblTitle;
    }
    [self.tableProducts registerNib:[UINib nibWithNibName:@"JKProductsTableCell" bundle:nil] forCellReuseIdentifier:@"JKProductsTableCell"];
    
    self.productsArr = [[NSMutableArray alloc] init];
    
    self.isSearching = NO;
    self.filteredList = [[NSMutableArray alloc] init];

}

#warning CODING HERERERERERE    

@end
