// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JKProductImages.h instead.

#import <CoreData/CoreData.h>


extern const struct JKProductImagesAttributes {
	__unsafe_unretained NSString *image_id;
	__unsafe_unretained NSString *large_URL;
	__unsafe_unretained NSString *medium_URL;
	__unsafe_unretained NSString *product_id;
	__unsafe_unretained NSString *small_URL;
} JKProductImagesAttributes;

extern const struct JKProductImagesRelationships {
	__unsafe_unretained NSString *product;
} JKProductImagesRelationships;

extern const struct JKProductImagesFetchedProperties {
} JKProductImagesFetchedProperties;

@class JKProduct;







@interface JKProductImagesID : NSManagedObjectID {}
@end

@interface _JKProductImages : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (JKProductImagesID*)objectID;





@property (nonatomic, strong) NSNumber* image_id;



@property int32_t image_idValue;
- (int32_t)image_idValue;
- (void)setImage_idValue:(int32_t)value_;

//- (BOOL)validateImage_id:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* large_URL;



//- (BOOL)validateLarge_URL:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* medium_URL;



//- (BOOL)validateMedium_URL:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* product_id;



@property int32_t product_idValue;
- (int32_t)product_idValue;
- (void)setProduct_idValue:(int32_t)value_;

//- (BOOL)validateProduct_id:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* small_URL;



//- (BOOL)validateSmall_URL:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) JKProduct *product;

//- (BOOL)validateProduct:(id*)value_ error:(NSError**)error_;





@end

@interface _JKProductImages (CoreDataGeneratedAccessors)

@end

@interface _JKProductImages (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveImage_id;
- (void)setPrimitiveImage_id:(NSNumber*)value;

- (int32_t)primitiveImage_idValue;
- (void)setPrimitiveImage_idValue:(int32_t)value_;




- (NSString*)primitiveLarge_URL;
- (void)setPrimitiveLarge_URL:(NSString*)value;




- (NSString*)primitiveMedium_URL;
- (void)setPrimitiveMedium_URL:(NSString*)value;




- (NSNumber*)primitiveProduct_id;
- (void)setPrimitiveProduct_id:(NSNumber*)value;

- (int32_t)primitiveProduct_idValue;
- (void)setPrimitiveProduct_idValue:(int32_t)value_;




- (NSString*)primitiveSmall_URL;
- (void)setPrimitiveSmall_URL:(NSString*)value;





- (JKProduct*)primitiveProduct;
- (void)setPrimitiveProduct:(JKProduct*)value;


@end
