#import "WWIMPTrack.h"

@interface WWIMPTrack ()

// Private interface goes here.

@end

@implementation WWIMPTrack

- (NSString *)orderUserDefaultsKey
{
    NSAssert(self.name, @"-orderUserDefaultsKey called while name is nil");
    return [@"track_order:" stringByAppendingString:self.name];
}

@end
