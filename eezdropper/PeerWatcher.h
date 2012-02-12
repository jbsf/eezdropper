#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "PeerWatcherDelegate.h"
#import "PlayerDelegate.h"

@class Peer;

@interface PeerWatcher : NSObject<GKSessionDelegate, PlayerDelegate>

- (id)initWithLocalPeer:(Peer *)localPeer delegate:(id<PeerWatcherDelegate>)delegate;
- (void)disconnect;

@end
