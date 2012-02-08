#import <UIKit/UIKit.h>
#import "Rdio/Rdio.h"

@interface PlayerController : UIViewController<RdioDelegate,RDPlayerDelegate> 

@property (nonatomic, retain) IBOutlet UIButton *playButton;
@property (nonatomic, retain) IBOutlet UIButton *loginButton;
@property (nonatomic, retain) RDPlayer *player;
@property (nonatomic, retain) Rdio *rdio;

- (IBAction) playClicked:(id) button;
- (IBAction) loginClicked:(id) button;

@end
