//
//  JKHomeViewController.m
//  JKShop
//
//  Created by admin on 11/30/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKHomeViewController.h"
#import "MYIntroductionPanel.h"
#import "MYBlurIntroductionView.h"

@interface JKHomeViewController ()
<
MYIntroductionDelegate
>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@end

@implementation JKHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"JK Shop";
    self.viewDeckController.centerController.title = @"JK Shop";
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"logged_in"]) {
        [self buildIntro];
        return;
    }
}

-(void)buildIntro{
    CGRect panelFrame = [[UIScreen mainScreen] bounds];
    MYIntroductionPanel *panel1 = [[MYIntroductionPanel alloc] initWithFrame:panelFrame
                                                                       title:@"JK Shop"
                                                                 description:@"Welcome to JK Shop App for IOS!"
                                                                       image:[UIImage imageNamed:@"logo"]];
    
    MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithFrame:panelFrame
                                                                       title:@"JK Shop"
                                                                 description:@"Easy to use! No need to go physical shop, just call us and we will call you as soon as posible"
                                                                       image:[UIImage imageNamed:@"CheckMarkWhite"]];
    
    NSArray *panels = @[panel1,panel2];
    
    MYBlurIntroductionView *introductionView = [[MYBlurIntroductionView alloc] initWithFrame:panelFrame];
    
    introductionView.delegate = self;
    [introductionView setBackgroundColor:[UIColor colorWithRed:98.0f/255.0f green:127.0f/255.0f blue:200.0f/255.0f alpha:0.35]];
    introductionView.BackgroundImageView.image = [UIImage imageNamed:@"home1.jpg"];
    [introductionView buildIntroductionWithPanels:panels];
    
    self.navigationController.navigationBar.layer.zPosition = -1;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    [self.view addSubview:introductionView];
}

-(void)introduction:(MYBlurIntroductionView *)introductionView didFinishWithType:(MYFinishType)finishType{
    self.navigationController.navigationBar.layer.zPosition = 1;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"logged_in"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
