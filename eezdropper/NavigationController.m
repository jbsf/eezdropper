#import "NavigationController.h"
#import "TrackViewController.h"
#import "PeerViewController.h"

@implementation NavigationController

@synthesize 
playButton = playButton_,
pauseButton = pauseButton_,
songButton = songButton_,
nearbyButton = nearbyButton_,
navBarView = navBarView_,
playerControlView = playerControlView_,
trackController = trackController_,
peerController = peerController_;

- (void)viewDidLoad {
    [self.view addSubview:self.peerController.view];
    [self.view addSubview:self.playerControlView];
    [self.view addSubview:self.navBarView];
    self.peerController.view.frame = CGRectMake(0, 30, 320, 410);
    self.trackController.view.frame = CGRectMake(0, 30, 320, 390);
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


@end
