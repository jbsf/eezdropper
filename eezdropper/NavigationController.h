#import <UIKit/UIKit.h>

@class TrackViewController, PeerViewController;

@interface NavigationController : UIViewController

@property (nonatomic, assign) IBOutlet UIButton *playButton;
@property (nonatomic, assign) IBOutlet UIButton *pauseButton;
@property (nonatomic, assign) IBOutlet UIButton *songButton;
@property (nonatomic, assign) IBOutlet UIButton *nearbyButton;
@property (nonatomic, assign) IBOutlet UIView *navBarView;
@property (nonatomic, assign) IBOutlet UIView *playerControlView;

@property (nonatomic, retain) TrackViewController *trackController;
@property (nonatomic, retain) PeerViewController *peerController;

- (IBAction)didTapSongButton;
- (IBAction)didTapNearbyButton;

@end
