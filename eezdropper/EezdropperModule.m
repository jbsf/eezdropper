#import "EezdropperModule.h"

#import <Rdio/Rdio.h>
#import "Blindside.h"

@implementation EezdropperModule

+ (EezdropperModule *)module {
    return [[[EezdropperModule alloc] init] autorelease];
}

- (void)configure {
    [self bind:@"rdioConsumerKey" toInstance:@"deanv9w6s66jg45ghzeaxu6z"];
    [self bind:@"rdioSecret" toInstance:@"Qz2AWKDcSM"];
    [self bind:[Rdio class] withScope:[BSSingleton scope]];

    [self bind:@"loginViewNib" toInstance:@"LoginView"];
    
    [self bind:@"localPeer" toBlock:	
}
@end
