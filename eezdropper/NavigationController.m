#import "NavigationController.h"
#import "TrackViewController.h"
#import "PeerViewController.h"
#import <Rdio/Rdio.h>

@implementation NavigationController

@synthesize 
songButton = songButton_,
nearbyButton = nearbyButton_,
navBarView = navBarView_,
trackController = trackController_,
peerController = peerController_;

- (void)viewDidLoad {
    [self.view addSubview:self.peerController.view];
    [self.view addSubview:self.navBarView];
    self.peerController.view.frame = CGRectMake(0, 40, 320, 400);
    self.trackController.view.frame = CGRectMake(0, 40, 320, 380);
}

- (IBAction)didTapSongButton {
    [self.peerController.view removeFromSuperview];
    [self.view addSubview:self.trackController.view];
}

- (IBAction)didTapNearbyButton {
    [self.trackController.view removeFromSuperview];
    [self.view addSubview:self.peerController.view];
}

- (void)addPlayerControlView:(UIView *)playerControlView {
    playerControlView.frame = CGRectMake(0, 420, 320, 40);
    [self.view addSubview:playerControlView];
}

@end
