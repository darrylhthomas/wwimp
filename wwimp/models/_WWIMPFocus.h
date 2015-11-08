// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WWIMPFocus.h instead.

@import CoreData;

extern const struct WWIMPFocusAttributes {
	__unsafe_unretained NSString *name;
} WWIMPFocusAttributes;

extern const struct WWIMPFocusRelationships {
	__unsafe_unretained NSString *sessions;
} WWIMPFocusRelationships;

@class WWIMPSession;

@interface WWIMPFocusID : NSManagedObjectID {}
@end

@interface _WWIMPFocus : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) WWIMPFocusID* objectID;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *sessions;

- (NSMutableSet*)sessionsSet;

@end

@interface _WWIMPFocus (SessionsCoreDataGeneratedAccessors)
- (void)addSessions:(NSSet*)value_;
- (void)removeSessions:(NSSet*)value_;
- (void)addSessionsObject:(WWIMPSession*)value_;
- (void)removeSessionsObject:(WWIMPSession*)value_;

@end

@interface _WWIMPFocus (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSMutableSet*)primitiveSessions;
- (void)setPrimitiveSessions:(NSMutableSet*)value;

@end
