#import "WWIMPSession.h"

@interface WWIMPSession ()

// Private interface goes here.

@end

@implementation WWIMPSession

- (NSString *)key
{
    return [NSString stringWithFormat:@"%@-%@", [self.year stringValue], [self.id stringValue]];
}

- (NSString *)lastPlayPositionUserDefaultsKey
{
    return [@"last_play_position:" stringByAppendingString:self.key];
}

@end
