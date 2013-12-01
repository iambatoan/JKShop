// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JKProductImages.h instead.

#import <CoreData/CoreData.h>


extern const struct JKProductImagesAttributes {
	__unsafe_unretained NSString *imageURL;
	__unsafe_unretained NSString *image_id;
	__unsafe_unretained NSString *product_id;
	__unsafe_unretained NSString *size;
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





@property (nonatomic, strong) NSString* imageURL;



//- (BOOL)validateImageURL:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* image_id;



@property int32_t image_idValue;
- (int32_t)image_idValue;
- (void)setImage_idValue:(int32_t)value_;

//- (BOOL)validateImage_id:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* product_id;



@property int32_t product_idValue;
- (int32_t)product_idValue;
- (void)setProduct_idValue:(int32_t)value_;

//- (BOOL)validateProduct_id:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* size;



//- (BOOL)validateSize:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) JKProduct *product;

//- (BOOL)validateProduct:(id*)value_ error:(NSError**)error_;





@end

@interface _JKProductImages (CoreDataGeneratedAccessors)

@end

@interface _JKProductImages (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveImageURL;
- (void)setPrimitiveImageURL:(NSString*)value;




- (NSNumber*)primitiveImage_id;
- (void)setPrimitiveImage_id:(NSNumber*)value;

- (int32_t)primitiveImage_idValue;
- (void)setPrimitiveImage_idValue:(int32_t)value_;




- (NSNumber*)primitiveProduct_id;
- (void)setPrimitiveProduct_id:(NSNumber*)value;

- (int32_t)primitiveProduct_idValue;
- (void)setPrimitiveProduct_idValue:(int32_t)value_;




- (NSString*)primitiveSize;
- (void)setPrimitiveSize:(NSString*)value;





- (JKProduct*)primitiveProduct;
- (void)setPrimitiveProduct:(JKProduct*)value;


@end
