#import "NavigationController.h"
#import "TrackViewController.h"
#import "PeerViewController.h"
#import <Rdio/Rdio.h>

@implementation NavigationController

@synthesize 
playButton = playButton_,
pauseButton = pauseButton_,
songButton = songButton_,
nearbyButton = nearbyButton_,
navBarView = navBarView_,
progressView = progressView,
playerControlView = playerControlView_,
trackController = trackController_,
player = player_,
peerController = peerController_;

- (void)viewDidLoad {
    [self.view addSubview:self.peerController.view];
    [self.view addSubview:self.playerControlView];
    [self.view addSubview:self.navBarView];
    self.peerController.view.frame = CGRectMake(0, 40, 320, 400);
    self.trackController.view.frame = CGRectMake(0, 40, 320, 380);
    self.playerControlView.frame = CGRectMake(0, 420, 320, 40);
}

- (IBAction)didTapSongButton {
    [self.peerController.view removeFromSuperview];
    [self.view addSubview:self.trackController.view];
}

- (IBAction)didTapNearbyButton {
    [self.trackController.view removeFromSuperview];
    [self.view addSubview:self.peerController.view];
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
