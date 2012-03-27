#import <UIKit/UIKit.h>
#import <Rdio/Rdio.h>
#import "Blindside.h"

@class MainController;

@interface LoginViewController : UIViewController<RdioDelegate>

@property (nonatomic, retain) Rdio *rdio;
@property (nonatomic, assign) MainController *mainController;
@property (nonatomic, assign) IBOutlet UIButton *loginButton;

- (IBAction) didTapLogin;

@end
