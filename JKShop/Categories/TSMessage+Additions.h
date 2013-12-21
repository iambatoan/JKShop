//
//  TSMessage+Additions.h
//  JKShop
//
//  Created by admin on 12/21/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "TSMessage.h"

@interface TSMessage (Additions)

+ (void)showNotificationInViewController:(UIViewController *)viewController
                                   title:(NSString *)title
                                    type:(TSMessageNotificationType)type
                                duration:(TSMessageNotificationDuration)duration
                              atPosition:(TSMessageNotificationPosition)position;

@end
