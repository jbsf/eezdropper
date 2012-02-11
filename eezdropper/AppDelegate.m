#import "AppDelegate.h"
#import <GameKit/GameKit.h>
#import "PeerWatcher.h"
#import "PeerViewController.h"

@implementation AppDelegate

@synthesize window = window_, peerWatcher = peerWatcher_;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"my device name is: %@", [UIDevice currentDevice].name);

    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    PlayerController *playerController = [PlayerController controller];
    Rdio *rdio = [[Rdio alloc] initWithConsumerKey:@"deanv9w6s66jg45ghzeaxu6z" andSecret:@"Qz2AWKDcSM" delegate:playerController];
    [playerController setRdio:rdio];
    [playerController setPlayer:rdio.player];
    [playerController loadTracks];

    PeerViewController *peerViewController = [[PeerViewController alloc] init];
    NSArray *controllers = [NSArray arrayWithObjects:playerController, peerViewController, nil];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = controllers;
    
    self.peerWatcher = [[PeerWatcher alloc] initWithDelegate:peerViewController];
    
    playerController.playerDelegate = self.peerWatcher;
    
    // Add the view controller's view to the window and display.
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)dealloc {
    [window_ release];
    [peerWatcher_ release];
    [super dealloc];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"--------applicationDidBecomeActive");
}
- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"--------applicationWillResignActive");
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    NSLog(@"--------applicationDidReceiveMemoryWarning");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"--------applicationWillTerminate");    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"--------applicationDidEnterBackground");
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"--------applicationWillEnterForeground");
}

@end
