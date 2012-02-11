#import "PeerViewController.h"
#import "Peer.h"
#import "Track.h"
#import "PlayerController.h"

@interface PeerViewController ()
@property (nonatomic, retain) PlayerController *playerController;
@property (nonatomic, retain) NSMutableArray *peers;
@end

@implementation PeerViewController

@synthesize 
peers = peers_,
playerController = playerController_;

- (id)initWithPlayerController:(PlayerController *)playerController {
    if (self = [super init]) {
        self.playerController = playerController;
        self.peers = [NSMutableArray array];
    }
    return self;    
}

- (void)dealloc {
    [peers_ release];
    [playerController_ release];
    [super dealloc];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.peers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PeerCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    Peer *peer = [self.peers objectAtIndex:indexPath.row];
    NSString *trackName = peer.track ? [NSString stringWithFormat:@" - %@", peer.track.name] : @"";
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@", peer.name, trackName];
    
    return cell;
}

#pragma mark PeerWatcherDelegage 

- (void)peerDidLeave:(Peer *)peer {
    [self.peers removeObject:peer];
    [self.tableView reloadData];
}

- (void)peerDidArrive:(Peer *)peer {
    NSUInteger index = [self.peers indexOfObject:peer];
    if (index == NSNotFound) {
        [self.peers addObject:peer];
    } else {
        [self.peers replaceObjectAtIndex:index withObject:peer];
    }

    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Peer *peer = [self.peers objectAtIndex:indexPath.row];
    [self.playerController playTrack:peer.track];    
}

@end
