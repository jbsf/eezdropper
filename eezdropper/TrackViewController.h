#import <UIKit/UIKit.h>
#import <Rdio/Rdio.h>
#import "MHLazyTableImages.h"

@class Rdio, PlayerController;

@interface TrackViewController : UITableViewController<RDAPIRequestDelegate, MHLazyTableImagesDelegate>

@property (nonatomic, assign) IBOutlet UITableViewCell *tableViewCell;
@property (nonatomic, assign) IBOutlet UIView *contentView;

- (id)initWithRdio:(Rdio *)rdio playerController:(PlayerController *)playerController;

- (void)loadTracks;

@end
