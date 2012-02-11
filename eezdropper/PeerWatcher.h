#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "PeerWatcherDelegate.h"

@interface PeerWatcher : NSObject<GKSessionDelegate>
- (id)initWithDelegate:(id<PeerWatcherDelegate>)delegate;
@end
