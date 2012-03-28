#import "PeerWatcher.h"
#import "Peer.h"
#import "Track.h"
#import "Blindside.h"

@interface PeerWatcher ()

@property (nonatomic, retain) GKSession *session;
@property (nonatomic, assign) id<PeerWatcherDelegate> peerWatcherDelegate;
@property (nonatomic, retain) NSDictionary *peerNames;
@property (nonatomic, retain) Peer *localPeer;
@property (nonatomic, assign) NSTimer *timer;
@property (nonatomic, retain) NSMutableDictionary *pendingConnections;

- (NSString *)connectionState:(GKPeerConnectionState)state;
- (void)updatePeers;
- (void)logPeers:(GKPeerConnectionState)peerState;
- (void)logAllPeers;
- (void)startTimer;
- (NSString *)displayName;
- (void)initializeSession;
- (void)disconnectFromPeer:(NSString *)peerID;
- (void)connectToPeer:(NSString *)peerID;
- (void)connectToAvailablePeers;
- (void)cancelHungConnections;
- (void)cancelIfHung:(NSString *)peerID;
- (BOOL)connectionPendingFor:(NSString *)peerID;
@end

@implementation PeerWatcher 

@synthesize 
session = session_, 
peerWatcherDelegate = peerWatcherDelegate_,
localPeer = localPeer_,
timer = timer_,
pendingConnections = pendingConnections_,
peerNames = peerNames_;

+ (BSInitializer *)blindsideInitializer {
    return [BSInitializer initializerWithClass:self selector:selector argumentKeys:@"localPeer", @"peerWatcherDelegate", nil];
}

- (id)initWithLocalPeer:(Peer *)localPeer delegate:(id<PeerWatcherDelegate>)delegate {
    if (self = [super init]) {
        self.peerWatcherDelegate = delegate;
        self.localPeer = localPeer;
        self.pendingConnections = [NSMutableDictionary dictionary];
        [self initializeSession];
        [self startTimer];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"PeerWatcher dealloc");
    [self.timer invalidate];
    self.timer = nil;
    self.session = nil;
    self.peerNames = nil;
    self.localPeer = nil;
    self.pendingConnections = nil;
    [super dealloc];
}

- (void)disconnect {
    NSLog(@"disconnecting from all peers, localPeer id = %@", self.session.peerID);
    [self.peerWatcherDelegate allPeersDidLeave];
//    [self.session disconnectFromAllPeers];
    self.session = nil;
    [self.timer invalidate];
    self.timer = nil;
}

- (void)initializeSession {
    NSLog(@"initializeing session");
    [self disconnect];
    self.session = nil;
    self.session = [[[GKSession alloc] initWithSessionID:@"eezdropper" displayName:[UIDevice currentDevice].name sessionMode:GKSessionModePeer] autorelease];
    self.session.delegate = self;
    [self.session setDataReceiveHandler:self withContext:nil];
    self.session.available = YES;
    self.localPeer.identifier = self.session.peerID;
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
    NSLog(@"peer: %@ %@ did change state to: %@", [session displayNameForPeer:peerID], peerID, [self connectionState:state]); 
    [self logAllPeers];
    if (state == GKPeerStateAvailable) {
        [self connectToPeer:peerID];
    } else if (state == GKPeerStateUnavailable || state == GKPeerStateDisconnected) {
        NSLog(@"disconnecting from peer: %@ %@", [session displayNameForPeer:peerID], peerID);
        [self disconnectFromPeer:peerID];
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
    [self disconnectFromPeer:peerID];
    [self.session cancelConnectToPeer:peerID];
    [self.pendingConnections removeObjectForKey:peerID];
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
    NSLog(@"session did fail with error: %@", error);
    [self initializeSession];
}

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peerID inSession:(GKSession *)session context:(void *)context {
    NSLog(@"received data from peer: %@ of length: %d", peerID, data.length);
    Peer *peer = [Peer deserialize:data];
    NSLog(@"received data: %@ from peer: %@ %@", peer.name, [session displayNameForPeer:peerID], peerID);
    if (peer == nil) {
        NSLog(@"---------- error reading data from peer: %@", peerID);
    } else {
        [self.peerWatcherDelegate peerDidArrive:peer];
    }
}

- (void)connectToPeer:(NSString *)peerID {
    if (![self connectionPendingFor:peerID]) {
        NSLog(@"connecting to peer: %@ %@", [self.session displayNameForPeer:peerID], peerID);
        [self.session connectToPeer:peerID withTimeout:10];
        [self.pendingConnections setObject:[NSDate date] forKey:peerID];
    } else {
        [self cancelIfHung:peerID];
    }
}

- (void)connectToAvailablePeers {
    NSArray *peerIDs = [self.session peersWithConnectionState:GKPeerStateAvailable];
    for (NSString *peerID in peerIDs) {
        NSLog(@"Found available peer: %@", peerID);
        [self connectToPeer:peerID];
    }
}

- (void)disconnectFromPeer:(NSString *)peerID {
    NSLog(@"disconnecting peer: %@", peerID);
//    [self.session disconnectPeerFromAllPeers:peerID];
    Peer *peer = [[[Peer alloc] init] autorelease];
    peer.identifier = peerID;
    [self.peerWatcherDelegate peerDidLeave:peer];
}

- (void)cancelHungConnections {
    NSArray *peerIDs = [self.session peersWithConnectionState:GKPeerStateConnecting];
    for (NSString *peerID in peerIDs) {
        [self cancelIfHung:peerID];
    }    
}

- (BOOL)connectionPendingFor:(NSString *)peerID {
    return [self.pendingConnections objectForKey:peerID] != nil;
}

- (void)cancelIfHung:(NSString *)peerID {
    NSDate *startTime = [self.pendingConnections objectForKey:peerID];
    if (fabs([startTime timeIntervalSinceNow]) > 3) {
        NSLog(@"connection attempt to %@ is hung, cancelling", peerID);
        [self.session cancelConnectToPeer:peerID];
        [self.pendingConnections removeObjectForKey:peerID];
    }
}

- (void)updatePeers {    
    NSData *data = [self.localPeer serialize];
    NSError *error = nil;

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
    NSLog(@"logging all peers for local seesion %@", self.session.peerID);
    [self logPeers:GKPeerStateAvailable];
    [self logPeers:GKPeerStateConnected];
    [self logPeers:GKPeerStateConnecting];
    [self logPeers:GKPeerStateDisconnected];
    [self logPeers:GKPeerStateUnavailable];
    [self updatePeers];
    [self cancelHungConnections];
    [self connectToAvailablePeers];
}

- (void)logPeers:(GKPeerConnectionState)peerState {
    NSArray *peers = [self.session peersWithConnectionState:peerState];
    if ([peers count] > 0) {
        NSLog(@"%@ peers: %@", [self connectionState:peerState], peers);            
    }
}

- (void)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(logAllPeers) userInfo:nil repeats:YES];
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
    self.localPeer.track = nil;
    [self updatePeers];
}

@end
