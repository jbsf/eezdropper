#import <Foundation/Foundation.h>

@class Peer;

@protocol PeerWatcherDelegate <NSObject>

- (void)peerDidLeave:(Peer *)peer;
- (void)peerDidArrive:(Peer *)peer;
@end
