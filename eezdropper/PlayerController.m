#import "PlayerController.h"

@interface PlayerController ()
@property (nonatomic, assign) BOOL loggedIn;
@property (nonatomic, assign) BOOL playing;
@property (nonatomic, assign) BOOL paused;
@end

@implementation PlayerController

@synthesize playButton, loginButton, player, rdio, loggedIn, playing, paused;

#pragma mark -
#pragma mark UI event and state handling

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

- (void) setLoggedIn:(BOOL)logged_in {
    self.loggedIn = logged_in;
    if (logged_in) {
        [self.loginButton setTitle:@"Log Out" forState: UIControlStateNormal];
    } else {
        [self.loginButton setTitle:@"Log In" forState: UIControlStateNormal];
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
    if (self.paused || !playing) {
        [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    } else {
        [self.playButton setTitle:@"Pause" forState:UIControlStateNormal];
    }
}

@end
