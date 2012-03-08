#import <UIKit/UIKit.h>
#import <Rdio/Rdio.h>
#import "Blindside.h"

@class AppDelegate;

@interface LoginViewController : UIViewController<RdioDelegate>

@property (nonatomic, retain) Rdio *rdio;
@property (nonatomic, assign) AppDelegate *appDelegate;
@property (nonatomic, assign) IBOutlet UIButton *loginButton;

- (IBAction) didTapLogin;

@end
