#import <UIKit/UIKit.h>
#import <Rdio/Rdio.h>

@class Rdio, PlayerController;

@interface TrackViewController : UITableViewController<RDAPIRequestDelegate>

- (id)initWithRdio:(Rdio *)rdio playerController:(PlayerController *)playerController;

- (void)loadTracks;

@end
