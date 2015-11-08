// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WWIMPSession.m instead.

#import "_WWIMPSession.h"

const struct WWIMPSessionAttributes WWIMPSessionAttributes = {
	.descriptionText = @"descriptionText",
	.id = @"id",
	.shelfImageURLString = @"shelfImageURLString",
	.title = @"title",
	.urlString = @"urlString",
	.year = @"year",
};

const struct WWIMPSessionRelationships WWIMPSessionRelationships = {
	.focuses = @"focuses",
	.track = @"track",
};

@implementation WWIMPSessionID
@end

@implementation _WWIMPSession

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Session" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Session";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Session" inManagedObjectContext:moc_];
}

- (WWIMPSessionID*)objectID {
	return (WWIMPSessionID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"yearValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"year"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic descriptionText;

@dynamic id;

- (int32_t)idValue {
	NSNumber *result = [self id];
	return [result intValue];
}

- (void)setIdValue:(int32_t)value_ {
	[self setId:@(value_)];
}

- (int32_t)primitiveIdValue {
	NSNumber *result = [self primitiveId];
	return [result intValue];
}

- (void)setPrimitiveIdValue:(int32_t)value_ {
	[self setPrimitiveId:@(value_)];
}

@dynamic shelfImageURLString;

@dynamic title;

@dynamic urlString;

@dynamic year;

- (int32_t)yearValue {
	NSNumber *result = [self year];
	return [result intValue];
}

- (void)setYearValue:(int32_t)value_ {
	[self setYear:@(value_)];
}

- (int32_t)primitiveYearValue {
	NSNumber *result = [self primitiveYear];
	return [result intValue];
}

- (void)setPrimitiveYearValue:(int32_t)value_ {
	[self setPrimitiveYear:@(value_)];
}

@dynamic focuses;

- (NSMutableSet*)focusesSet {
	[self willAccessValueForKey:@"focuses"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"focuses"];

	[self didAccessValueForKey:@"focuses"];
	return result;
}

@dynamic track;

@end

