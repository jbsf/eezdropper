#import <UIKit/UIKit.h>
#import "Rdio/Rdio.h"

@protocol PlayerDelegate;
@class Track;

@interface PlayerController : UITableViewController<RdioDelegate,RDPlayerDelegate> 

@property (nonatomic, retain) RDPlayer *player;
@property (nonatomic, retain) Rdio *rdio;
@property (nonatomic, assign) id<PlayerDelegate> playerDelegate;
@property (nonatomic, assign) IBOutlet UIProgressView *progressView;
@property (nonatomic, assign) IBOutlet UIView *playerControlView;
@property (nonatomic, assign) IBOutlet UIButton *playButton;
@property (nonatomic, assign) IBOutlet UIButton *pauseButton;

- (id)initWithRdio:(Rdio *)rdio player:(RDPlayer *)player;

- (void)playTrack:(Track *)track;

- (IBAction)didTapPlayButton;
- (IBAction)didTapPauseButton;
@end
