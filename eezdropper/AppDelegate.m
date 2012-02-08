#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    PlayerController *playerController = [PlayerController controller];
    Rdio *rdio = [[Rdio alloc] initWithConsumerKey:@"deanv9w6s66jg45ghzeaxu6z" andSecret:@"Qz2AWKDcSM" delegate:playerController];
    [playerController setRdio:rdio];
    [playerController setPlayer:rdio.player];
    [playerController loadTracks];
    
    // Add the view controller's view to the window and display.
    self.window.rootViewController = playerController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)dealloc {
    [window release];
    [super dealloc];
}

@end
