#import <UIKit/UIKit.h>
#import "Rdio/Rdio.h"

@protocol PlayerDelegate;
@class Track;

@interface PlayerController : UITableViewController<RdioDelegate,RDPlayerDelegate> 

@property (nonatomic, retain) RDPlayer *player;
@property (nonatomic, retain) Rdio *rdio;
@property (nonatomic, assign) id<PlayerDelegate> playerDelegate;

+ (PlayerController *)controller;

- (void)playTrack:(Track *)track;
@end
