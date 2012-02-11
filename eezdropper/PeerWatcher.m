#import "PeerWatcher.h"
#import "Peer.h"
#import "Track.h"

@interface PeerWatcher ()

@property (nonatomic, retain) GKSession *session;
@property (nonatomic, assign) id<PeerWatcherDelegate> peerWatcherDelegate;
@property (nonatomic, retain) NSDictionary *peerNames;
@property (nonatomic, retain) Peer *localPeer;

- (NSString *)connectionState:(GKPeerConnectionState)state;
- (void)updatePeers;
- (void)logPeers:(GKPeerConnectionState)peerState;
- (void)logAllPeers;
- (void)startTimer;
- (NSString *)displayName;
@end

@implementation PeerWatcher 

@synthesize 
session = session_, 
peerWatcherDelegate = peerWatcherDelegate_,
localPeer = localPeer_,
peerNames = peerNames_;

- (id)initWithLocalPeer:(Peer *)localPeer delegate:(id<PeerWatcherDelegate>)delegate {
    if (self = [super init]) {
        self.peerWatcherDelegate = delegate;
        self.session = [[[GKSession alloc] initWithSessionID:@"eezdropper" displayName:[UIDevice currentDevice].name sessionMode:GKSessionModePeer] autorelease];
        self.session.delegate = self;
        [self.session setDataReceiveHandler:self withContext:nil];
        self.session.available = YES;
        self.localPeer = localPeer;
        self.localPeer.identifier = self.session.peerID;
        [self startTimer];
    }
    return self;
}

- (void)dealloc {
    [session_ release];
    [peerNames_ release];
    [localPeer_ release];
    [super dealloc];
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
    NSLog(@"peer: %@ %@ did change state to: %@", [session displayNameForPeer:peerID], peerID, [self connectionState:state]);        
    if (state == GKPeerStateAvailable) {
        NSLog(@"connecting to peer: %@ %@", [session displayNameForPeer:peerID], peerID);        
        [self.session connectToPeer:peerID withTimeout:20];        
    } else if (state == GKPeerStateUnavailable || state == GKPeerStateDisconnected) {
        NSLog(@"notifying peer did leave: %@ %@", [session displayNameForPeer:peerID], peerID);
        Peer *peer = [[[Peer alloc] init] autorelease];
        peer.identifier = peerID;
        [self.peerWatcherDelegate peerDidLeave:peer];
    }

    [self updatePeers];
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID {
    NSLog(@"did receive connection request from peer: %@ %@", [session displayNameForPeer:peerID], peerID);    
    NSError *error = nil;
    if (![self.session acceptConnectionFromPeer:peerID error:&error]) {
        NSLog(@"error accepting connection from peer: %@ %@, %@", [session displayNameForPeer:peerID], peerID, [error description]);
    } else {
        NSLog(@"connection succeeded from peer: %@ %@", [session displayNameForPeer:peerID], peerID);
        [self updatePeers];
    }
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error {
    NSLog(@"connection with peer: %@ %@ failed with error:%@", [session displayNameForPeer:peerID], peerID, error);    
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
    NSLog(@"session did fail with error: %@", error);
}

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peerID inSession:(GKSession *)session context:(void *)context {
    Peer *peer = [Peer deserialize:data];
    NSLog(@"received data: %@ from peer: %@ %@", peer.name, [session displayNameForPeer:peerID], peerID);
    [self.peerWatcherDelegate peerDidArrive:peer];
}

- (void)updatePeers {    
    NSData *data = [self.localPeer serialize];
    NSError *error = nil;
    
    Peer *peer = [Peer deserialize:data];
    NSLog(@"deserialized peer: %@", peer);
    NSLog(@"  equals: %d", [peer isEqual:self.localPeer]);

    NSLog(@"%@ %@ updating peers with data", self.session.peerID, self.displayName);

    if (![self.session sendDataToAllPeers:data withDataMode:GKSendDataReliable error:&error]) {
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

- (void)logAllPeers {
    [self logPeers:GKPeerStateAvailable];
    [self logPeers:GKPeerStateConnected];
    [self logPeers:GKPeerStateConnecting];
    [self logPeers:GKPeerStateDisconnected];
    [self logPeers:GKPeerStateUnavailable];
    [self updatePeers];
}

- (void)logPeers:(GKPeerConnectionState)peerState {
    NSArray *peers = [self.session peersWithConnectionState:peerState];
    if ([peers count] > 0) {
        NSLog(@"%@ peers: %@", [self connectionState:peerState], peers);            
    }
}

- (void)startTimer {
    [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(logAllPeers) userInfo:nil repeats:YES];
}

- (NSString *)displayName {
    return [UIDevice currentDevice].name;
}

#pragma mark PlayerDelegate 

- (void)playerDidStart:(Track *)track {
    NSLog(@"peerWatcher playerDidStart track name: %@", track.name);
    self.localPeer.track = track;    
    [self updatePeers];
}

- (void)playerDidPause {
    
}

@end
