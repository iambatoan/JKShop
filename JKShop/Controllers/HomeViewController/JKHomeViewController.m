//
//  JKHomeViewController.m
//  JKShop
//
//  Created by admin on 11/30/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKHomeViewController.h"

@interface JKHomeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@end

@implementation JKHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Hàng mới về";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
