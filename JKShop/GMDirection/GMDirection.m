//
//  GMDirection.m
//  speakeasy
//
//  Created by Djengo on 8/02/13.
//  Copyright (c) 2013 Djengo. Under MIT Licence.
//  http://opensource.org/licenses/MIT

#import "GMDirection.h"

static const NSString *ROUTES   = @"routes";
static const NSString *LEGS     = @"legs";
static const NSString *DISTANCE = @"distance";
static const NSString *DURATION = @"duration";
static const NSString *VALUE    = @"value";
static const NSString *TEXT     = @"text";
static const NSString *STATUS   = @"status";

static NSString *STATUS_OK                       = @"OK";
static NSString *STATUS_NOT_FOUND                = @"NOT_FOUND";
static NSString *STATUS_ZERO_RESULTS             = @"ZERO_RESULTS";
static NSString *STATUS_MAX_WAYPOINTS_EXCEEDED   = @"MAX_WAYPOINTS_EXCEEDED";
static NSString *STATUS_INVALID_REQUEST          = @"INVALID_REQUEST";
static NSString *STATUS_OVER_QUERY_LIMIT         = @"OVER_QUERY_LIMIT";
static NSString *STATUS_REQUEST_DENIED           = @"REQUEST_DENIED";
static NSString *STATUS_UNKNOWN_ERROR            = @"UNKNOWN_ERROR";

@implementation GMDirection

@synthesize directionResponse;

+ (GMDirection*)initWithDirectionResponse:(NSDictionary*)directionResponse
{
    GMDirection *direction = [[GMDirection alloc] init];
    [direction setDirectionResponse:directionResponse];
    return direction;
}

- (NSString*)status
{
    return [[self directionResponse] objectForKey:STATUS];
}

- (BOOL)statusOK
{
    return [[self status] isEqualToString:STATUS_OK];
}

- (BOOL)statusNotFound
{
    return [[self status] isEqualToString:STATUS_NOT_FOUND];
}

- (BOOL)statusZeroResults
{
    return [[self status] isEqualToString:STATUS_ZERO_RESULTS];
}

- (BOOL)statusMaxWaypointsExceeded
{
    return [[self status] isEqualToString:STATUS_MAX_WAYPOINTS_EXCEEDED];
}

- (BOOL)statusInvalidRequest
{
    return [[self status] isEqualToString:STATUS_INVALID_REQUEST];
}

- (BOOL)statusOverQueryLimit
{
    return [[self status] isEqualToString:STATUS_OVER_QUERY_LIMIT];
}

- (BOOL)statusUnknownError
{
    return [[self status] isEqualToString:STATUS_UNKNOWN_ERROR];
}


- (NSArray*)routes
{
    return [[self directionResponse] objectForKey:ROUTES];
}

- (NSDictionary*)firstRoute
{
    return [[self routes] objectAtIndex:0];
}

- (NSArray*)legs
{
    return [[self firstRoute] objectForKey:LEGS];
}

- (NSDictionary*)firstLeg
{
    return [[self legs] objectAtIndex:0];
}

- (NSDictionary*)distance
{
    return [[self firstLeg] objectForKey:DISTANCE];
}

- (NSNumber*)distanceInMeters
{
    return [[self distance] objectForKey:VALUE];
}

- (NSString*)distanceHumanized
{
    return [[self distance] objectForKey:TEXT];
}

- (NSDictionary*)duration
{
    return [[self firstLeg] objectForKey:DURATION];
}

- (NSNumber*)durationInSec
{
    return [[self duration] objectForKey:VALUE];
}

- (NSString*)durationHumanized
{
    return [[self duration] objectForKey:TEXT];
}

@end
