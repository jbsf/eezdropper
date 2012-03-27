#import "AppDelegate.h"
#import <GameKit/GameKit.h>
#import "Blindside.h"
#import "PeerWatcher.h"
#import "PeerViewController.h"
#import "TrackViewController.h"
#import "LoginViewController.h"
#import "Peer.h"
#import "MainController.h"
#import "EezdropperModule.h"
#import "Rdio+Blindside.h"

@interface AppDelegate ()

@property (nonatomic, retain) BSInjector *injector;

- (void)showLoginController;
- (void)initializePeerWatcher;
@end

@implementation AppDelegate

@synthesize 
window = window_, 
rdio = rdio_,
injector = injector_,
peerWatcher = peerWatcher_;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"my device name is: %@", [UIDevice currentDevice].name);

    BSModule *module = [EezdropperModule module];
    [module bind:[AppDelegate class] toInstance:self];
    self.injector = [BSInjector injectorWithModule:module];

    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    NSLog(@"booting. accessToken = %@", accessToken);
    
    MainController *mainController = [self.injector getInstance:[MainController class]];

    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.rootViewController = mainController;    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)rdioDidAuthorizeUser:(NSDictionary *)user withAccessToken:(NSString *)accessToken {
    NSLog(@"AppDelegate did authorize user");
     self.trackViewController.userKey = [user objectForKey:@"key"];
    [self.trackViewController loadTracks];
}


- (void)rdioAuthorizationFailed:(NSString *)error {
    NSLog(@"AppDelegate authorization failed with error: %@", error);
}

- (void)dealloc {
    NSLog(@"AppDelegate dealloc");
    self.window = nil;
    self.peerWatcher = nil;
    self.rdio = nil;
    [super dealloc];
}

- (void)initializePeerWatcher {
    if (self.playerController == nil) {
        NSLog(@"PlayerController is nil, returning.");
        return;
    }
    

    
    self.peerWatcher = [[PeerWatcher alloc] initWithLocalPeer:localPeer delegate:self.peerViewController];
    
    self.playerController.playerDelegate = self.peerWatcher;    
}

- (void)destroyPeerWatcher {
    NSLog(@"destroying peer watcher, but not really");
//    return;
    PeerWatcher *watcher;
    @synchronized(self) {
        watcher = self.peerWatcher;
        self.peerWatcher = nil;        
    }
    [watcher disconnect];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"--------applicationDidBecomeActive");
    if (self.peerWatcher == nil) {
        [self initializePeerWatcher];
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"--------applicationWillResignActive");
    [self destroyPeerWatcher];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    NSLog(@"--------applicationDidReceiveMemoryWarning");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"--------applicationWillTerminate");    
    [self destroyPeerWatcher];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"--------applicationDidEnterBackground");
    [self destroyPeerWatcher];
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"--------applicationWillEnterForeground");
    if (self.peerWatcher == nil) {
        [self initializePeerWatcher];
    }
}

@end
