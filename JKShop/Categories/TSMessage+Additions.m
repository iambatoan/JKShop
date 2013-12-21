//
//  TSMessage+Additions.m
//  JKShop
//
//  Created by admin on 12/21/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "TSMessage+Additions.h"

@implementation TSMessage (Additions)

+ (void)showNotificationInViewController:(UIViewController *)viewController
                                   title:(NSString *)title
                                    type:(TSMessageNotificationType)type
                                duration:(TSMessageNotificationDuration)duration
                              atPosition:(TSMessageNotificationPosition)position
{
    [TSMessage showNotificationInViewController:viewController
                                          title:title
                                       subtitle:nil
                                          image:nil
                                           type:type
                                       duration:duration
                                       callback:nil
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition:position
                            canBeDismisedByUser:YES];
}

@end
