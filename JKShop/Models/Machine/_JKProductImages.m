// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JKProductImages.m instead.

#import "_JKProductImages.h"

const struct JKProductImagesAttributes JKProductImagesAttributes = {
	.image_id = @"image_id",
	.large_URL = @"large_URL",
	.medium_URL = @"medium_URL",
	.product_id = @"product_id",
	.small_URL = @"small_URL",
};

const struct JKProductImagesRelationships JKProductImagesRelationships = {
	.product = @"product",
};

const struct JKProductImagesFetchedProperties JKProductImagesFetchedProperties = {
};

@implementation JKProductImagesID
@end

@implementation _JKProductImages

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"JKProductImages" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"JKProductImages";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"JKProductImages" inManagedObjectContext:moc_];
}

- (JKProductImagesID*)objectID {
	return (JKProductImagesID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"image_idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"image_id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"product_idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"product_id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic image_id;



- (int32_t)image_idValue {
	NSNumber *result = [self image_id];
	return [result intValue];
}

- (void)setImage_idValue:(int32_t)value_ {
	[self setImage_id:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveImage_idValue {
	NSNumber *result = [self primitiveImage_id];
	return [result intValue];
}

- (void)setPrimitiveImage_idValue:(int32_t)value_ {
	[self setPrimitiveImage_id:[NSNumber numberWithInt:value_]];
}





@dynamic large_URL;






@dynamic medium_URL;






@dynamic product_id;



- (int32_t)product_idValue {
	NSNumber *result = [self product_id];
	return [result intValue];
}

- (void)setProduct_idValue:(int32_t)value_ {
	[self setProduct_id:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveProduct_idValue {
	NSNumber *result = [self primitiveProduct_id];
	return [result intValue];
}

- (void)setPrimitiveProduct_idValue:(int32_t)value_ {
	[self setPrimitiveProduct_id:[NSNumber numberWithInt:value_]];
}





@dynamic small_URL;






@dynamic product;

	






@end
