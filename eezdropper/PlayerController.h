#import <UIKit/UIKit.h>
#import "Rdio/Rdio.h"

@interface PlayerController : UITableViewController<RdioDelegate,RDPlayerDelegate,RDAPIRequestDelegate> 

@property (nonatomic, retain) RDPlayer *player;
@property (nonatomic, retain) Rdio *rdio;
@property (nonatomic, retain) NSArray *tracks;

+ (PlayerController *)controller;
- (void)loadTracks;

@end
