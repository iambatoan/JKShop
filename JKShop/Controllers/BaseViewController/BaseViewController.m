//
//  BaseViewController.m
//  OrangeFashion
//
//  Created by Khang on 15/6/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "BaseViewController.h"
#import "IIViewDeckController.h"

@interface BaseViewController()
<
IIViewDeckControllerDelegate
>

@end

@implementation BaseViewController

#pragma mark - View controller lifecycle

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self trackCrittercismBreadCrumb:__LINE__];
    [self addNavigationItems];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addNavigationItems)
                                                 name:NOTIF_CHANGE_BOOKMARK_PRODUCT_COUNT
                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(reachabilityDidChange:)
//                                                 name:kReachabilityChangedNotification
//                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.title) {
        self.screenName = self.title;
    }
    [super viewDidAppear:animated];
}

#pragma mark - Helper methods

- (void)addNavigationItems
{
    
    NSDictionary *textTitleOptions = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor titleColor], UITextAttributeTextColor, [UIColor whiteColor], UITextAttributeTextShadowColor, nil];
    [[UINavigationBar appearance] setTitleTextAttributes:textTitleOptions];
    
    // Nav left button
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (self == [[self.navigationController viewControllers] objectAtIndex:0]) {
        [leftButton setImage:[UIImage imageNamed:@"left-nav-button"] forState:UIControlStateNormal];
        [leftButton addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [leftButton setImage:[UIImage imageNamed:@"nav-back-btn-bg"] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(onBtnBack) forControlEvents:UIControlEventTouchUpInside];
    }

    leftButton.frame = CGRectMake(0, 0, 35, 35);
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    // Nav right button
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"bookmark_list"] forState:UIControlStateNormal];
    [rightButton addTarget:self.viewDeckController action:@selector(toggleRightView) forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake(0, 0, 25, 25);
    
    UILabel *labelCount = [[UILabel alloc] initWithFrame:CGRectMake(4.5, 7, 15, 15)];
    [labelCount setFont:[UIFont fontWithName:@"Lato" size:10]];
    [labelCount setTextColor:[UIColor titleColor]];
    labelCount.textAlignment = NSTextAlignmentCenter;
    labelCount.text = [NSString stringWithFormat:@"%d",[JKProductManager getAllBookmarkProductCount]];
    [rightButton addSubview:labelCount];
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

- (void)onBtnBack
{    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Crittercism initialize

- (void)trackCrittercismBreadCrumb:(NSUInteger)lineNumber
{
    NSString *breadcrumb = [NSString stringWithFormat:@"%@:%d", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], lineNumber];
    [Crittercism leaveBreadcrumb:breadcrumb];
}

- (void)reachabilityDidChange:(NSNotification *)notification {

//    if ([JKReachabilityManager isReachable]) {
//        if (![JKReachabilityManager sharedInstance].lastState) {
//            [TSMessage showNotificationInViewController:self
//                                                  title:@"Connecting.."
//                                                   type:TSMessageNotificationTypeMessage
//                                               duration:2
//                                             atPosition:TSMessageNotificationPositionBottom];
//            
//            [TSMessage showNotificationInViewController:self
//                                                  title:@"Connected"
//                                                   type:TSMessageNotificationTypeSuccess
//                                               duration:1
//                                             atPosition:TSMessageNotificationPositionBottom];
//        }
//        [JKReachabilityManager sharedInstance].lastState = 1;
//        return;
//    }
//    if ([JKReachabilityManager sharedInstance].lastState) {
//        [TSMessage dismissActiveNotification];
//        [TSMessage showNotificationInViewController:self
//                                              title:@"No connection"
//                                               type:TSMessageNotificationTypeError
//                                           duration:5
//                                         atPosition:TSMessageNotificationPositionBottom];
//        [JKReachabilityManager sharedInstance].lastState = 0;
//    }
}

@end
