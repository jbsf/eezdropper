#import "Track.h"

@implementation Track

@synthesize name, artist, iconURL, key;

+ (NSArray *)parseTracks:(NSArray *)properties {
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

@end
