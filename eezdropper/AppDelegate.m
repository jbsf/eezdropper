#import "AppDelegate.h"
#import "ConsumerCredentials.h"

@implementation AppDelegate

@synthesize window, viewController, rdio;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.rdio = [[Rdio alloc] initWithConsumerKey:CONSUMER_KEY andSecret:CONSUMER_SECRET delegate:viewController];
    [self.rdio.player playSource:@"t2742133"];
    [(PlayerController *)viewController setRdio:self.rdio];
    
    // Add the view controller's view to the window and display.
    [self.window addSubview:viewController.view];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)dealloc {
    [rdio release];
    [window release];
    [super dealloc];
}

@end
