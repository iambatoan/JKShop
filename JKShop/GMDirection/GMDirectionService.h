//
//  GMDirectionService.h
//  speakeasy
//
//  Created by Djengo on 8/02/13.
//  Copyright (c) 2013 Djengo. Under MIT Licence.
//  http://opensource.org/licenses/MIT

#import <Foundation/Foundation.h>
#import "GMHTTPClient.h"
#import "GMDirection.h"

@interface GMDirectionService : NSObject

- (void)getDirectionsFrom:(NSString*)origin to:(NSString*)destination succeeded:(void(^)(GMDirection *directionResponse))success failed: (void (^)(NSError *error))failure;
+ (GMDirectionService*)sharedInstance;

@end