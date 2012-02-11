#import "LoginViewController.h"
#import "AppDelegate.h"

@implementation LoginViewController

@synthesize 
rdio = rdio_,
appDelegate = appDelegate_,
loginButton = loginButton_;

- (id)initWithRdio:(Rdio *)rdio {
    if (self = [super init]) {
        self.rdio = rdio;
    }
    return self;
}

- (void)dealloc {
    [rdio_ release];
    [super dealloc];
}

- (IBAction) didTapLogin {
    NSLog(@"prompting for login");
    [self.rdio authorizeFromController:self];
}

#pragma mark -
#pragma mark RdioDelegate

- (void) rdioDidAuthorizeUser:(NSDictionary *)userData withAccessToken:(NSString *)accessToken {
    NSLog(@"LoginViewController authorization succeeded. token = %@", accessToken);
    NSLog(@"user data: %@", userData);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:accessToken forKey:@"accessToken"];
    [userDefaults setObject:userData    forKey:@"userData"];
    [self.appDelegate showApp:accessToken];
}

- (void) rdioAuthorizationFailed:(NSString *)error {
    NSLog(@"----------- LoginViewControlelr authorization failed with error: %@", error);
}

- (void) rdioAuthorizationCancelled {
    NSLog(@"----------- LoginViewController authorization cancelled");
}

- (void) rdioDidLogout {
    NSLog(@"-----------LoginViewController rdioDidLogout");
}


@end
