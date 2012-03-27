#import "LoginViewController.h"
#import "AppDelegate.h"

@implementation LoginViewController

@synthesize 
rdio = rdio_,
mainController = mainController_,
loginButton = loginButton_;

+ (BSInitializer *)blindsideInitializer {
    return [BSInitializer initializerWithClass:self 
                                      selector:@selector(initWithNibName:bundle:) 
                                  argumentKeys:@"loginViewNib", @"loginViewBundle", nil];
}

+ (NSDictionary *)blindsideProperties {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [Rdio class], @"rdio", 
            [MainController class], [MainController class],
            nil];
}

- (void)dealloc {
    self.rdio = nil;
    [super dealloc];
}

- (void)setRdio:(Rdio *)rdio {
    rdio_ = rdio;
    self.rdio.delegate = self;
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
    [self.mainController loginDidSucceed];
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
