//
//  NSString+Additions.m
//  JKShop
//
//  Created by Toan Slan on 12/11/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

+ (NSString *)getVNCurrencyFormatterWithNumber:(NSNumber *)inputNumber{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *string = [NSString stringWithFormat:@"%@ VNĐ", [formatter stringFromNumber:inputNumber]];
    return string;
}

@end
