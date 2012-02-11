#import <UIKit/UIKit.h>
#import "PeerWatcherDelegate.h"

@class PlayerController;

@interface PeerViewController : UITableViewController<PeerWatcherDelegate>

- (id)initWithPlayerController:(PlayerController *)playerController;

@end
