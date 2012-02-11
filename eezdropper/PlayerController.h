#import <UIKit/UIKit.h>
#import "Rdio/Rdio.h"

@protocol PlayerDelegate;

@interface PlayerController : UITableViewController<RdioDelegate,RDPlayerDelegate,RDAPIRequestDelegate> 

@property (nonatomic, retain) RDPlayer *player;
@property (nonatomic, retain) Rdio *rdio;
@property (nonatomic, assign) id<PlayerDelegate> playerDelegate;
@property (nonatomic, retain) NSArray *tracks;

+ (PlayerController *)controller;

- (void)loadTracks;

@end
