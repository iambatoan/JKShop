//
//  JKNavigationViewController.m
//  JKShop
//
//  Created by admin on 11/30/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKNavigationViewController.h"

@interface JKNavigationViewController ()

@end

@implementation JKNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbg.png"] forBarMetrics:UIBarMetricsDefault];
            [self.navigationBar setTranslucent:YES];
        }
    }
    return self;
}

@end
