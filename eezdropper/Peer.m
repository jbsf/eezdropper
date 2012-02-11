#import "Peer.h"
#import "Track.h"

@implementation Peer

@synthesize 
firstName = firstName_,
lastName = lastName_,
rdioKey = rdioKey_,
iconURL = iconURL_,
identifier = identifier_, 
track = track_;

+ (Peer *)deserialize:(NSData *)data {
    NSKeyedUnarchiver *unarchiver;
    unarchiver = [[[NSKeyedUnarchiver alloc] initForReadingWithData:data] autorelease];
    Peer *peer = [unarchiver decodeObjectForKey:@"peer"];
    [unarchiver finishDecoding];
    return peer;
}

- (id)initWithIdentifier:(NSString *)identifier {
    if (self = [super init]) {
        self.identifier = identifier;
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)coder {
    if (self = [super init]) {
        self.firstName  = [coder decodeObjectForKey:@"firstName"];
        self.lastName   = [coder decodeObjectForKey:@"lastName"];
        self.rdioKey    = [coder decodeObjectForKey:@"rdioKey"];
        self.iconURL    = [coder decodeObjectForKey:@"iconURL"];
        self.identifier = [coder decodeObjectForKey:@"identifier"];
        self.track      = [coder decodeObjectForKey:@"track"];
    }
    return self;
}

- (void)dealloc {
    [firstName_ release];
    [lastName_ release];
    [rdioKey_ release];
    [iconURL_ release];
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
    [coder encodeObject:self.firstName  forKey:@"firstName"];
    [coder encodeObject:self.lastName   forKey:@"lastName"];
    [coder encodeObject:self.rdioKey    forKey:@"rdioKey"];
    [coder encodeObject:self.iconURL    forKey:@"iconURL"];
    [coder encodeObject:self.identifier forKey:@"identifier"];
}

- (NSString *)name {
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

@end
