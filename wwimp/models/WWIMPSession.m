#import "WWIMPSession.h"

@interface WWIMPSession ()

// Private interface goes here.

@end

@implementation WWIMPSession

- (NSString *)key
{
    NSNumber *year = self.year;
    NSNumber *id = self.id;
    NSAssert(year, @"-key called while year is nil");
    NSAssert(id, @"-key called while id is nil");
    if (!year || !id) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@-%@", [year stringValue], [id stringValue]];
}

- (NSString *)lastPlayPositionUserDefaultsKey
{
    NSString *key = self.key;
    NSAssert(key, @"-lastPlayPositionUserDefaultsKey called while key is nil");
    if (!key) {
        return nil;
    }
    return [@"last_play_position:" stringByAppendingString:key];
}

@end
