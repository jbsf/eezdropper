#import <UIKit/UIKit.h>
#import <Rdio/Rdio.h>
#import "PlayerController.h"

@class PeerWatcher;

@interface AppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) Rdio *rdio;
@property (atomic, retain) PeerWatcher *peerWatcher;

- (void)showApp:(NSString *)accessToken;

@end

