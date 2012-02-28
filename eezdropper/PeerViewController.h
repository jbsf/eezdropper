#import <UIKit/UIKit.h>
#import "PeerWatcherDelegate.h"

@class PlayerController, MainController;

@interface PeerViewController : UITableViewController<PeerWatcherDelegate>

@property (nonatomic, assign) MainController *mainController;
@property (nonatomic, assign) IBOutlet UITableViewCell *tableViewCell;
@property (nonatomic, assign) IBOutlet UIView *contentView;

- (id)initWithPlayerController:(PlayerController *)playerController;

@end
