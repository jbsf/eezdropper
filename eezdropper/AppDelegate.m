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

@property (nonatomic, retain) PeerViewController *peerViewController;
@property (nonatomic, retain) TrackViewController *trackViewController;
@property (nonatomic, retain) PlayerController *playerController;
@property (nonatomic, retain) BSInjector *injector;

- (void)showLoginController;
- (void)initializePeerWatcher;
- (void)initializeBlindside;
@end

@implementation AppDelegate

@synthesize 
window = window_, 
rdio = rdio_,
injector = injector_,
peerViewController = peerViewController_,
trackViewController = trackViewController,
playerController = playerController_,
peerWatcher = peerWatcher_;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"my device name is: %@", [UIDevice currentDevice].name);

    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    BSModule *module = [EezdropperModule module];
    self.injector = [BSInjector injectorWithModule:module];

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

- (void)initializeBlindside {
    
}

- (void)showLoginController {
    LoginViewController *loginController = [self.injector getInstance:[LoginViewController class]];
    
    loginController.appDelegate = self;
    self.rdio.delegate = loginController;
    
    self.window.rootViewController = loginController;    
}

- (void)showApp:(NSString *)accessToken {
    self.playerController = [[[PlayerController alloc] initWithRdio:self.rdio player:self.rdio.player] autorelease];
    [self.rdio.player addObserver:self.playerController forKeyPath:@"position" options:NSKeyValueObservingOptionNew context:nil];
    self.rdio.player.delegate = self.playerController;    
    
    self.trackViewController = [[[TrackViewController alloc] initWithRdio:self.rdio playerController:self.playerController] autorelease];
    
    self.peerViewController = [[PeerViewController alloc] initWithPlayerController:self.playerController];
    
    [self initializePeerWatcher];
    
    MainController *mainController = [[[MainController alloc] initWithNibName:@"MainView" bundle:nil] autorelease]; 
    mainController.peerController = self.peerViewController;
    mainController.trackController = self.trackViewController;
    self.peerViewController.mainController = mainController;
    [mainController addPlayerControlView: self.playerController.playerControlView];

    
    self.window.rootViewController = mainController;    

    self.rdio.delegate = self;
    [self.rdio authorizeUsingAccessToken:accessToken fromController:mainController];
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
