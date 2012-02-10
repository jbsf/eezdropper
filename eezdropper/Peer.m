#import "Peer.h"
#import "Track.h"

@implementation Peer

@synthesize name = name_, identifier = identifier_, track = track_;

- (id)initWithName:(NSString *)name identifier:(NSString *)identifier track:(Track *)track {
    if (self = [super init]) {
        self.name = name;
        self.identifier = identifier;
        self.track = track;
    }
    return self;
}

- (void)dealloc {
    [name_ release];
    [identifier_ release];
    [track_ release];
    [super dealloc];
}

- (BOOL)isEqual:(id)object {
    return [self.identifier isEqualToString:[object identifier]];
}

- (NSUInteger)hash {
    return [self.identifier hash];
}

@end
