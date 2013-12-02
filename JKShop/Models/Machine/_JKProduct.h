// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JKProduct.h instead.

#import <CoreData/CoreData.h>


extern const struct JKProductAttributes {
	__unsafe_unretained NSString *category_id;
	__unsafe_unretained NSString *color;
	__unsafe_unretained NSString *cover_image;
	__unsafe_unretained NSString *detail;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *price;
	__unsafe_unretained NSString *product_code;
	__unsafe_unretained NSString *product_id;
	__unsafe_unretained NSString *sale_price;
	__unsafe_unretained NSString *size;
	__unsafe_unretained NSString *stock;
	__unsafe_unretained NSString *stock_status;
} JKProductAttributes;

extern const struct JKProductRelationships {
	__unsafe_unretained NSString *category;
	__unsafe_unretained NSString *images;
} JKProductRelationships;

extern const struct JKProductFetchedProperties {
} JKProductFetchedProperties;

@class NSManagedObject;
@class JKProductImages;














@interface JKProductID : NSManagedObjectID {}
@end

@interface _JKProduct : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (JKProductID*)objectID;





@property (nonatomic, strong) NSString* category_id;



//- (BOOL)validateCategory_id:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* color;



//- (BOOL)validateColor:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* cover_image;



//- (BOOL)validateCover_image:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* detail;



//- (BOOL)validateDetail:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* price;



//- (BOOL)validatePrice:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* product_code;



//- (BOOL)validateProduct_code:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* product_id;



@property int32_t product_idValue;
- (int32_t)product_idValue;
- (void)setProduct_idValue:(int32_t)value_;

//- (BOOL)validateProduct_id:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* sale_price;



//- (BOOL)validateSale_price:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* size;



//- (BOOL)validateSize:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* stock;



//- (BOOL)validateStock:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* stock_status;



//- (BOOL)validateStock_status:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSManagedObject *category;

//- (BOOL)validateCategory:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *images;

- (NSMutableSet*)imagesSet;





@end

@interface _JKProduct (CoreDataGeneratedAccessors)

- (void)addImages:(NSSet*)value_;
- (void)removeImages:(NSSet*)value_;
- (void)addImagesObject:(JKProductImages*)value_;
- (void)removeImagesObject:(JKProductImages*)value_;

@end

@interface _JKProduct (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveCategory_id;
- (void)setPrimitiveCategory_id:(NSString*)value;




- (NSString*)primitiveColor;
- (void)setPrimitiveColor:(NSString*)value;




- (NSString*)primitiveCover_image;
- (void)setPrimitiveCover_image:(NSString*)value;




- (NSString*)primitiveDetail;
- (void)setPrimitiveDetail:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitivePrice;
- (void)setPrimitivePrice:(NSString*)value;




- (NSString*)primitiveProduct_code;
- (void)setPrimitiveProduct_code:(NSString*)value;




- (NSNumber*)primitiveProduct_id;
- (void)setPrimitiveProduct_id:(NSNumber*)value;

- (int32_t)primitiveProduct_idValue;
- (void)setPrimitiveProduct_idValue:(int32_t)value_;




- (NSString*)primitiveSale_price;
- (void)setPrimitiveSale_price:(NSString*)value;




- (NSString*)primitiveSize;
- (void)setPrimitiveSize:(NSString*)value;




- (NSString*)primitiveStock;
- (void)setPrimitiveStock:(NSString*)value;




- (NSString*)primitiveStock_status;
- (void)setPrimitiveStock_status:(NSString*)value;





- (NSManagedObject*)primitiveCategory;
- (void)setPrimitiveCategory:(NSManagedObject*)value;



- (NSMutableSet*)primitiveImages;
- (void)setPrimitiveImages:(NSMutableSet*)value;


@end
