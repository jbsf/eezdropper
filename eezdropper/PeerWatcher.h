#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "PeerWatcherDelegate.h"
#import "PlayerDelegate.h"

@interface PeerWatcher : NSObject<GKSessionDelegate, PlayerDelegate>
- (id)initWithDelegate:(id<PeerWatcherDelegate>)delegate;
@end
