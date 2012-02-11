#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "PeerWatcherDelegate.h"

@interface PeerWatcher : NSObject<GKSessionDelegate>

@property (nonatomic, retain) GKSession *gkSession;
@property (nonatomic, assign) id<PeerWatcherDelegate> peerWatcherDelegate;

- (id)initWithDelegate:(id<PeerWatcherDelegate>)delegate;
@end
