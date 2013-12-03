// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JKProduct.m instead.

#import "_JKProduct.h"

const struct JKProductAttributes JKProductAttributes = {
	.color = @"color",
	.cover_image = @"cover_image",
	.detail = @"detail",
	.name = @"name",
	.price = @"price",
	.product_code = @"product_code",
	.product_id = @"product_id",
	.sale_price = @"sale_price",
	.size = @"size",
	.stock = @"stock",
	.stock_status = @"stock_status",
};

const struct JKProductRelationships JKProductRelationships = {
	.category = @"category",
	.images = @"images",
};

const struct JKProductFetchedProperties JKProductFetchedProperties = {
};

@implementation JKProductID
@end

@implementation _JKProduct

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"JKProduct" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"JKProduct";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"JKProduct" inManagedObjectContext:moc_];
}

- (JKProductID*)objectID {
	return (JKProductID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"product_idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"product_id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic color;






@dynamic cover_image;






@dynamic detail;






@dynamic name;






@dynamic price;






@dynamic product_code;






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





@dynamic sale_price;






@dynamic size;






@dynamic stock;






@dynamic stock_status;






@dynamic category;

	
- (NSMutableSet*)categorySet {
	[self willAccessValueForKey:@"category"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"category"];
  
	[self didAccessValueForKey:@"category"];
	return result;
}
	

@dynamic images;

	
- (NSMutableSet*)imagesSet {
	[self willAccessValueForKey:@"images"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"images"];
  
	[self didAccessValueForKey:@"images"];
	return result;
}
	






@end
