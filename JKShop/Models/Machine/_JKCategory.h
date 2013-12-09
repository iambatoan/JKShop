// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JKCategory.h instead.

#import <CoreData/CoreData.h>


extern const struct JKCategoryAttributes {
	__unsafe_unretained NSString *category_id;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *parent_id;
} JKCategoryAttributes;

extern const struct JKCategoryRelationships {
	__unsafe_unretained NSString *product;
} JKCategoryRelationships;

extern const struct JKCategoryFetchedProperties {
} JKCategoryFetchedProperties;

@class JKProduct;





@interface JKCategoryID : NSManagedObjectID {}
@end

@interface _JKCategory : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (JKCategoryID*)objectID;





@property (nonatomic, strong) NSNumber* category_id;



@property int32_t category_idValue;
- (int32_t)category_idValue;
- (void)setCategory_idValue:(int32_t)value_;

//- (BOOL)validateCategory_id:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* parent_id;



@property int32_t parent_idValue;
- (int32_t)parent_idValue;
- (void)setParent_idValue:(int32_t)value_;

//- (BOOL)validateParent_id:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *product;

- (NSMutableSet*)productSet;





@end

@interface _JKCategory (CoreDataGeneratedAccessors)

- (void)addProduct:(NSSet*)value_;
- (void)removeProduct:(NSSet*)value_;
- (void)addProductObject:(JKProduct*)value_;
- (void)removeProductObject:(JKProduct*)value_;

@end

@interface _JKCategory (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveCategory_id;
- (void)setPrimitiveCategory_id:(NSNumber*)value;

- (int32_t)primitiveCategory_idValue;
- (void)setPrimitiveCategory_idValue:(int32_t)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSNumber*)primitiveParent_id;
- (void)setPrimitiveParent_id:(NSNumber*)value;

- (int32_t)primitiveParent_idValue;
- (void)setPrimitiveParent_idValue:(int32_t)value_;





- (NSMutableSet*)primitiveProduct;
- (void)setPrimitiveProduct:(NSMutableSet*)value;


@end
