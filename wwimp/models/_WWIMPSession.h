// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WWIMPSession.h instead.

@import CoreData;

extern const struct WWIMPSessionAttributes {
	__unsafe_unretained NSString *descriptionText;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *shelfImageURLString;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *urlString;
	__unsafe_unretained NSString *year;
} WWIMPSessionAttributes;

extern const struct WWIMPSessionRelationships {
	__unsafe_unretained NSString *focuses;
	__unsafe_unretained NSString *track;
} WWIMPSessionRelationships;

@class WWIMPFocus;
@class WWIMPTrack;

@interface WWIMPSessionID : NSManagedObjectID {}
@end

@interface _WWIMPSession : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) WWIMPSessionID* objectID;

@property (nonatomic, strong) NSString* descriptionText;

//- (BOOL)validateDescriptionText:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* id;

@property (atomic) int32_t idValue;
- (int32_t)idValue;
- (void)setIdValue:(int32_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* shelfImageURLString;

//- (BOOL)validateShelfImageURLString:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* urlString;

//- (BOOL)validateUrlString:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* year;

@property (atomic) int32_t yearValue;
- (int32_t)yearValue;
- (void)setYearValue:(int32_t)value_;

//- (BOOL)validateYear:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *focuses;

- (NSMutableSet*)focusesSet;

@property (nonatomic, strong) WWIMPTrack *track;

//- (BOOL)validateTrack:(id*)value_ error:(NSError**)error_;

@end

@interface _WWIMPSession (FocusesCoreDataGeneratedAccessors)
- (void)addFocuses:(NSSet*)value_;
- (void)removeFocuses:(NSSet*)value_;
- (void)addFocusesObject:(WWIMPFocus*)value_;
- (void)removeFocusesObject:(WWIMPFocus*)value_;

@end

@interface _WWIMPSession (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveDescriptionText;
- (void)setPrimitiveDescriptionText:(NSString*)value;

- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int32_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int32_t)value_;

- (NSString*)primitiveShelfImageURLString;
- (void)setPrimitiveShelfImageURLString:(NSString*)value;

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

- (NSString*)primitiveUrlString;
- (void)setPrimitiveUrlString:(NSString*)value;

- (NSNumber*)primitiveYear;
- (void)setPrimitiveYear:(NSNumber*)value;

- (int32_t)primitiveYearValue;
- (void)setPrimitiveYearValue:(int32_t)value_;

- (NSMutableSet*)primitiveFocuses;
- (void)setPrimitiveFocuses:(NSMutableSet*)value;

- (WWIMPTrack*)primitiveTrack;
- (void)setPrimitiveTrack:(WWIMPTrack*)value;

@end
