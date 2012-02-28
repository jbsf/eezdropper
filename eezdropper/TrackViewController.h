#import <UIKit/UIKit.h>
#import <Rdio/Rdio.h>

@class Rdio, PlayerController;

@interface TrackViewController : UITableViewController<RDAPIRequestDelegate>

@property (nonatomic, assign) IBOutlet UITableViewCell *tableViewCell;
@property (nonatomic, assign) IBOutlet UIView *contentView;
@property (nonatomic, retain) NSString *userKey;

- (id)initWithRdio:(Rdio *)rdio playerController:(PlayerController *)playerController;

- (void)loadTracks;

@end
