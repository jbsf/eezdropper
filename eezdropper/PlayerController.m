#import "PlayerController.h"
#import "Track.h"
#import "PlayerDelegate.h"

@interface PlayerController ()
@property (nonatomic, assign) BOOL loggedIn;
@property (nonatomic, assign) BOOL playing;
@property (nonatomic, assign) BOOL paused;
@end

@implementation PlayerController

@synthesize 
player = player_, 
rdio = rdio_, 
loggedIn = loggedIn_, 
playing = playing_, 
paused = paused_,
playerDelegate = playerDelegate_;

+ (PlayerController *)controller {
    return [[[PlayerController alloc] init] autorelease];
}

- (void)dealloc {
    [player_ release];
    [rdio_ release];
    [super dealloc];
}

- (void)playTrack:(Track *)track {
    [self.playerDelegate playerDidStart:track];
    NSLog(@"playing track with key: %@", track.key);
    [self.player playSource:track.key];
}

#pragma mark IBActions

- (IBAction) playClicked:(id) button {
    if (!self.playing) {
        NSArray* keys = [@"t2742133,t1992210,t7418766,t8816323" componentsSeparatedByString:@","];
        [self.player playSources:keys];
    } else {
        [self.player togglePause];
    }
}

- (IBAction) loginClicked:(id) button {
    if (self.loggedIn) {
        [self.rdio logout];
    } else {
        [self.rdio authorizeFromController:self];
    }
}

#pragma mark -
#pragma mark RdioDelegate

- (void) rdioDidAuthorizeUser:(NSDictionary *)user withAccessToken:(NSString *)accessToken {
    [self setLoggedIn:YES];
}

- (void) rdioAuthorizationFailed:(NSString *)error {
    [self setLoggedIn:NO];
}

- (void) rdioAuthorizationCancelled {
    [self setLoggedIn:NO];
}

- (void) rdioDidLogout {
    [self setLoggedIn:NO];
}

#pragma mark -
#pragma mark RDPlayerDelegate

- (BOOL) rdioIsPlayingElsewhere {
    return NO;
}

- (void) rdioPlayerChangedFromState:(RDPlayerState)fromState toState:(RDPlayerState)state {
    self.playing = (state != RDPlayerStateInitializing && state != RDPlayerStateStopped);
    self.paused = (state == RDPlayerStatePaused);
}

@end
