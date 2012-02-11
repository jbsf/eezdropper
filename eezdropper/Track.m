#import "Track.h"

@implementation Track

@synthesize name, artist, iconURL, key;

+ (NSArray *)parseTracks:(NSArray *)properties {
//    NSLog(@"tracks: %@", properties);
    NSMutableArray *tracks = [NSMutableArray array];
    for (NSDictionary *trackProperties in properties) {
        Track *track  = [[[Track alloc] init] autorelease];
        track.name    = [trackProperties objectForKey:@"name"];
        track.artist  = [trackProperties objectForKey:@"artist"];
        track.iconURL = [trackProperties objectForKey:@"icon"];
        track.key     = [trackProperties objectForKey:@"key"];
        [tracks addObject:track];
    }
    
    return tracks;
}

- (id)initWithCoder:(NSCoder*)coder {
    if (self = [super init]) {
        self.name    = [coder decodeObjectForKey:@"name"];
        self.artist  = [coder decodeObjectForKey:@"artist"];
        self.iconURL = [coder decodeObjectForKey:@"iconURL"];
        self.key     = [coder decodeObjectForKey:@"key"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.name    forKey:@"name"];
    [coder encodeObject:self.artist  forKey:@"artist"];
    [coder encodeObject:self.iconURL forKey:@"iconURL"];
    [coder encodeObject:self.key     forKey:@"key"];
}


@end
