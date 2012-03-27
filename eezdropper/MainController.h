#import <UIKit/UIKit.h>
#import <Rdio/Rdio.h>

@class TrackViewController, PlayerController, PeerViewController, Peer;

@interface MainController : UIViewController

@property (nonatomic, assign) IBOutlet UIButton *songButton;
@property (nonatomic, assign) IBOutlet UIButton *nearbyButton;

@property (nonatomic, retain) TrackViewController *trackController;
@property (nonatomic, retain) PlayerController *playerController;
@property (nonatomic, retain) PeerViewController *peerController;

- (IBAction)didTapSongButton;
- (IBAction)didTapNearbyButton;

- (void)showTrackViewForPeer:(Peer *)peer;

- (void)loginDidSucceed;
@end
