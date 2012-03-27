#import "MainController.h"
#import "TrackViewController.h"
#import "PlayerController.h"
#import "PeerViewController.h"
#import <Rdio/Rdio.h>
#import "Peer.h"
#import "Blindside.h"

@implementation MainController

@synthesize 
songButton = songButton_,
nearbyButton = nearbyButton_,
trackController = trackController_,
playerController = playerController_,
peerController = peerController_;

+ (BSInitializer *)blinsideInitializer {
    return [BSInitializer initializerWithClass:self 
                                      selector:@selector(initWithNibName:bundle:) 
                                  argumentKeys:@"MainViewNib", nil];
}

+ (NSDictionary *)blinsideProperties {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [PeerViewController class], [PeerViewController class], 
            [PlayerController class], [PlayerController class], 
            [TrackViewController class], [TrackViewController class], nil];
}

- (void)dealloc {
    self.trackController = nil;
    self.playerController = nil;
    self.peerController = nil;
    [super dealloc];
}


- (void)viewDidLoad {
    
    if (accessToken == nil) {
        [self showLoginController];
    } else {
        [self showApp:accessToken];
    }
    [self.view addSubview:self.peerController.view];
    self.peerController.view.frame = CGRectMake(0, 40, 320, 400);
    self.trackController.view.frame = CGRectMake(0, 40, 320, 380);
}

- (void)loginDidSucceed {
    
}

- (void)showApp:(NSString *)accessToken {
    
    [self initializePeerWatcher];
    
    
    self.rdio.delegate = self;
    [self.rdio authorizeUsingAccessToken:accessToken fromController:mainController];
}

- (void)showLoginController {
    LoginViewController *loginController = [self.injector getInstance:[LoginViewController class]];
    self.window.rootViewController = loginController;    
}


- (IBAction)didTapSongButton {
    [self.peerController.view removeFromSuperview];
    [self.view addSubview:self.trackController.view];
}

- (IBAction)didTapNearbyButton {
    [self.trackController.view removeFromSuperview];
    [self.view addSubview:self.peerController.view];
}

- (void)setPlayerController:(PlayerController *)playerController {
    playerController.view.frame = CGRectMake(0, 420, 320, 40);
    [self.view addSubview:playerController.view];
} 

- (void)showTrackViewForPeer:(Peer *)peer {
    NSLog(@"showing track view for peer: %@", peer.name);
}

@end
