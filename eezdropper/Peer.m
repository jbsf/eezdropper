#import "Peer.h"
#import "Track.h"

@implementation Peer

@synthesize name = name_, identifier = identifier_, track = track_;

+ (Peer *)deserialize:(NSData *)data {
    NSKeyedUnarchiver *unarchiver;
    unarchiver = [[[NSKeyedUnarchiver alloc] initForReadingWithData:data] autorelease];
    Peer *peer = [unarchiver decodeObjectForKey:@"peer"];
    [unarchiver finishDecoding];
    return peer;
}

- (id)initWithName:(NSString *)name identifier:(NSString *)identifier track:(Track *)track {
    if (self = [super init]) {
        self.name = name;
        self.identifier = identifier;
        self.track = track;
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)coder {
    if (self = [super init]) {
        self.name       = [coder decodeObjectForKey:@"name"];
        self.identifier = [coder decodeObjectForKey:@"identifier"];
        self.track      = [coder decodeObjectForKey:@"track"];
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

- (NSData *)serialize {
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[[NSKeyedArchiver alloc] initForWritingWithMutableData:data] autorelease];
    [archiver encodeObject:self forKey:@"peer"];
    [archiver finishEncoding];
    return data;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.track      forKey:@"track"];
    [coder encodeObject:self.name       forKey:@"name"];
    [coder encodeObject:self.identifier forKey:@"identifier"];
}

@end
