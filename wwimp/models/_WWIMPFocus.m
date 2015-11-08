// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WWIMPFocus.m instead.

#import "_WWIMPFocus.h"

const struct WWIMPFocusAttributes WWIMPFocusAttributes = {
	.name = @"name",
};

const struct WWIMPFocusRelationships WWIMPFocusRelationships = {
	.sessions = @"sessions",
};

@implementation WWIMPFocusID
@end

@implementation _WWIMPFocus

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Focus" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Focus";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Focus" inManagedObjectContext:moc_];
}

- (WWIMPFocusID*)objectID {
	return (WWIMPFocusID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic name;

@dynamic sessions;

- (NSMutableSet*)sessionsSet {
	[self willAccessValueForKey:@"sessions"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"sessions"];

	[self didAccessValueForKey:@"sessions"];
	return result;
}

@end

