#import "PeerViewController.h"
#import "Peer.h"
#import "Track.h"
#import "PlayerController.h"
#import "AsyncImageView.h"

@interface PeerViewController ()
@property (nonatomic, retain) PlayerController *playerController;
@property (nonatomic, retain) NSMutableArray *peers;

- (void)shrinkLabel:(UILabel *)label;
@end

@implementation PeerViewController

@synthesize
tableViewCell = tableViewCell_,
contentView = contentView_,
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

- (void)viewDidLoad {
    self.tableView.backgroundColor = [UIColor colorWithRed:163/255.0 green:179/255.0 blue:193/255.0 alpha:1.0];
    self.tableView.separatorColor = [UIColor colorWithRed:163/255.0 green:179/255.0 blue:193/255.0 alpha:1.0];
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
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"TrackView" owner:self options:nil];
        cell = self.tableViewCell;
        [cell.contentView addSubview:self.contentView];
        self.tableViewCell = nil;
        self.contentView = nil;
    } else {
        AsyncImageView* oldArtistImage = (AsyncImageView*) [cell.contentView viewWithTag:999];
        [oldArtistImage removeFromSuperview];
        AsyncImageView* oldPeerImage = (AsyncImageView*) [cell.contentView viewWithTag:998];
        [oldPeerImage removeFromSuperview];
    }
    
    UIView *realContentView = [cell.contentView.subviews lastObject];
    UILabel *topLabel    = (UILabel *)[realContentView viewWithTag:1];
    UILabel *bottomLabel = (UILabel *)[realContentView viewWithTag:2];
    [self shrinkLabel:topLabel];
    [self shrinkLabel:bottomLabel];
    
    Peer *peer = [self.peers objectAtIndex:indexPath.row];
    
    CGRect frame = CGRectMake(5, 4, 30, 30);
	AsyncImageView* artistImage = [[[AsyncImageView alloc] initWithFrame:frame] autorelease];    
	artistImage.tag = 999;
	[artistImage loadImageFromURL:[NSURL URLWithString:peer.track.iconURL]];
	[realContentView addSubview:artistImage];
    
    frame = CGRectMake(285, 4, 30, 30);
	AsyncImageView* peerImage = [[[AsyncImageView alloc] initWithFrame:frame] autorelease];    
	peerImage.tag = 998;
	[peerImage loadImageFromURL:[NSURL URLWithString:peer.iconURL]];
	[realContentView addSubview:peerImage];
    
    topLabel.text = peer.track.name;
    bottomLabel.text = peer.track.artist;
    
    return cell;
}

- (void)shrinkLabel:(UILabel *)label {
    CGRect frame = label.frame;
    label.frame = CGRectMake(frame.origin.x, frame.origin.y, 240, frame.size.height);
}

#pragma mark PeerWatcherDelegage 

- (void)peerDidLeave:(Peer *)peer {
    [self.peers removeObject:peer];
    [self.tableView reloadData];
}

- (void)allPeersDidLeave {
    NSLog(@"allPeersDidLeave; removing all objects");
    [self.peers removeAllObjects];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

@end
