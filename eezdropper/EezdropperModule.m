#import "EezdropperModule.h"

#import <Rdio/Rdio.h>
#import "Blindside.h"
#import "Peer.h"
#import "PeerViewController.h"

@implementation EezdropperModule

+ (EezdropperModule *)module {
    return [[[EezdropperModule alloc] init] autorelease];
}

- (void)configure {
    [self bind:@"rdioConsumerKey" toInstance:@"deanv9w6s66jg45ghzeaxu6z"];
    [self bind:@"rdioSecret" toInstance:@"Qz2AWKDcSM"];
    [self bind:[Rdio class] withScope:[BSSingleton scope]];

    [self bind:@"loginViewNib" toInstance:@"LoginView"];
    
    [self bind:@"peerWatcherDelegate" toClass:[PeerViewController class] withScope:[BSSingleton scope]];
    
    [self bind:@"localPeer" toBlock: ^{
        Peer *localPeer = [[[Peer alloc] init] autorelease];
        NSDictionary *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"userData"];
        NSLog(@"booting. userData = %@", userData);
        
        localPeer.firstName = [userData objectForKey:@"firstName"];
        localPeer.lastName  = [userData objectForKey:@"lastName"];
        localPeer.rdioKey   = [userData objectForKey:@"key"];
        localPeer.iconURL   = [userData objectForKey:@"icon"];
        
        return localPeer;
    }];
}
@end
