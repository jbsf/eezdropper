#import "AppDelegate.h"
#import <GameKit/GameKit.h>
#import "PeerWatcher.h"
#import "PeerViewController.h"
#import "TrackViewController.h"
#import "LoginViewController.h"
#import "Peer.h"

@interface AppDelegate ()
- (void)showLoginController;
@end

@implementation AppDelegate

@synthesize 
window = window_, 
rdio = rdio_,
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
    PlayerController *playerController = [PlayerController controller];
    [playerController setRdio:self.rdio];
    [playerController setPlayer:self.rdio.player];
    
    self.rdio.delegate = playerController;
    
    TrackViewController *trackViewController = [[[TrackViewController alloc] initWithRdio:self.rdio playerController:playerController] autorelease];
    [trackViewController loadTracks];
    
    PeerViewController *peerViewController = [[PeerViewController alloc] initWithPlayerController:playerController];
    NSArray *controllers = [NSArray arrayWithObjects:trackViewController, peerViewController, nil];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = controllers;
    
    Peer *localPeer = [[[Peer alloc] init] autorelease];
    NSDictionary *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"userData"];
    NSLog(@"booting. userData = %@", userData);
    
    localPeer.firstName = [userData objectForKey:@"firstName"];
    localPeer.lastName  = [userData objectForKey:@"lastName"];
    localPeer.rdioKey   = [userData objectForKey:@"key"];
    localPeer.iconURL   = [userData objectForKey:@"icon"];
    
    self.peerWatcher = [[PeerWatcher alloc] initWithLocalPeer:localPeer delegate:peerViewController];
    
    playerController.playerDelegate = self.peerWatcher;
    
    self.window.rootViewController = tabBarController;    

    [self.rdio authorizeUsingAccessToken:accessToken fromController:tabBarController];
}

- (void)dealloc {
    [window_ release];
    [peerWatcher_ release];
    [rdio_ release];
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
