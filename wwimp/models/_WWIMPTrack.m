// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WWIMPTrack.m instead.

#import "_WWIMPTrack.h"

const struct WWIMPTrackAttributes WWIMPTrackAttributes = {
	.name = @"name",
	.order = @"order",
};

const struct WWIMPTrackRelationships WWIMPTrackRelationships = {
	.sessions = @"sessions",
};

@implementation WWIMPTrackID
@end

@implementation _WWIMPTrack

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Track" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Track";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Track" inManagedObjectContext:moc_];
}

- (WWIMPTrackID*)objectID {
	return (WWIMPTrackID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"orderValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"order"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic name;

@dynamic order;

- (int32_t)orderValue {
	NSNumber *result = [self order];
	return [result intValue];
}

- (void)setOrderValue:(int32_t)value_ {
	[self setOrder:@(value_)];
}

- (int32_t)primitiveOrderValue {
	NSNumber *result = [self primitiveOrder];
	return [result intValue];
}

- (void)setPrimitiveOrderValue:(int32_t)value_ {
	[self setPrimitiveOrder:@(value_)];
}

@dynamic sessions;

- (NSMutableSet*)sessionsSet {
	[self willAccessValueForKey:@"sessions"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"sessions"];

	[self didAccessValueForKey:@"sessions"];
	return result;
}

@end

