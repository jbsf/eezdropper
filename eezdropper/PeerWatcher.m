#import "PeerWatcher.h"
#import "Peer.h"

@interface PeerWatcher ()
- (NSString *)connectionState:(GKPeerConnectionState)state;
- (void)updatePeers:(GKSession *)session;
@end

@implementation PeerWatcher 

@synthesize gkSession = gkSession_, peerWatcherDelegate = peerWatcherDelegate_;

- (id)initWithDelegate:(id<PeerWatcherDelegate>)delegate {
    if (self = [super init]) {
        self.peerWatcherDelegate = delegate;
        self.gkSession = [[[GKSession alloc] initWithSessionID:@"eezdropper" displayName:[UIDevice currentDevice].name sessionMode:GKSessionModePeer] autorelease];
        self.gkSession.delegate = self;
        [self.gkSession setDataReceiveHandler:self withContext:nil];
        self.gkSession.available = YES;
    }
    return self;
}

- (void)dealloc {
    [gkSession_ release];
    [super dealloc];
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
    NSLog(@"peer: %@ %@ did change state to: %@", [session displayNameForPeer:peerID], peerID, [self connectionState:state]);        
    if (state == GKPeerStateAvailable) {
        NSLog(@"connecting to peer: %@ %@", [session displayNameForPeer:peerID], peerID);        
        [self.gkSession connectToPeer:peerID withTimeout:20];        
    } else if (state == GKPeerStateUnavailable || state == GKPeerStateDisconnected) {
        Peer *peer = [[[Peer alloc] initWithName:nil identifier:peerID track:nil] autorelease];
        [self.peerWatcherDelegate peerDidLeave:peer];
    }

    [self updatePeers:session];
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID {
    NSLog(@"did receive connection request from peer: %@ %@", [session displayNameForPeer:peerID], peerID);    
    NSError *error = nil;
    if (![self.gkSession acceptConnectionFromPeer:peerID error:&error]) {
        NSLog(@"error accepting connection from peer: %@ %@, %@", [session displayNameForPeer:peerID], peerID, [error description]);
    } else {
        NSLog(@"connection succeeded from peer: %@ %@", [session displayNameForPeer:peerID], peerID);
        [self updatePeers:session];
    }
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error {
    NSLog(@"connection with peer: %@ %@ failed with error:%@", [session displayNameForPeer:peerID], peerID, error);    
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
    NSLog(@"session did fail with error: %@", error);
}

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peerID inSession:(GKSession *)session context:(void *)context {
    NSString *peerName = [NSString stringWithUTF8String:[data bytes]];
    NSLog(@"received data: %@ from peer: %@ %@", peerName, [session displayNameForPeer:peerID], peerID);
    Peer *peer = [[[Peer alloc] initWithName:peerName identifier:peerName track:nil] autorelease];
    [self.peerWatcherDelegate peerDidArrive:peer];
}

- (void)updatePeers:(GKSession *)session {
    NSData *data = [session.displayName dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    
    if (![session sendDataToAllPeers:data withDataMode:GKSendDataUnreliable error:&error]) {
        NSLog(@"error sending data to peers: %@", error);
    }    
}

- (NSString *)connectionState:(GKPeerConnectionState)connectionState {
    switch(connectionState) {
        case GKPeerStateAvailable:
            return @"GKPeerStateAvailable";
        case GKPeerStateUnavailable:
            return @"GKPeerStateUnavailable";
        case GKPeerStateConnected:
            return @"GKPeerStateConnected";
        case GKPeerStateDisconnected:
            return @"GKPeerStateDisconnected";
        case GKPeerStateConnecting:
            return @"GKPeerStateConnecting";
    }
}

@end
