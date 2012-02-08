#import <UIKit/UIKit.h>
#import <Rdio/Rdio.h>
#import "PlayerController.h"

@interface AppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet PlayerController *viewController;
@property (nonatomic, retain) Rdio *rdio;

@end

