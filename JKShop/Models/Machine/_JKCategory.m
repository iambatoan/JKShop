// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JKCategory.m instead.

#import "_JKCategory.h"

const struct JKCategoryAttributes JKCategoryAttributes = {
	.category_id = @"category_id",
	.name = @"name",
	.parent_id = @"parent_id",
};

const struct JKCategoryRelationships JKCategoryRelationships = {
	.product = @"product",
};

const struct JKCategoryFetchedProperties JKCategoryFetchedProperties = {
};

@implementation JKCategoryID
@end

@implementation _JKCategory

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"JKCategory" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"JKCategory";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"JKCategory" inManagedObjectContext:moc_];
}

- (JKCategoryID*)objectID {
	return (JKCategoryID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"category_idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"category_id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"parent_idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"parent_id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic category_id;



- (int32_t)category_idValue {
	NSNumber *result = [self category_id];
	return [result intValue];
}

- (void)setCategory_idValue:(int32_t)value_ {
	[self setCategory_id:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveCategory_idValue {
	NSNumber *result = [self primitiveCategory_id];
	return [result intValue];
}

- (void)setPrimitiveCategory_idValue:(int32_t)value_ {
	[self setPrimitiveCategory_id:[NSNumber numberWithInt:value_]];
}





@dynamic name;






@dynamic parent_id;



- (int32_t)parent_idValue {
	NSNumber *result = [self parent_id];
	return [result intValue];
}

- (void)setParent_idValue:(int32_t)value_ {
	[self setParent_id:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveParent_idValue {
	NSNumber *result = [self primitiveParent_id];
	return [result intValue];
}

- (void)setPrimitiveParent_idValue:(int32_t)value_ {
	[self setPrimitiveParent_id:[NSNumber numberWithInt:value_]];
}





@dynamic product;

	
- (NSMutableSet*)productSet {
	[self willAccessValueForKey:@"product"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"product"];
  
	[self didAccessValueForKey:@"product"];
	return result;
}
	






@end
