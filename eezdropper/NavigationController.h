#import <UIKit/UIKit.h>
#import <Rdio/Rdio.h>

@class TrackViewController, PeerViewController;

@interface NavigationController : UIViewController

@property (nonatomic, assign) IBOutlet UIButton *songButton;
@property (nonatomic, assign) IBOutlet UIButton *nearbyButton;
@property (nonatomic, assign) IBOutlet UIView *navBarView;

@property (nonatomic, retain) TrackViewController *trackController;
@property (nonatomic, retain) PeerViewController *peerController;

- (IBAction)didTapSongButton;
- (IBAction)didTapNearbyButton;

- (void)addPlayerControlView:(UIView *)playerControlView;

@end
