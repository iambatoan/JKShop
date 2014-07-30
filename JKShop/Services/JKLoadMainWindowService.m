//
//  JKLoadMainWindowService.m
//  JKShop
//
//  Created by iSlan on 7/30/14.
//  Copyright (c) 2014 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKLoadMainWindowService.h"

static const CGFloat JKViewDeckRightViewControllerSize = 40.0f;

@implementation JKLoadMainWindowService

+ (instancetype)loadMainWindowService {
    return [[JKLoadMainWindowService alloc] init];
}

- (IIViewDeckController *)generateControllerStack {
    //Init navigation controller
    JKNavigationViewController* centralNavController = [[JKNavigationViewController alloc] initWithRootViewController:[[JKHomeViewController alloc] init]];
    
    //Init view deck controller
    IIViewDeckController* deckController =  [[IIViewDeckController alloc]
                                             initWithCenterViewController:centralNavController
                                             leftViewController:[[JKLeftMenuViewController alloc] init]
                                             rightViewController:[[JKBookmarkViewController alloc] init]];
    
    [deckController setNavigationControllerBehavior:IIViewDeckNavigationControllerIntegrated];
    [deckController setCenterhiddenInteractivity:IIViewDeckCenterHiddenNotUserInteractiveWithTapToCloseBouncing];
    
    deckController.rightSize = JKViewDeckRightViewControllerSize;
    return deckController;
}

- (JKAppDelegate *)appDelegate {
    return (JKAppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    IIViewDeckController *deckController = [self generateControllerStack];
    
    UIWindow *window = [self appDelegate].window;
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.rootViewController = deckController;
    [window makeKeyAndVisible];
    
    return YES;
}

@end
