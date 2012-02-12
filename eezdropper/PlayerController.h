#import <UIKit/UIKit.h>
#import "Rdio/Rdio.h"

@protocol PlayerDelegate;
@class Track;

@interface PlayerController : UITableViewController<RdioDelegate,RDPlayerDelegate> 

@property (nonatomic, retain) RDPlayer *player;
@property (nonatomic, retain) Rdio *rdio;
@property (nonatomic, assign) id<PlayerDelegate> playerDelegate;
@property (nonatomic, assign) UIProgressView *progressView;

- (id)initWithRdio:(Rdio *)rdio player:(RDPlayer *)player;

- (void)playTrack:(Track *)track;
@end
