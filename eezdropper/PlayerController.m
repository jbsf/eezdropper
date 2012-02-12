#import "PlayerController.h"
#import "Track.h"
#import "PlayerDelegate.h"

@implementation PlayerController

@synthesize 
playButton = playButton_,
pauseButton = pauseButton_,
player = player_, 
rdio = rdio_, 
playerControlView = playerControlView_,
progressView = progressView_,
playerDelegate = playerDelegate_;

- (id)initWithRdio:(Rdio *)rdio player:(RDPlayer *)player {
    if (self = [super init]) {
        self.rdio = rdio;
        self.player = player;
        [[NSBundle mainBundle] loadNibNamed:@"PlayerControlView" owner:self options:nil];
    }
    return self;
}

- (void)dealloc {
    self.player = nil;
    self.rdio = nil;
    [super dealloc];
}

- (void)playTrack:(Track *)track {
    [self.playerDelegate playerDidStart:track];
    NSLog(@"playing track with key: %@", track.key);
    [self.player playSource:track.key];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"value observed, change = %@", change);
    NSString *newString = [change objectForKey:@"new"];
    float new = [newString floatValue];
    [self.progressView setProgress:(new/self.player.duration) animated:YES];
}

- (BOOL)rdioIsPlayingElsewhere {
    return NO;
}

-(void)rdioPlayerChangedFromState:(RDPlayerState)oldState toState:(RDPlayerState)newState {
    if (newState == RDPlayerStatePlaying) {
        self.playButton.hidden = YES;
        self.pauseButton.hidden = NO;
    } else {
        self.playButton.hidden = NO;
        self.pauseButton.hidden = YES;
    }
}

- (void)didTapPlayButton {
    [self.player togglePause];
}

- (void)didTapPauseButton {
    [self.player togglePause];
}

@end
