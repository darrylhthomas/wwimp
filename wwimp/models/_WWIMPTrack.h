// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WWIMPTrack.h instead.

@import CoreData;

extern const struct WWIMPTrackAttributes {
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *order;
} WWIMPTrackAttributes;

extern const struct WWIMPTrackRelationships {
	__unsafe_unretained NSString *sessions;
} WWIMPTrackRelationships;

@class WWIMPSession;

@interface WWIMPTrackID : NSManagedObjectID {}
@end

@interface _WWIMPTrack : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) WWIMPTrackID* objectID;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* order;

@property (atomic) int32_t orderValue;
- (int32_t)orderValue;
- (void)setOrderValue:(int32_t)value_;

//- (BOOL)validateOrder:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *sessions;

- (NSMutableSet*)sessionsSet;

@end

@interface _WWIMPTrack (SessionsCoreDataGeneratedAccessors)
- (void)addSessions:(NSSet*)value_;
- (void)removeSessions:(NSSet*)value_;
- (void)addSessionsObject:(WWIMPSession*)value_;
- (void)removeSessionsObject:(WWIMPSession*)value_;

@end

@interface _WWIMPTrack (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSNumber*)primitiveOrder;
- (void)setPrimitiveOrder:(NSNumber*)value;

- (int32_t)primitiveOrderValue;
- (void)setPrimitiveOrderValue:(int32_t)value_;

- (NSMutableSet*)primitiveSessions;
- (void)setPrimitiveSessions:(NSMutableSet*)value;

@end
