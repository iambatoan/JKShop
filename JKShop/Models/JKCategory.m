#import "JKCategory.h"

@implementation JKCategory

+ (JKCategory *)categoryWithDictionary:(NSDictionary *)dictionary{
    
    JKCategory *category = [[JKCategory MR_findByAttribute:@"category_id" withValue:dictionary[@"term_id"] andOrderBy:@"name" ascending:YES] lastObject];
    
    if (category)
        return category;
    
    if (!category && ![dictionary[@"name"] isKindOfClass:[NSNull class]]) {
        category = [JKCategory MR_createEntity];
        category.category_id = [NSNumber numberWithInt:[dictionary[@"term_id"] intValue]];
        category.name = dictionary[@"name"];
    }
    return category;
}

- (NSInteger)getCategoryId{
    return [self.category_id integerValue];
}

- (NSString *)getCategoryName{
    return self.name;
}

@end
