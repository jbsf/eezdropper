#import "AppDelegate.h"
#import <GameKit/GameKit.h>
#import "PeerWatcher.h"
#import "PeerViewController.h"
#import "TrackViewController.h"
#import "LoginViewController.h"
#import "Peer.h"

@interface AppDelegate ()

@property (nonatomic, retain) PeerViewController *peerViewController;
@property (nonatomic, retain) PlayerController *playerController;

- (void)showLoginController;
- (void)initializePeerWatcher;
@end

@implementation AppDelegate

@synthesize 
window = window_, 
rdio = rdio_,
peerViewController = peerViewController_,
playerController = playerController_,
peerWatcher = peerWatcher_;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"my device name is: %@", [UIDevice currentDevice].name);

    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.rdio = [[Rdio alloc] initWithConsumerKey:@"deanv9w6s66jg45ghzeaxu6z" andSecret:@"Qz2AWKDcSM" delegate:nil];

    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    NSLog(@"booting. accessToken = %@", accessToken);
    
    if (accessToken == nil) {
        [self showLoginController];
    } else {
        [self showApp:accessToken];
    }

    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)showLoginController {
    LoginViewController *loginController = [[LoginViewController alloc] initWithNibName:@"LoginView" bundle:nil];
    loginController.rdio = self.rdio;
    loginController.appDelegate = self;
    self.rdio.delegate = loginController;
    
    self.window.rootViewController = loginController;    
}

- (void)showApp:(NSString *)accessToken {
    self.playerController = [PlayerController controller];
    [self.playerController setRdio:self.rdio];
    [self.playerController setPlayer:self.rdio.player];
    
    self.rdio.delegate = self.playerController;
    
    TrackViewController *trackViewController = [[[TrackViewController alloc] initWithRdio:self.rdio playerController:self.playerController] autorelease];
    [trackViewController loadTracks];
    
    self.peerViewController = [[PeerViewController alloc] initWithPlayerController:self.playerController];
    NSArray *controllers = [NSArray arrayWithObjects:self.peerViewController, trackViewController, nil];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = controllers;
    
    [self initializePeerWatcher];
    
    self.window.rootViewController = tabBarController;    

    [self.rdio authorizeUsingAccessToken:accessToken fromController:tabBarController];
}

- (void)dealloc {
    NSLog(@"AppDelegate dealloc");
    self.window = nil;
    self.peerWatcher = nil;
    self.rdio = nil;
    self.playerController = nil;
    self.peerViewController = nil;
    [super dealloc];
}

- (void)initializePeerWatcher {
    if (self.playerController == nil) {
        NSLog(@"PlayerController is nil, returning.");
        return;
    }
    
    Peer *localPeer = [[[Peer alloc] init] autorelease];
    NSDictionary *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"userData"];
    NSLog(@"booting. userData = %@", userData);
    
    localPeer.firstName = [userData objectForKey:@"firstName"];
    localPeer.lastName  = [userData objectForKey:@"lastName"];
    localPeer.rdioKey   = [userData objectForKey:@"key"];
    localPeer.iconURL   = [userData objectForKey:@"icon"];
    
    self.peerWatcher = [[PeerWatcher alloc] initWithLocalPeer:localPeer delegate:self.peerViewController];
    
    self.playerController.playerDelegate = self.peerWatcher;    
}

- (void)destroyPeerWatcher {
    NSLog(@"destroying peer watcher, but not really");
    return;
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
