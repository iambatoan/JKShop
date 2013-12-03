#import "_JKCategory.h"

@interface JKCategory : _JKCategory

+ (JKCategory *)categoryWithDictionary:(NSDictionary *)dictionary;
- (NSInteger)getCategoryId;
- (NSString *)getCategoryName;

@end
